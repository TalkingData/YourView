//
//  YVRightViewController.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/25.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVRightViewController.h"
#import "YVRightCellViewInfo.h"
#import "YVRightCellViewFrame.h"

@interface YVRightViewController ()<YVRightCellProtocol>
@property (nonatomic,copy) NSDictionary * selectedNode;
@property (nonatomic) NSString * host;

@end

@implementation YVRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateViewInfo:) name:YVSelectionChangeLeftToRight object:nil];
    NSString * ip = [[NSUserDefaults standardUserDefaults]objectForKey:@"ip"];
    self.host = ip;
}

-(void)updateViewInfo:(NSNotification*)noti
{
    NSDictionary * dict = noti.object;
    NSLog(@"right %@",dict[@"class"]);
    self.selectedNode = dict;
    [self.viewtable reloadData];
}

-(void)cmd_setframe:(NSString*)framestring
{
    NSString * address = self.selectedNode[@"address"];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8080?cmd=setframe&address=%@",self.host,address]];
    NSDictionary * bodyDict = @{
                                @"framestring":framestring
                                };
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:nil];
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }]resume];
}

-(void)cmd_shake
{
    NSString * address = self.selectedNode[@"address"];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8080?cmd=shake&address=%@",self.host,address]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 5.0f;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    }]resume];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 2;
}
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    YVRightCellBase * retView;
    if (row == 0) {
        retView = [YVRightCellViewInfo makeView:tableView owner:self identifer:@"YVRightCellViewInfo"];
    }else if (row == 1) {
        retView = [YVRightCellViewFrame makeView:tableView owner:self identifer:@"YVRightCellViewFrame"];
    }else {

    }
    retView.delegate = self;
    [retView fillData:self.selectedNode];
    return retView;
}

-(void)cellDidClick:(NSView*)cell withData:(id)data cmd:(NSString*)cmd
{
    NSLog(@"call back %@ %@",cmd,data);
    if ([cmd isEqualToString:@"setframe"]) {
        [self cmd_setframe:data];
    }else if ([cmd isEqualToString:@"shake"]){
        [self cmd_shake];
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if (row == 0) {
        return 280;
    }else if (row == 1) {
        return 115;
    }
    return 280;
}
@end
