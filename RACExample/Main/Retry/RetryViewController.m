//
//  RetryViewController.m
//  RACExample
//
//  Created by lidp on 2016/12/30.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "RetryViewController.h"

@interface RetryViewController ()

@end

@implementation RetryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [[self.operateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self retry];
    }];
}

- (void)retry{
    __block int index = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (index == 5) {
            [subscriber sendNext:@"retry 5"];
            [subscriber sendCompleted];
        }else{
            NSLog(@"%d", index);
            index++;
            [subscriber sendError:nil];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
