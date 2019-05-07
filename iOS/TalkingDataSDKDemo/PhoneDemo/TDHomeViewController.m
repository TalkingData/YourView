//
//  TDHomeViewController.m
//  TalkingDataSDKDemo
//
//  Created by liweiqiang on 2017/5/22.
//  Copyright © 2017年 TendCloud. All rights reserved.
//

#import "TDHomeViewController.h"
#import "TDHomeTableViewCell.h"
#import "TDGeneralViewController.h"

static NSString *cellIdentifier = @"Cell";
static NSString *headerIdentifier = @"Header";

@interface TDHomeViewController ()

@property (strong, nonatomic) NSArray *items;

@end

@implementation TDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Data.plist"];
    self.items = [NSArray arrayWithContentsOfFile:path];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = self.items[section];
    NSArray *funs = dic[@"functions"];
    
    return funs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.items[indexPath.section];
    NSArray *functions = dic[@"functions"];
    NSDictionary *item = functions[indexPath.row];
    
    TDHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.imageView.image = [UIImage imageNamed:item[@"name"]];
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"subtitle"];
    cell.detailTextLabel.numberOfLines = 2;
    cell.selectImage.highlighted = [item[@"selected"] boolValue];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
    }
    NSDictionary *dic = self.items[section];
    view.textLabel.text = dic[@"name"];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *product = self.items[indexPath.section];
    NSString *productName = product[@"name"];
    NSArray *functions = product[@"functions"];
    NSDictionary *function = functions[indexPath.row];
    NSString *functionTitle = function[@"title"];
    NSString *functionName = function[@"name"];
    NSString *identifier = [NSString stringWithFormat:@"%@-%@", productName, functionName];
    
    TDGeneralViewController *viewController = nil;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    @try {
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
    } @catch (NSException *exception) {
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"TalkingData-General"];
    }
    viewController.info = function;
    viewController.navigationItem.title = [NSString stringWithFormat:@"%@ %@", productName, functionTitle];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
