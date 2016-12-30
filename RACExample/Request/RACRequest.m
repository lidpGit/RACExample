//
//  RACRequest.m
//  Test
//
//  Created by lidp on 2016/12/22.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "RACRequest.h"

NSString *const api_domain = @"";

@implementation RACRequest

+ (RACRequest *)sharedInstance{
    static RACRequest *request;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[RACRequest alloc] init];
    });
    return request;
}

- (RACSignal *)requestWithMethod:(RequestMethod)method command:(NSString *)command params:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *requestURL = [api_domain stringByAppendingString:command];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        if (method == RequestMethodGet) {
            //GET请求
            [manager GET:requestURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendError:error];
            }];
        }else{
            //POST请求
            [manager POST:requestURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendError:error];
            }];
        }
        
        return nil;
    }];
}

@end
