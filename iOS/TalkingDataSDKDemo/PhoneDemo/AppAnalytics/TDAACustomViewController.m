//
//  TDAACustomViewController.m
//  TalkingDataSDKDemo
//
//  Created by liweiqiang on 2017/5/22.
//  Copyright © 2017年 TendCloud. All rights reserved.
//

#import "TDAACustomViewController.h"

@interface TDAACustomViewController ()

@property (weak, nonatomic) IBOutlet UITextField *eventIDField;
@property (weak, nonatomic) IBOutlet UITextField *eventLableField;
@property (weak, nonatomic) IBOutlet UITextField *key1Field;
@property (weak, nonatomic) IBOutlet UITextField *value1Field;
@property (weak, nonatomic) IBOutlet UITextField *key2Field;
@property (weak, nonatomic) IBOutlet UITextField *value2Field;

@end

@implementation TDAACustomViewController

- (IBAction)submit:(UIButton *)sender {
    if (self.eventIDField.text.length == 0) {
        return;
    }
    
    NSMutableDictionary *eventData = [NSMutableDictionary dictionary];
    if (self.key1Field.text.length > 0 && self.value1Field.text.length > 0) {
        [eventData setObject:self.value1Field.text forKey:self.key1Field.text];
    }
    if (self.key2Field.text.length > 0 && self.value2Field.text.length > 0) {
        [eventData setObject:self.value2Field.text forKey:self.key2Field.text];
    }
    

}

@end
