//
//  NSURLConnectionDownloadSmallFileViewController.m
//  YSC-DownloadDemo
//
//  Created by YangShiChao on 2017/1/18.
//  Copyright © 2017年 lianai911. All rights reserved.
//

#import "NSURLConnectionDownloadSmallFileViewController.h"

@interface NSURLConnectionDownloadSmallFileViewController ()

/** 显示下载图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NSURLConnectionDownloadSmallFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"NSURLConnection下载小文件";
}

/**
 * 点击按钮 -- 使用NSURLConnection下载图片文件，并显示再imageView上
 */
- (IBAction)downloadBtnClicked:(UIButton *)sender {
    // 创建下载路径
    NSURL *url = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/1877784-b4777f945878a0b9.jpg"];
    
    // NSURLConnection发送异步Get请求，该方法iOS9.0之后就废除了，推荐NSURLSession
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        self.imageView.image = [UIImage imageWithData:data];
        
        // 可以在这里把下载的文件保存
    }];

}

@end
