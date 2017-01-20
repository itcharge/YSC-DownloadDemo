//
//  NSURLSessionBlockDownloadFileViewController.m
//  YSC-DownloadDemo
//
//  Created by YangShiChao on 2017/1/18.
//  Copyright © 2017年 lianai911. All rights reserved.
//

#import "NSURLSessionBlockDownloadFileViewController.h"

@interface NSURLSessionBlockDownloadFileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NSURLSessionBlockDownloadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"NSURLSession的block方法下载文件";
}

/**
 * 点击按钮 -- 使用NSURLSession的block方法下载文件
 */
- (IBAction)downloadBtnClicked:(UIButton *)sender {
    // 创建下载路径
    NSURL *url = [NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201508/apic14052.jpg"];
    
    // 创建NSURLSession对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建下载任务,其中location为下载的临时文件路径
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        // 文件将要移动到的指定目录
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        // 新文件路径
        NSString *newFilePath = [documentsPath stringByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
        
        NSLog(@"File downloaded to: %@",newFilePath);
        // 移动文件到新路径
        [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:newFilePath error:nil];
        
    }];
    
    // 开始下载任务
    [downloadTask resume];
}

@end
