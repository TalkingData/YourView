//
//  TDGeneralViewController.m
//  TalkingDataSDKDemo
//
//  Created by liweiqiang on 2017/5/22.
//  Copyright © 2017年 TendCloud. All rights reserved.
//

#import "TDGeneralViewController.h"

@interface TDGeneralViewController ()

@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UITextView *detail;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIButton *customize;

@end

@implementation TDGeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.subject.text = [NSString stringWithFormat:@"　%@", _info[@"title"]];
    self.icon.image = [UIImage imageNamed:_info[@"name"]];
    self.detail.text = _info[@"detail"];
    BOOL selected = [_info[@"selected"] boolValue];
    if (selected) {
        self.status.text = @"当前SDK已选择此功能";
        self.status.textColor = [UIColor greenColor];
    } else {
        self.status.text = @"当前SDK未选择此功能";
        self.status.textColor = [UIColor redColor];
    }
    self.customize.hidden = selected;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    CGFloat sysVersion = [UIDevice currentDevice].systemVersion.floatValue;
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = nil;
    if (sysVersion >= 8.0f) {
        return YES;
    } else if ([identifier isEqualToString:@"segueAppBaseInterface"]) {
        viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"App-BaseInterface"];
    } else if ([identifier isEqualToString:@"segueAppPageFirst"]) {
        viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"App-PageFirst"];
    } else if ([identifier isEqualToString:@"segueAppPageSecond"]) {
        viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"App-PageSecond"];
    } else if ([identifier isEqualToString:@"segueGameBaseInterface"]) {
        viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Game-BaseInterface"];
    } else if ([identifier isEqualToString:@"segueTrackingBaseInterface"]) {
        viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Tracking-BaseInterface"];
    } else if ([identifier isEqualToString:@"segueEAuthAuth"]) {
        viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"eAuth-Auth"];
    } else if ([identifier isEqualToString:@"segueEAuthCheck"]) {
        viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"eAuth-Check"];
    } else if ([identifier isEqualToString:@"segueEAuthMatch"]) {
        viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"eAuth-Match"];
    } else if ([identifier isEqualToString:@"segueEAuthUnbind"]) {
        viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"eAuth-Unbind"];
    } else if ([identifier isEqualToString:@"segueBrandGrowDisplay"]) {
        viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"BrandGrowth-Display"];
    } else if ([identifier isEqualToString:@"segueBrandGrowClick"]) {
        viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"BrandGrowth-Click"];
    } else if ([identifier isEqualToString:@"segueBrandGrowShow"]) {
        viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"BrandGrowth-Show"];
    }
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    return NO;
}

- (IBAction)reapply:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://doc.talkingdata.com"]];
}

@end
