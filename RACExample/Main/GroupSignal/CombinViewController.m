//
//  CombinViewController.m
//  RACExample
//
//  Created by lidp on 2016/12/26.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "CombinViewController.h"

@interface CombinViewController ()

@end

@implementation CombinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [[self.operateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self combin];
    }];
}

- (void)combin{
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
        [subscriber sendNext:@"C -- 2"];
        [subscriber sendNext:@"C -- 3"];
        return nil;
    }];
    
    [[RACSignal combineLatest:@[signalA, signalB, signalC]] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [[RACSignal combineLatest:@[signalA, signalB, signalC] reduce:^id(NSString *a, NSString *b, NSString *c){
        return [NSString stringWithFormat:@"%@, %@, %@", a, b, c];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
