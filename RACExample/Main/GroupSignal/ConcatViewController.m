//
//  ConcatViewController.m
//  RACExample
//
//  Created by lidp on 2016/12/26.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "ConcatViewController.h"

@interface ConcatViewController ()

@end

@implementation ConcatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [[self.operateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self concat];
    }];
}

- (void)concat{
    //每一个信号都必须调用sendCompleted，否则不会往下执行
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"第一步"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"第二步"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"第三步"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [[RACSignal concat:@[signalA, signalB, signalC]] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
