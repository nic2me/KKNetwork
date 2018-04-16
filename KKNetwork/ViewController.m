//
//  ViewController.m
//  KKNetwork
//
//  Created by 茹赟 on 2018/4/15.
//  Copyright © 2018年 茹赟. All rights reserved.
//

#import "ViewController.h"
#import "KKNetwork.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [KKNetwork getWithUrl:@"http://news-at.zhihu.com/api/4/news/latest"
                   params:nil
            progressBlock:^(int64_t bytesRead, int64_t totalBytes)
    {
        NSLog(@"%lld--%lld",bytesRead,totalBytes);
        
    }
                  success:^(id response)
    {
                      NSLog(@"---->%@",response);
        
    }
                  fail:^(NSError *error)
    {
                NSLog(@"=====>%@",error);
    }];
}
@end
