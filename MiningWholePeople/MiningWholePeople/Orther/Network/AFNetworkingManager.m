//
//  AFNetworkingManager.m
//  JJSliderViewController
//
//  Created by FANS on 2020/6/19.
//  Copyright © 2020 罗文琦. All rights reserved.
//

#import "AFNetworkingManager.h"

NSInteger const kAFNetworkingTimeoutInterval = 10;

@implementation AFNetworkingManager

+ (void)requestWithType:(SkyHttpRequestType)type
              urlString:(NSString *)urlString
             parameters:(NSDictionary *_Nullable)parameters
           successBlock:(SkyHTTPRequestSuccessBlock)successBlock
           failureBlock:(SkyHTTPRequestFailedBlock)failureBlock
{
    AFHTTPSessionManager *aManager = [AFHTTPSessionManager manager];
    aManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/json",@"text/plain",@"text/JavaScript",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
    aManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    aManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    aManager.requestSerializer.timeoutInterval = kAFNetworkingTimeoutInterval;
    UserInfo *userInfo = [Utilities GetNSUserDefaults];
    if (userInfo.token){
        [aManager.requestSerializer setValue:userInfo.token forHTTPHeaderField:@"token"];
        
    }
    if (userInfo.lang){
        [aManager.requestSerializer setValue:userInfo.lang forHTTPHeaderField:@"lang"];
    }
    
    if (urlString == nil)
    {
        return;
    }
    
    if (type == SkyHttpRequestTypeGet)
    {
        [aManager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock)
            {
                NSError *error = nil;
                NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
                NSLog(@"%@",jsonObject);
                successBlock(jsonObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code !=-999) {
                if (failureBlock)
                {
                    failureBlock(error);
                }
            }
            else{
                NSLog(@"取消队列了");
            }
        }];
    }
    
    if (type == SkyHttpRequestTypePost)
    {
        [aManager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock)
            {
                NSError *error = nil;
                NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
                NSLog(@"%@",jsonObject);
                successBlock(jsonObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code !=-999) {
                if (failureBlock)
                {
                    failureBlock(error);
                }
            }
            else{
                NSLog(@"取消队列了");
            }
        }];
    }
}

@end
