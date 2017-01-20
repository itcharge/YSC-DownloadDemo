//
//  NSURLConnectionDownloadBigFileViewController.m
//  YSC-DownloadDemo
//
//  Created by YangShiChao on 2017/1/18.
//  Copyright © 2017年 lianai911. All rights reserved.
//

#import "NSURLConnectionDownloadBigFileViewController.h"

@interface NSURLConnectionDownloadBigFileViewController () <NSURLConnectionDataDelegate>

/** 下载进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/** 下载进度条Label */
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;


/** NSURLConnection下载大文件需用到的属性 **********/
/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

@end

@implementation NSURLConnectionDownloadBigFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"NSURLConnection下载大文件";
}

/**
 * 点击按钮 -- 使用NSURLConnection下载大文件
 */
- (IBAction)downloadBtnClicked:(UIButton *)sender {
    // 创建下载路径
    NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
    // NSURLConnection发送异步Get请求，并实现相应的代理方法，该方法iOS9.0之后废除了。
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
}

#pragma mark <NSURLConnectionDataDelegate> 实现方法

/**
 * 接收到响应的时候：创建一个空的沙盒文件
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 获得下载文件的总长度
    self.fileLength = response.expectedContentLength;
    
    // 沙盒文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
    
    NSLog(@"File downloaded to: %@",path);
    
    // 创建一个空的文件到沙盒中
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    
    // 创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
}

/**
 * 接收到具体数据：把数据写入沙盒文件中
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 指定数据的写入位置 -- 文件内容的最后面
    [self.fileHandle seekToEndOfFile];
    
    // 向沙盒写入数据
    [self.fileHandle writeData:data];
    
    // 拼接文件总长度
    self.currentLength += data.length;
    
    // 下载进度
    self.progressView.progress =  1.0 * self.currentLength / self.fileLength;
    self.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * self.currentLength / self.fileLength];
}

/**
 *  下载完文件之后调用：关闭文件、清空长度
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 关闭fileHandle
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
    // 清空长度
    self.currentLength = 0;
    self.fileLength = 0;
}

@end
