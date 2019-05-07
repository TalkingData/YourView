//
//  YVHomeViewController.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVHomeViewController.h"
#import "YVLoadingViewController.h"

@interface YVHomeViewController ()

@end

@implementation YVHomeViewController
-(IBAction)buttonPressed:(NSButton*)btn
{
    NSTextField * tf = [self.view viewWithTag:666];
    NSString * ip = tf.stringValue;
    if (ip) {
        [[NSUserDefaults standardUserDefaults]setObject:ip forKey:@"ip"];
    }
    NSStoryboard * sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    YVLoadingViewController * loadingVC =[sb instantiateControllerWithIdentifier:@"loading"];
    loadingVC.host = ip;
    [NSApp.keyWindow.contentViewController presentViewControllerAsSheet:loadingVC];;
}
-(void)fillIP
{
    NSString * ip = [[NSUserDefaults standardUserDefaults]objectForKey:@"ip"];
    if (ip) {
        NSTextField * tf = [self.view viewWithTag:666];
        tf.stringValue = ip;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self fillIP];
}

@end
