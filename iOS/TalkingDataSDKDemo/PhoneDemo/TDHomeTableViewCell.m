//
//  TDHomeTableViewCell.m
//  TalkingDataSDKDemo
//
//  Created by liweiqiang on 2017/5/22.
//  Copyright © 2017年 TendCloud. All rights reserved.
//

#import "TDHomeTableViewCell.h"

@implementation TDHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *top =       [NSLayoutConstraint constraintWithItem:self.selectImage
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.textLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:0];
    NSLayoutConstraint *right =     [NSLayoutConstraint constraintWithItem:self.selectImage
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:-8];
    NSLayoutConstraint *width =     [NSLayoutConstraint constraintWithItem:self.selectImage
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.textLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1
                                                                  constant:0];
    NSLayoutConstraint *height =    [NSLayoutConstraint constraintWithItem:self.selectImage
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.textLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1
                                                                  constant:0];
    [self.contentView addConstraints:@[top, right, width, height]];
}

@end
