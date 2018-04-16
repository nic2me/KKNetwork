//
//  KKNetwork.h
//  KKNetwork
//
//  Created by 茹赟 on 2018/4/15.
//  Copyright © 2018年 茹赟. All rights reserved.
//



#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, NetworkStatus){
    StatusUnknown           = -1, //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
};
typedef NSURLSessionTask KKSessionTask;
typedef void(^KKResponseSeccessBlock)(id response);
typedef void(^KKResponseFailBlock)(NSError *error);
typedef void(^KKDownloadProgress)(int64_t bytesRead, int64_t totalBytes);


@interface KKNetwork : NSObject
+(KKSessionTask *)getWithUrl:(NSString *)url
                      params:(NSDictionary *)param
               progressBlock:(KKDownloadProgress)progressBlock
                     success:(KKResponseSeccessBlock)successBlock
                        fail:(KKResponseFailBlock)failBlock;
+(KKSessionTask *)postWithUrl:(NSString *)url
                       params:(NSDictionary *)param
                progressBlock:(KKDownloadProgress)progressBlock
                      success:(KKResponseSeccessBlock)successBlock
                         fail:(KKResponseFailBlock)failBlock;
@end
