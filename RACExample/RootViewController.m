//
//  RootViewController.m
//  Test
//
//  Created by lidp on 2016/12/22.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewCell{
    UILabel *_titleLabel;
    UILabel *_descLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = DPLabel().setTextColor([UIColor  blackColor]).
                                setFont([UIFont systemFontOfSize:16]).
                                setLine(0).
                                setBackgroundColor([UIColor whiteColor]);
        self.contentView.addSubview(_titleLabel);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@10);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        
        _descLabel = DPLabel().setTextColor([UIColor  blackColor].setAlpha(0.4)).
                               setFont([UIFont systemFontOfSize:14]).
                               setLine(0).
                               setBackgroundColor([UIColor whiteColor]);
        self.contentView.addSubview(_descLabel);
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)setData:(NSDictionary *)data{
    _data = [data copy];

    _titleLabel.setText(_data[@"t"]).setLineSpacing(3);
    _descLabel.setText(_data[@"d"]).setLineSpacing(4);
}

@end

@interface RootViewController ()

@end

static NSString *const cell_id = @"RootViewCell";
@implementation RootViewController{
    NSArray     *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.setTitle(@"RACDemo");
    _dataSource = @[@{@"t":@"登录示例", @"c":@"LoginViewController", @"d":@"带有信号合并示例(combineLatest)、RACCommand示例、属性绑定"},
                    @{@"t":@"RACSignal替换Delegate", @"c":@"ReplaceDelegateViewController"},
                    @{@"t":@"监听事件&通知&KVO", @"c":@"ENOViewController"},
                    @{@"t":@"zip", @"c":@"ZipViewController", @"d":@"多个信号压缩成一个RACTuple,每个信号必须sendNext才会触发zip subscribeNext，对应关系为多个信号中sendNext最少的一个信号。([RACSignal zip: reduce:]可以自定义信号的合并结果)"},
                    @{@"t":@"combineLatest", @"c":@"CombinViewController", @"d":@"多个信号合并成一个RACTuple，每个信号必须sendNext才会触发combineLatest subscribeNext，最后一个信号每次sendNext都会触发combineLatest subscribeNext，其他信号取最后一次sendNext的值，也就是最新的值。([RACSignal combineLatest: reduce:]可以自定义信号的合并结果)"},
                    @{@"t":@"concat", @"c":@"ConcatViewController", @"d":@"连接信号，当前信号执行完之后才能执行下一个信号（可以用来当串行队列）"},
                    @{@"t":@"then", @"c":@"ThenViewController", @"d":@"类似concat"},
                    @{@"t":@"lift", @"c":@"LiftViewController", @"d":@"场景：需要获取多个请求的数据统一更新UI"},
                    @{@"t":@"timer", @"c":@"TimerViewController", @"d":@"定时、超时、延迟，ScrollView滚动时不会影响计时"},
                    @{@"t":@"retry", @"c":@"RetryViewController", @"d":@"当信号发出error时，可以重新执行信号"},
                    @{@"t":@"bind", @"c":@"BindViewController", @"d":@"给RAC中的信号进行绑定，只要信号一发送数据就能监听到，从而把发送数据改成自己想要的数据"},
                    @{@"t":@"map、flattenMap", @"c":@"MapViewController", @"d":@"用于把源信号内容映射成新的内容\n\nmap作用:把源信号的值映射成一个新的值\n\nflattenMap作用:用于信号中信号,把源信号的内容映射成一个新的信号,信号可以是任意类型"},];
    
    self.tableView.showsVerticalScrollIndicator = YES;
    [self.tableView registerClass:RootViewCell.class forCellReuseIdentifier:cell_id];
    self.tableView.setTableFooterView(DPView());
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ---------------------- UITableViewDelegate/UITableDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RootViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    cell.data = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [[NSClassFromString(_dataSource[indexPath.row][@"c"]) alloc] init];
    vc.navigationItem.setTitle(_dataSource[indexPath.row][@"t"]);
    self.pushViewController(vc, YES);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dp_heightForCellWithIdentifier:cell_id configuration:^(id tempCell) {
        RootViewCell *cell = tempCell;
        cell.dp_useAutoLayout = YES;
        cell.data = _dataSource[indexPath.row];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

@end
