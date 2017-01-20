//
//  NSURLSessionResumeDownloadFileViewController.m
//  YSC-DownloadDemo
//
//  Created by YangShiChao on 2017/1/18.
//  Copyright © 2017年 lianai911. All rights reserved.
//

#import "NSURLSessionResumeDownloadFileViewController.h"

@interface NSURLSessionResumeDownloadFileViewController () <NSURLSessionDownloadDelegate>

/** 下载进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/** 下载进度条Label */
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

/** NSURLSession断点下载（不支持离线）需用到的属性 **********/
/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
/** 保存上次的下载信息 */
@property (nonatomic, strong) NSData *resumeData;

/** session */
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation NSURLSessionResumeDownloadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"NSURLSession断点下载（不支持离线）";
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
 * 点击按钮 -- 使用NSURLSession断点下载（不支持离线）
 */
- (IBAction)resumeDownloadBtnClicked:(UIButton *)sender {
    // 按钮状态取反
    sender.selected = !sender.isSelected;
    
    if (nil == self.downloadTask) { // [开始下载/继续下载]
        if (self.resumeData) { // [继续下载]
            // 传入上次暂停下载返回的数据，就可以恢复下载
            self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
            
            // 开始任务
            [self.downloadTask resume];
            
            self.resumeData = nil;
        }else{ // [开始下载]：从0开始下载
            NSURL* url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
            
            // 创建任务
            self.downloadTask = [self.session downloadTaskWithURL:url];
            
            // 开始任务
            [self.downloadTask resume];
        }
        
    }else{ // [暂停下载]
        __weak typeof(self) weakSelf = self;
        [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            // resumeData：包含了继续下载的位置\下载的路径
            weakSelf.resumeData = resumeData;
            weakSelf.downloadTask = nil;
        }];
    }
}

#pragma mark <NSURLSessionDownloadDelegate> 实现方法
/**
 *  文件下载完毕时调用
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    // 文件将要移动到的指定目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    // 新文件路径
    NSString *newFilePath = [documentsPath stringByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
    
    NSLog(@"File downloaded to: %@",newFilePath);
    
    // 移动文件到新路径
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:newFilePath error:nil];
    
}

/**
 *  每次写入数据到临时文件时，就会调用一次这个方法。可在这里获得下载进度
 *
 *  @param bytesWritten              这次写入的文件大小
 *  @param totalBytesWritten         已经写入沙盒的文件大小
 *  @param totalBytesExpectedToWrite 文件总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // 下载进度
    self.progressView.progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    self.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * totalBytesWritten / totalBytesExpectedToWrite];
}

/**
 *  恢复下载后调用
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

@end
