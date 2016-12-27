//
//  LiftViewController.m
//  RACExample
//
//  Created by lidp on 2016/12/26.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "LiftViewController.h"

@interface LiftViewController ()

@end

@implementation LiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [[self.operateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self lift];
    }];
}

- (void)lift{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"请求1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"请求2"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateUIWithParamA:paramB:) withSignalsFromArray:@[signalA, signalB]];
}

//withSignalsFromArray: 传的几个信号，此方法就要用几个参数
- (void)updateUIWithParamA:(id)paramA paramB:(id)paramB{
    NSLog(@"paramA = %@, paramB = %@", paramA, paramB);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
