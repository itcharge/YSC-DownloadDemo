//
//  NSURLSessionOfflineResumeDownloadFileViewController.m
//  YSC-DownloadDemo
//
//  Created by YangShiChao on 2017/1/19.
//  Copyright © 2017年 lianai911. All rights reserved.
//

#import "NSURLSessionOfflineResumeDownloadFileViewController.h"

@interface NSURLSessionOfflineResumeDownloadFileViewController () <NSURLSessionDataDelegate>

/** 下载进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/** 下载进度条Label */
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

/** NSURLSession断点下载（支持离线）需用到的属性 **********/
/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;
/** session */
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation NSURLSessionOfflineResumeDownloadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"NSURLSession断点下载（支持离线）";
}

/**
 * session的懒加载
 */
- (NSURLSession *)session
{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

/**
 * downloadTask的懒加载，这里设置请求头中的Range
 */
- (NSURLSessionDataTask *)downloadTask {
    if (!_downloadTask) {
        // 创建下载URL
        NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
        
        // 2.创建request请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        // 设置HTTP请求头中的Range
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        // 3. 下载
        _downloadTask = [self.session dataTaskWithRequest:request];
    }
    return _downloadTask;
}

/**
 * 点击按钮 -- 使用NSURLSession断点下载（支持离线）
 */
- (IBAction)OfflinResumeDownloadBtnClicked:(UIButton *)sender {
    // 按钮状态取反
    sender.selected = !sender.isSelected;
    
    if (sender.selected) { // [开始下载/继续下载]
        // 沙盒文件路径
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
        
        NSInteger currentLength = [self fileLengthForPath:path];
        if (currentLength > 0) {  // [继续下载]
            self.currentLength = currentLength;
        }
        
        [self.downloadTask resume];
        
    } else {
        [self.downloadTask suspend];
        self.downloadTask = nil;
    }
}

/**
 * 获取已下载的文件大小
 */
- (NSInteger)fileLengthForPath:(NSString *)path {
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

#pragma mark - <NSURLSessionDataDelegate> 实现方法
/**
 * 接收到响应的时候：创建一个空的沙盒文件
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
    self.fileLength = response.expectedContentLength + self.currentLength;
    
    // 沙盒文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
    
    NSLog(@"File downloaded to: %@",path);
    
    // 创建一个空的文件到沙盒中
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:path]) {
        // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
        [manager createFileAtPath:path contents:nil attributes:nil];
    }
    
    // 创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];

    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到具体数据：把数据写入沙盒文件中
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 指定数据的写入位置 -- 文件内容的最后面
    [self.fileHandle seekToEndOfFile];
    
    // 向沙盒写入数据
    [self.fileHandle writeData:data];
    
    // 拼接文件总长度
    self.currentLength += data.length;
    
    NSLog(@"%ld",self.currentLength);
    
    __weak typeof(self) weakSelf = self;
    // 获取主线程，不然无法正确显示进度。
    NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
    [mainQueue addOperationWithBlock:^{
        // 下载进度
        weakSelf.progressView.progress =  1.0 * weakSelf.currentLength / weakSelf.fileLength;
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * self.currentLength / self.fileLength];
    }];
}

/**
 *  下载完文件之后调用：关闭文件、清空长度
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    // 关闭fileHandle
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
    // 清空长度
    self.currentLength = 0;
    self.fileLength = 0;
}

@end
