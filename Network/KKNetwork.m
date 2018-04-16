//
//  KKNetwork.m
//  KKNetwork
//
//  Created by 茹赟 on 2018/4/15.
//  Copyright © 2018年 茹赟. All rights reserved.
//

#import "KKNetwork.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
@interface KKNetwork()

@end

static NetworkStatus networkStatus;
static NSMutableArray *tasks;
@implementation KKNetwork
#pragma mark------------懒加载，网络请求队列
+(NSMutableArray *)tasks
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}
+(AFHTTPSessionManager *)httpManager
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    //默认解析器
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    //配置响应序列化
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    [self checkNetworkStatus];
    return manager;
}
#pragma mark - 检查网络
+(void)checkNetworkStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = StatusNotReachable;
                break;
            case AFNetworkReachabilityStatusUnknown:
                networkStatus = StatusUnknown;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus = StatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus = StatusReachableViaWiFi;
                break;
            default:
                networkStatus = StatusUnknown;
                break;
        }
        
    }];
}
+(NSString *)strUTF8Encoding:(NSString *)str{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark - get
+(KKSessionTask *)baseRequestType:(NSUInteger)type
                              url:(NSString *)url
                    params:(NSDictionary *)params
               progressBlock:(KKDownloadProgress)progressBlock
                   success:(KKResponseSeccessBlock)successBlock
                      fail:(KKResponseFailBlock)failBlock
{
    AFHTTPSessionManager *manager=[self httpManager];
    
//    if(networkStatus == StatusNotReachable || url==nil)
//    {
//        return nil;
//    }
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    
    
    KKSessionTask *sessionTask=nil;
    if(type==1)
    {
        sessionTask = [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress){
            if (progressBlock)
            {
                progressBlock(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock){
                successBlock(responseObject);
            }
            [[self tasks] removeObject:sessionTask];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failBlock){
                failBlock(error);
            }
            [[self tasks] removeObject:sessionTask];
        }];
    }else
    {
        sessionTask = [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress){
            if (progressBlock)
            {
                progressBlock(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock){
                successBlock(responseObject);
            }
            [[self tasks] removeObject:sessionTask];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failBlock){
                failBlock(error);
            }
            [[self tasks] removeObject:sessionTask];
        }];
    }
    
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    return sessionTask;
}
+(KKSessionTask *)getWithUrl:(NSString *)url
                      params:(NSDictionary *)param
               progressBlock:(KKDownloadProgress)progressBlock
                     success:(KKResponseSeccessBlock)successBlock
                        fail:(KKResponseFailBlock)failBlock
{
    return [self baseRequestType:1 url:url params:param progressBlock:progressBlock success:successBlock fail:failBlock];
}
+(KKSessionTask *)postWithUrl:(NSString *)url
                       params:(NSDictionary *)param
                progressBlock:(KKDownloadProgress)progressBlock
                      success:(KKResponseSeccessBlock)successBlock
                         fail:(KKResponseFailBlock)failBlock
{
   return [self baseRequestType:2 url:url params:param progressBlock:progressBlock success:successBlock fail:failBlock];
}
@end
