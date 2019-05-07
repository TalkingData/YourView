//
//  TDTableViewController.m
//  TalkingDataSDKDemo
//
//  Created by liweiqiang on 2017/8/1.
//  Copyright © 2017年 TendCloud. All rights reserved.
//

#import "TDTableViewController.h"

@interface TDTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *items;
@property (nonatomic) NSInteger showIndex;

@end

@implementation TDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.navigationItem.title hasPrefix:@"App Analytics"]) {
        self.items = @[
            @{@"id":@"DeviceID",@"height":@84,@"title":@"获取TDID"},
            @{@"id":@"Exception",@"height":@46,@"title":@"测试应用崩溃（点击后该Demo将闪退）"},
            @{@"id":@"Location",@"height":@46,@"title":@"设置经纬度"},
            @{@"id":@"Version",@"height":@46,@"title":@"自定义版本"},
            @{@"id":@"Account",@"height":@236,@"title":@"账户接口"},
        ];
    }
    if ([self.navigationItem.title hasPrefix:@"Game Analytics"]) {
        self.items = @[
            @{@"id":@"DeviceID",@"height":@84,@"title":@"获取TDID"},
            @{@"id":@"Account",@"height":@274,@"title":@"账户接口"},
            @{@"id":@"Mission",@"height":@84,@"title":@"任务接口"},
            @{@"id":@"VirtualCurrency",@"height":@388,@"title":@"充值接口"},
            @{@"id":@"Item",@"height":@160,@"title":@"虚拟币消耗"},
            @{@"id":@"Other",@"height":@46,@"title":@"设置经纬度"},
        ];
    }
    if ([self.navigationItem.title hasPrefix:@"Ad Tracking"]) {
        self.items = @[
            @{@"id":@"DeviceID",@"height":@84,@"title":@"获取TDID"},
            @{@"id":@"Other",@"height":@278,@"title":@"标准事件"},
            @{@"id":@"ECommerce",@"height":@160,@"title":@"电商定制事件"},
            @{@"id":@"Game",@"height":@46,@"title":@"游戏定制事件"},
        ];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_showIndex == section) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"%@Cell", [[self.items objectAtIndex:indexPath.section] objectForKey:@"id"]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[[self.items objectAtIndex:indexPath.section] objectForKey:@"height"] floatValue];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *identifier = [NSString stringWithFormat:@"Header-%ld", section];
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (view) {
        return view;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 1366, 30)];
    button.tag = section;
    [button addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithWhite:242.0/255.0 alpha:1.0]];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString *title = [[self.items objectAtIndex:section] objectForKey:@"title"];
    [button setTitle:title forState:UIControlStateNormal];
    
    view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    [view.contentView addSubview:button];
    
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0f) {
        return nil;
    }
    
    NSString *identifier = [NSString stringWithFormat:@"Footer-%ld", section];
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (view) {
        return view;
    }
    
    view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    view.contentView.backgroundColor = [UIColor whiteColor];
    
    return view;
}

#pragma mark - Button event

- (void)changeSection:(UIButton *)sender {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    if (_showIndex == -1) {
        _showIndex = sender.tag;
    } else if (_showIndex == sender.tag) {
        _showIndex = -1;
    } else {
        [indexSet addIndex:_showIndex];
        _showIndex = sender.tag;
    }
    [indexSet addIndex:sender.tag];
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0f) {
        [self.tableView reloadData];
    } else {
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
