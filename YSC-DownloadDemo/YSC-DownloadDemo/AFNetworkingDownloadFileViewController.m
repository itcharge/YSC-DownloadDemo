//
//  AFNetworkingDownloadFileViewController.m
//  YSC-DownloadDemo
//
//  Created by YangShiChao on 2017/1/19.
//  Copyright © 2017年 lianai911. All rights reserved.
//

#import "AFNetworkingDownloadFileViewController.h"
#import <AFNetworking.h>

@interface AFNetworkingDownloadFileViewController ()

/** 下载进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/** 下载进度条Label */
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation AFNetworkingDownloadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"AFNetworking下载文件";
}

/**
 * 点击按钮 -- 使用AFNetworking下载文件
 */
- (IBAction)downloadBtnClicked:(UIButton *)sender {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 1. 创建会话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 2. 创建下载路径和请求对象
    NSURL *URL = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // 3.创建下载任务
    /**
     * 第一个参数 - request：请求对象
     * 第二个参数 - progress：下载进度block
     *      其中： downloadProgress.completedUnitCount：已经完成的大小
     *            downloadProgress.totalUnitCount：文件的总大小
     * 第三个参数 - destination：自动完成文件剪切操作
     *      其中： 返回值:该文件应该被剪切到哪里
     *            targetPath：临时路径 tmp NSURL
     *            response：响应头
     * 第四个参数 - completionHandler：下载完成回调
     *      其中： filePath：真实路径 == 第三个参数的返回值
     *            error:错误信息
     */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        
        __weak typeof(self) weakSelf = self;
        // 获取主线程，不然无法正确显示进度。
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            // 下载进度
            weakSelf.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
        }];
        
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [path URLByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSLog(@"File downloaded to: %@", filePath);
    }];

    // 4. 开启下载任务
    [downloadTask resume];
}


@end
