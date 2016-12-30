//
//  BindViewController.m
//  RACExample
//
//  Created by lidp on 2016/12/30.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "BindViewController.h"
#import <ReactiveCocoa/RACReturnSignal.h>

@interface BindViewController ()

@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [[self.operateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self bind];
    }];
}

- (void)bind{
    RACSubject *subject = [RACSubject subject];
    [[subject bind:^RACStreamBindBlock{
        /*
            RACStreamBindBlock:
            参数一(value):表示接收到信号的原始值，还没做处理
            参数二(*stop):用来控制绑定Block，如果*stop = yes,那么就会结束绑定。
            返回值：信号，做好处理，在通过这个信号返回出去，一般使用RACReturnSignal,需要手动导入头文件RACReturnSignal.h。
         */
        return ^RACSignal *(id value, BOOL *stop){
            NSLog(@"原信号数据：%@", value);
            value = [value stringByAppendingString:@" RAC"];
            return [RACReturnSignal return:value];
        };
    }] subscribeNext:^(id x) {
        NSLog(@"绑定信号接收到的实际数据:%@",x);
    }];
    
    [subject sendNext:@"test"];
    
    /*
    //例子：假设想监听文本框的内容，并且在每次输出结果的时候，都在文本框的内容拼接一段文字“输出：”
    //方式1
    [_textfield.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"输出:%@",x);
    }];
    
     //方式2
    [[_textfield.rac_textSignal bind:^RACStreamBindBlock{
        return ^RACStream *(id value, BOOL *stop){
            return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
        };
        
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
