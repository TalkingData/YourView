//
//  TDAAVersionTableViewCell.m
//  TalkingDataSDKDemo
//
//  Created by liweiqiang on 2018/8/29.
//  Copyright © 2018年 TendCloud. All rights reserved.
//

#import "TDAAVersionTableViewCell.h"

@interface TDAAVersionTableViewCell ()

@property (weak, nonatomic) IBOutlet UITextField *versionCodeField;
@property (weak, nonatomic) IBOutlet UITextField *versionNameField;

@end

@implementation TDAAVersionTableViewCell

- (IBAction)setVersion {
    NSString *versionCode = self.versionCodeField.text;
    NSString *versionName = self.versionNameField.text;
}

@end
