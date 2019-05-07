//
//  YVLoadingViewController.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/25.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVLoadingViewController.h"
#import "YVWindowController.h"


@interface YVLoadingViewController ()

@property (strong) IBOutlet NSTextField * nameLabel;
@property (strong) IBOutlet NSTextField * systemLabel;
@property (strong) IBOutlet NSTextField * deviceNameLabel;
@property (strong) IBOutlet NSImageView * iconView;
@property (strong) IBOutlet NSProgressIndicator * progress;

@property (nonatomic,strong) NSDictionary * appinfo;
@property (nonatomic,strong) NSDictionary * viewtree;

@end

@implementation YVLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self request];
}
-(void)configIconApperaence
{
    self.iconView.layer.backgroundColor = [NSColor clearColor].CGColor;
    self.iconView.layer.borderColor = YVTHEME_NODE_HOVERBORDERCOLOR.CGColor;
    self.iconView.layer.borderWidth = 2.0f;
    self.iconView.layer.cornerRadius = 8.0f;
    [self.iconView setNeedsDisplay:YES];
}

-(void)info:(NSString*)info
{
    self.infolabel.stringValue = info;
}

-(void)request
{
    [self startLoading];
    [self info:@"request app info"];
    @weakify(self);
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8080?cmd=appinfo",self.host]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 5.0f;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        if (error == nil) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.appinfo = dict;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onAppInfoSuccess:dict];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onRequestError:error];
            });
        }
    }]resume];
}

-(void)onAppInfoSuccess:(NSDictionary*)appInfo
{
    [self info:@"request success"];
    NSLog(@"success");
    NSString * appname = appInfo[@"CFBundleName"];
    NSString * bundleid = appInfo[@"CFBundleIdentifier"];
    NSString * systemname = appInfo[@"systemname"];
    NSString * systemversion = appInfo[@"systemversion"];
    NSString * deviceName = appInfo[@"devicename"];
    NSString * appicon = appInfo[@"iconimage"];
    
    self.nameLabel.stringValue = [NSString stringWithFormat:@"%@ (%@)",appname,bundleid];
    self.systemLabel.stringValue = [NSString stringWithFormat:@"%@ %@",systemname,systemversion];
    self.deviceNameLabel.stringValue = [NSString stringWithFormat:@"%@",deviceName];
    self.appinfo = appInfo;
    [self configIconApperaence];
    if (appicon.length > 0) {
        NSData * imageData = [[NSData alloc]initWithBase64EncodedString:appicon options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSImage * icon = [[NSImage alloc]initWithData:imageData];
        self.iconView.image = icon;
    }
    [self requestViewTree];
}

-(void)requestViewTree
{
    [self info:@"waiting for view tree"];
    @weakify(self);
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8080?cmd=viewtree",self.host]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        if (error == nil) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"request view tree success");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewController:self];
                YVWindowController * windowController = (YVWindowController*)NSApp.windows.firstObject.windowController;
                windowController.host = self.host;
                [windowController updateAppInfo:weak_self.appinfo];
                [windowController updateViewTree:dict];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onRequestError:error];
            });
        }
    }]resume];
}


-(void)onRequestError:(NSError*)error
{
    NSLog(@"failed");
    [self stopLoading];
    [[NSAlert alertWithError:error]runModal];
    [self dismissController:self];
}

-(void)startLoading
{
    [self.progress startAnimation:nil];
}

-(void)stopLoading
{
    [self.progress stopAnimation:nil];

}

@end
