//
//  TDEAAuthViewController.m
//  TalkingDataSDKDemo
//
//  Created by liweiqiang on 2018/1/9.
//  Copyright © 2018年 TendCloud. All rights reserved.
//

#import "TDEAAuthViewController.h"

@interface TDEAAuthViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountNameField;
@property (weak, nonatomic) IBOutlet UITextField *countryCodeField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTypeField;
@property (weak, nonatomic) IBOutlet UITextField *smsIDField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeField;
@property (weak, nonatomic) IBOutlet UIButton *applyAuthCodeButton;
@property (strong, nonatomic) NSMutableArray *typePickerData;
@property (strong, nonatomic) UIPickerView *typePickerView;
@property (strong, nonatomic) NSString *requestId;

@end

@implementation TDEAAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.typePickerData = [NSMutableArray array];
    [self.typePickerData addObject:@"短信认证"];
    [self.typePickerData addObject:@"语音认证"];
    
    self.typePickerView = [[UIPickerView alloc] init];
    self.typePickerView.dataSource = self;
    self.typePickerView.delegate = self;
    self.typePickerView.showsSelectionIndicator = YES;
    
    self.authCodeTypeField.inputView = self.typePickerView;
    self.authCodeTypeField.text = self.typePickerData[0];
}
#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.typePickerData.count;
}

#pragma mark Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.typePickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.authCodeTypeField.text = [self.typePickerData objectAtIndex:row];
}

#pragma mark - Control event

- (IBAction)useTDID {
}

- (IBAction)apply {

}

- (IBAction)verify {

}

#pragma mark - TalkingData eAuth Delegate




@end
