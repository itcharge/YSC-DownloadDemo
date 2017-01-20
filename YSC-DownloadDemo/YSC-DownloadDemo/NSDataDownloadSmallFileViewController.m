//
//  NSDataDownloadSmallFileViewController.m
//  YSC-DownloadDemo
//
//  Created by YangShiChao on 2017/1/18.
//  Copyright © 2017年 lianai911. All rights reserved.
//

#import "NSDataDownloadSmallFileViewController.h"

@interface NSDataDownloadSmallFileViewController ()

/** 显示下载图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NSDataDownloadSmallFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"NSData下载小文件";
}

/**
 * 点击按钮 -- 使用NSData下载图片文件，并显示再imageView上
 */
- (IBAction)downloadBtnClick:(UIButton *)sender {
    
    // 在子线程中发送下载文件请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 创建下载路径
        NSURL *url = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/1877784-b4777f945878a0b9.jpg"];
        
        // NSData的dataWithContentsOfURL:方法下载
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // 回到主线程，刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = [UIImage imageWithData:data];
        });
    });
}


@end
