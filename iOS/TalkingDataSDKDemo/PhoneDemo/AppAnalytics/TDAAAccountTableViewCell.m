//
//  TDAAAccountTableViewCell.m
//  TalkingDataSDKDemo
//
//  Created by liweiqiang on 2017/6/26.
//  Copyright © 2017年 TendCloud. All rights reserved.
//

#import "TDAAAccountTableViewCell.h"

@interface TDAAAccountTableViewCell () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountIDField;
@property (weak, nonatomic) IBOutlet UITextField *accountTypeField;
@property (weak, nonatomic) IBOutlet UITextField *accountNameField;
@property (strong, nonatomic) NSMutableArray *typePickerData;
@property (strong, nonatomic) UIPickerView *typePickerView;

@end


@implementation TDAAAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.typePickerData = [NSMutableArray array];
    [self.typePickerData addObject:@"匿名账户"];
    [self.typePickerData addObject:@"显性注册账户"];
    [self.typePickerData addObject:@"新浪微博"];
    [self.typePickerData addObject:@"QQ账户"];
    [self.typePickerData addObject:@"腾讯微博"];
    [self.typePickerData addObject:@"91账户"];
    [self.typePickerData addObject:@"微信"];
    [self.typePickerData addObject:@"预留1"];
    [self.typePickerData addObject:@"预留2"];
    [self.typePickerData addObject:@"预留3"];
    [self.typePickerData addObject:@"预留4"];
    [self.typePickerData addObject:@"预留5"];
    [self.typePickerData addObject:@"预留6"];
    [self.typePickerData addObject:@"预留7"];
    [self.typePickerData addObject:@"预留8"];
    [self.typePickerData addObject:@"预留9"];
    [self.typePickerData addObject:@"预留10"];
    
    self.typePickerView = [[UIPickerView alloc] init];
    self.typePickerView.dataSource = self;
    self.typePickerView.delegate = self;
    self.typePickerView.tag = 1;
    self.typePickerView.showsSelectionIndicator = YES;
    self.accountTypeField.inputView = self.typePickerView;
}

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case 1:
            return self.typePickerData.count;
            break;
        default:
            break;
    }
    
    return 0;
}

#pragma mark Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case 1:
            return [self.typePickerData objectAtIndex:row];
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case 1:
            self.accountTypeField.text = [self.typePickerData objectAtIndex:row];
            break;
        default:
            break;
    }
}

#pragma mark - Control event

- (IBAction)registerAccount {

}

- (IBAction)loginAccount {

}


@end
