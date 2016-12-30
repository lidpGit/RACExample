//
//  MapViewController.m
//  RACExample
//
//  Created by lidp on 2016/12/30.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "MapViewController.h"
#import <ReactiveCocoa/RACReturnSignal.h>

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [[self.operateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self map];
    }];
}

- (void)map{
    //map
    RACSubject *mapSubject = [RACSubject subject];
    
    [[mapSubject map:^id(id value) {
        return [NSString stringWithFormat:@"AB%@", value];
    }] subscribeNext:^(id x) {
        NSLog(@"map result = %@", x);
    }];
    
    [mapSubject sendNext:@"CD"];
    
    //flattenMap
    RACSubject *flattenMapSubject = [RACSubject subject];
    RACSubject *tempSubject = [RACSubject subject];
    
    [[flattenMapSubject flattenMap:^RACStream *(id value) {
        NSLog(@"value is %@", value);
        return value;
    }] subscribeNext:^(id x) {
        NSLog(@"flattenMap result = %@", x);
    }];
    
    [flattenMapSubject sendNext:tempSubject];
    [tempSubject sendNext:@"test"];
    /*
        flatternMap和map的区别：
            flatternMap中的Block返回RACSignal，map中的block返回任意对象。
            开发中，如果信号发出的值不是信号，映射一般使用map，如果信号发出的值是信号，映射一般使用flatternMap。
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
