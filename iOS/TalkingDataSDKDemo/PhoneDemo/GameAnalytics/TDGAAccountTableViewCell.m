//
//  TDGAAccountTableViewCell.m
//  TalkingDataSDKDemo
//
//  Created by liweiqiang on 2017/5/22.
//  Copyright © 2017年 TendCloud. All rights reserved.
//

#import "TDGAAccountTableViewCell.h"

@interface TDGAAccountTableViewCell () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountIDField;
@property (weak, nonatomic) IBOutlet UITextField *accountNameField;
@property (weak, nonatomic) IBOutlet UITextField *accountTypeField;
@property (weak, nonatomic) IBOutlet UITextField *levelField;
@property (weak, nonatomic) IBOutlet UITextField *genderField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UITextField *gameServerField;
@property (strong, nonatomic) NSMutableArray *typePickerData;
@property (strong, nonatomic) UIPickerView *typePickerView;
@property (strong, nonatomic) NSMutableArray *genderPickerData;
@property (strong, nonatomic) UIPickerView *genderPickerView;

@end

@implementation TDGAAccountTableViewCell

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
    
    self.genderPickerData = [NSMutableArray array];
    [self.genderPickerData addObject:@"未知"];
    [self.genderPickerData addObject:@"男"];
    [self.genderPickerData addObject:@"女"];
    
    self.genderPickerView = [[UIPickerView alloc] init];
    self.genderPickerView.dataSource = self;
    self.genderPickerView.delegate = self;
    self.genderPickerView.tag = 2;
    self.genderPickerView.showsSelectionIndicator = YES;
    self.genderField.inputView = self.genderPickerView;
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
        case 2:
            return self.genderPickerData.count;
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
        case 2:
            return [self.genderPickerData objectAtIndex:row];
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
        case 2:
            self.genderField.text = [self.genderPickerData objectAtIndex:row];
            break;
        default:
            break;
    }
}

#pragma mark - Control event

- (IBAction)setAccountID {
}

- (IBAction)setAccountName {
}

- (IBAction)setAccountType {

}

- (IBAction)setLevel {
}

- (IBAction)setGender {
}

- (IBAction)setAge {
}

- (IBAction)setGameServer {
}

@end
