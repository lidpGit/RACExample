//
//  TimerViewController.m
//  RACExample
//
//  Created by lidp on 2016/12/26.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController ()

@end

@implementation TimerViewController{
    RACSubject *_stopTimerSignal;
}

- (void)dealloc{
    [_stopTimerSignal sendNext:@"stop"];
}

- (void)viewDidLoad {
    UIScrollView *scrollview = DPScrollView().setFrame(self.view.bounds).setContentSize(CGSizeMake(0, 1000));
    self.view.addSubview(scrollview);
    [super viewDidLoad];
    @weakify(self);
    [[self.operateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self startTimer];
    }];
}

- (void)startTimer{
    //延迟调用
    [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
        NSLog(@"RACScheduler延迟3秒");
    }];
    
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"test"];
        [subscriber sendCompleted];
        return nil;
    }] delay:3] subscribeNext:^(id x) {
        NSLog(@"RACSignal延迟3秒 -- %@", x);
    }];
    
    //定时器，不限制次数，interval：间隔，每隔多少秒执行一次
//    [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
//        NSLog(@"1秒执行一次");
//    }];
    
    //定时器，不限制次数，根据条件停止定时器(此例子为当前控制器被释放时才停止)，interval：间隔，每隔多少秒执行一次
    _stopTimerSignal = [RACSubject subject];
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            [subscriber sendNext:@"1秒执行一次"];
        }];
        return nil;
    }] takeUntil:_stopTimerSignal] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //定时器，限制次数，interval：间隔，每隔多少秒执行一次， take：执行次数
    [[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] take:2] subscribeNext:^(id x) {
        NSLog(@"2秒执行一次，重复两次");
    }];
    
    //超时，超时时间为4秒，6秒之后才发信号
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> s) {
            [s sendNext:@"00"];
            [s sendCompleted];
            return nil;
        }] delay:6] subscribeNext:^(id x) {
            [subscriber sendNext:@"xx"];
            [subscriber sendCompleted];
        }];
        return nil;
    }] timeout:4 onScheduler:[RACScheduler mainThreadScheduler]] subscribeError:^(NSError *error) {
        NSLog(@"已超时");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
