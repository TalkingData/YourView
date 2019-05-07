//
//  TDAAAntiCheatingViewController.m
//  TalkingDataSDKDemo
//
//  Created by liweiqiang on 2017/5/22.
//  Copyright © 2017年 TendCloud. All rights reserved.
//

#import "TDAAAntiCheatingViewController.h"

@interface TDAAAntiCheatingViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *antiCheatingSwitch;

@end

@implementation TDAAAntiCheatingViewController

static BOOL antiCheatingSwitchOn = YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.antiCheatingSwitch.on = antiCheatingSwitchOn;
}

- (IBAction)enabledAntiCheating:(UISwitch *)sender {
    antiCheatingSwitchOn = sender.on;
}

@end
