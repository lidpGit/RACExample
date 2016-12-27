//
//  LoginViewModel.m
//  Test
//
//  Created by lidp on 2016/12/22.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}

- (RACCommand *)loginCommand{
    if (!_loginCommand) {
        @weakify(self);
        _loginCommand = [[RACCommand alloc] initWithEnabled:self.validInfoSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self startLogin];
        }];
    }
    return _loginCommand;
}

//验证信息格式是否正确(用户名长度>=3并且密码长度>= 6)
- (RACSignal *)validInfoSignal{
    if (!_validInfoSignal) {
        _validInfoSignal = [RACSignal combineLatest:@[RACObserve(self, name), RACObserve(self, password)] reduce:^id(NSString *name, NSString *password){
            return @(name.length >= 3 && password.length >= 6);
        }];
    }
    return _validInfoSignal;
}

//模拟登录,延迟3秒发送处理结果信号
- (RACSignal *)startLogin{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        self.status = @"登录中...";
        [[[RACSignal interval:3 onScheduler:[RACScheduler mainThreadScheduler]] take:1] subscribeNext:^(id x) {
            if ([self.name isEqualToString:@"lidp"] && [self.password isEqualToString:@"123456"]) {
                [subscriber sendNext:@YES];
                self.status = @"登录成功";
            }else{
                [subscriber sendNext:@NO];
                self.status = @"用户名或密码错误";
            }
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

@end
