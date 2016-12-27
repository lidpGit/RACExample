//
//  RACRequest.h
//  Test
//
//  Created by lidp on 2016/12/22.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGet,
    RequestMethodPost
};

extern NSString *const api_domain;

@interface RACRequest : NSObject

+ (RACRequest *)sharedInstance;

- (RACSignal *)requestWithMethod:(RequestMethod)method command:(NSString *)command params:(NSDictionary *)params;

@end
