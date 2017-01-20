//
//  ViewController.m
//  YSC-DownloadDemo
//
//  Created by YangShiChao on 2017/1/18.
//  Copyright © 2017年 lianai911. All rights reserved.
//

#import "ViewController.h"
#import "NSDataDownloadSmallFileViewController.h"
#import "NSURLConnectionDownloadSmallFileViewController.h"
#import "NSURLConnectionDownloadBigFileViewController.h"
#import "NSURLConnectionResumeDownloadFileViewController.h"
#import "NSURLSessionBlockDownloadFileViewController.h"
#import "NSURLSessionDelegateDownloadFileViewController.h"
#import "NSURLSessionResumeDownloadFileViewController.h"
#import "NSURLSessionOfflineResumeDownloadFileViewController.h"
#import "AFNetworkingDownloadFileViewController.h"
#import "AFNetworkingOfflineResumeDownloadFileViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
}


/**
 * NSData下载小文件Demo页按钮
 */
- (IBAction)NSDataDownloadSmallFileBtnClicked:(UIButton *)sender {
    
    NSDataDownloadSmallFileViewController *VC = [[NSDataDownloadSmallFileViewController alloc] init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 * NSURLConnection下载小文件Demo页按钮
 */
- (IBAction)NSURLConnectionDownloadSmallFileBtnClicked:(UIButton *)sender {
    NSURLConnectionDownloadSmallFileViewController *VC = [[NSURLConnectionDownloadSmallFileViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 * NSURLConnection下载大文件Demo页按钮
 */
- (IBAction)NSURLConnectionDownloadBigFileBtnClicked:(UIButton *)sender {
    NSURLConnectionDownloadBigFileViewController *VC = [[NSURLConnectionDownloadBigFileViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 * NSURLConnection断点下载（支持离线）Demo页按钮
 */
- (IBAction)NSURLConnectionResumeDownloadFileBtnClicked:(UIButton *)sender {
    NSURLConnectionResumeDownloadFileViewController *VC = [[NSURLConnectionResumeDownloadFileViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 * NSURLSession的block方法下载文件Demo页按钮
 */
- (IBAction)NSURLSessionBlockDownloadFileBtnClicked:(UIButton *)sender {
    NSURLSessionBlockDownloadFileViewController *VC = [[NSURLSessionBlockDownloadFileViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 * NSURLSession的delegate方法下载文件Demo页按钮
 */
- (IBAction)NSURLSessionDelegateDownloadFileBtnClicked:(UIButton *)sender {
    NSURLSessionDelegateDownloadFileViewController *VC = [[NSURLSessionDelegateDownloadFileViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 * NSURLSession断点下载（不支持离线）Demo页按钮
 */
- (IBAction)NSURLSessionResumeDownloadFileBtnClicked:(UIButton *)sender {
    NSURLSessionResumeDownloadFileViewController *VC = [[NSURLSessionResumeDownloadFileViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 * NSURLSession断点下载（支持离线）Demo页按钮
 */
- (IBAction)NSURLSessionOfflineResumeDownloadFileBtnClicked:(UIButton *)sender {
    NSURLSessionOfflineResumeDownloadFileViewController *VC = [[NSURLSessionOfflineResumeDownloadFileViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 * AFNetworking下载文件Demo页按钮
 */
- (IBAction)AFNetworkingDownloadFileBtnClicked:(UIButton *)sender {
    AFNetworkingDownloadFileViewController *VC = [[AFNetworkingDownloadFileViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 * AFNetworking断点下载（支持离线）Demo页按钮
 */
- (IBAction)AFNetworkingOfflineResumeDownloadFileBtnClicked:(UIButton *)sender {
    AFNetworkingOfflineResumeDownloadFileViewController *VC = [[AFNetworkingOfflineResumeDownloadFileViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}


@end
