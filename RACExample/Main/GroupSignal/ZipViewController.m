//
//  ZipViewController.m
//  RACExample
//
//  Created by lidp on 2016/12/26.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "ZipViewController.h"

@interface ZipViewController ()

@end

@implementation ZipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [[self.operateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self zip];
    }];
}

- (void)zip{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id subscriber) {
//        [subscriber sendCompleted];
        [subscriber sendNext:@"A -- 1"];
        [subscriber sendNext:@"A -- 2"];
        [subscriber sendNext:@"A -- 3"];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"B -- 1"];
        [subscriber sendNext:@"B -- 2"];
        return nil;
    }];
    
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"C -- 1"];
        return nil;
    }];
    
    //zip
    [[RACSignal zip:@[signalA, signalB, signalC]] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //zip reduce
    [[RACSignal zip:@[signalA, signalB, signalC] reduce:^id(NSString *a, NSString *b, NSString *c){
        return [NSString stringWithFormat:@"%@, %@, %@", a, b, c];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //zip sample reduce
    //[signalB sample:signalA]的意思是,只有当signalA信号发出后,才需要获取signalB的最新值,然后取出signalA还没有使用的最旧的信号,合并发出
    [[RACSignal zip:@[signalA, [signalB sample:signalA]] reduce:^id(NSString *a, NSString *b){
        return [NSString stringWithFormat:@"%@, %@", a, b];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
