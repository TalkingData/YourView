//
//  YVWindowController.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVWindowController.h"
#import "YVMiddleViewController.h"
#import "YVSplitViewController.h"
#import "YVScriptEditorViewController.h"

@interface YVWindowController () <NSSplitViewDelegate>
@property (nonatomic) IBOutlet NSView * containerView;
@property (nonatomic) IBOutlet NSImageView * iconImage;
@property (nonatomic) IBOutlet NSTextField * infoLabel;
@property (nonatomic,assign) BOOL isLeftSelected;
@property (nonatomic,assign) BOOL isRightSelected;
@property (nonatomic,assign) BOOL isloading;
@property (nonatomic,assign) YVWindowDisplayStatus currentDisplayStatus;
@property (nonatomic,strong) NSWindowController * jspathWindowController;
@end

@implementation YVWindowController

#pragma mark LifeCycle
-(void)awakeFromNib
{
    [self windowConfig];
}

-(void)windowConfig
{
    if (self.currentDisplayStatus == YVWindowDisplayStatusHome) {
        CGRect staticRect = CGRectMake(0, 0, 429,248);
        self.window.maxSize = NSSizeFromCGSize(staticRect.size);
        self.window.minSize = NSSizeFromCGSize(staticRect.size);
        self.window.contentMaxSize = NSSizeFromCGSize(staticRect.size);
        self.window.contentMinSize = NSSizeFromCGSize(staticRect.size);
        [self.window setFrame:staticRect display:YES animate:NO];
    }else if (self.currentDisplayStatus == YVWindowDisplayStatusInspect){
        CGRect minsize = CGRectMake(0, 0, 960,500);
        self.window.contentMaxSize = CGSizeMake(INT_MAX, INT_MAX);
        self.window.contentMinSize = minsize.size;
        self.window.maxSize = CGSizeMake(INT_MAX, INT_MAX);
        self.window.minSize = minsize.size;
        NSRect scrennframe =[NSScreen mainScreen].frame;
        CGFloat dx = scrennframe.size.width * 0.1;
        CGFloat dy = scrennframe.size.height * 0.1;
        NSRect newrect = NSInsetRect(scrennframe,dx,dy);
        [self.window setFrame:newrect display:YES animate:YES];
    }
    [self.window center];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.isLeftSelected = YES;
    self.isRightSelected = NO;
    self.currentDisplayStatus = YVWindowDisplayStatusHome;
    [self showToolbar:NO];
    [self windowConfig];
}

-(void)configureApperance
{
    [self showToolbar:YES];
    self.containerView.layer.backgroundColor = YVTHEME_TITLEBAR_BACKGROUNDCOLOR;
    self.containerView.layer.borderColor = YVTHEME_TITLEBAR_BORDERCOLOR;
    self.containerView.layer.borderWidth = 0.5f;
    self.containerView.layer.cornerRadius = 5.0f;
    [self.containerView setNeedsDisplay:YES];
    
    self.iconImage.layer.backgroundColor = [NSColor orangeColor].CGColor;
    self.iconImage.layer.borderColor = YVTHEME_TITLEBAR_BORDERCOLOR;
    self.iconImage.layer.borderWidth = 0.5f;
    self.iconImage.layer.cornerRadius = 3.0f;
    [self.iconImage setNeedsDisplay:YES];
}


-(void)showToolbar:(BOOL)visable
{
    self.window.toolbar.visible = visable;
}


-(void)configureSplit
{
    if (self.currentDisplayStatus == YVWindowDisplayStatusInspect) {
        [self windowConfig];
        CGFloat windowWidth = NSApp.windows.firstObject.frame.size.width;
        NSSplitViewController * controller = (NSSplitViewController*)self.window.contentViewController;
        [controller.splitView setPosition:300 ofDividerAtIndex:0];
        [controller.splitView setPosition:windowWidth ofDividerAtIndex:1];
    }
}

-(void)updateAppInfo:(NSDictionary*)appInfo
{
    NSString * appname = appInfo[@"CFBundleName"];
    NSString * bundleid = appInfo[@"CFBundleIdentifier"];
    NSString * systemname = appInfo[@"systemname"];
    NSString * systemversion = appInfo[@"systemversion"];
    NSString * deviceName = appInfo[@"devicename"];
    NSString * appicon = appInfo[@"iconimage"];
    self.infoLabel.stringValue = [NSString stringWithFormat:@"%@(%@) running on %@(%@ %@)",appname,bundleid,deviceName,systemname,systemversion];
    if (appicon.length > 0) {
        NSData * imageData = [[NSData alloc]initWithBase64EncodedString:appicon options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSImage * icon = [[NSImage alloc]initWithData:imageData];
        self.iconImage.image = icon;
    }
}

-(void)updateViewTree:(NSDictionary*)viewTree
{
    self.currentDisplayStatus = YVWindowDisplayStatusInspect;
    NSStoryboard * sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSSplitViewController * split = [sb instantiateControllerWithIdentifier:@"split"];
    self.window.contentViewController = split;
    [self configureSplit];
    [self configureApperance];
    [self notifyDataSuccess:viewTree];
}

-(void)notifyDataSuccess:(NSDictionary*)vt
{
    [[NSNotificationCenter defaultCenter]postNotificationName:YVViewTreeDidLoadNotificationName object:vt];
}

-(void)releaseResource
{
    self.jspathWindowController = nil;
}

#pragma mark NSWindowDelegate
-(BOOL)windowShouldClose:(id)sender {
    if (self.currentDisplayStatus == YVWindowDisplayStatusInspect) {
        self.currentDisplayStatus = YVWindowDisplayStatusHome;
        NSStoryboard * sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
        NSViewController * home = [sb instantiateControllerWithIdentifier:@"home"];
        self.window.contentViewController = home;
        self.window.toolbar.visible = NO;
        [self releaseResource];
        [self windowConfig];
        return NO;
    }
    return YES;
}

#pragma mark ViewCallBack
-(IBAction)onDisplayModeSegmentEvent:(NSSegmentedControl*)sender
{
    YVSceneViewDisplayMode mode = -1;
    NSLog(@"%@",NSStringFromSelector(_cmd));
    switch (sender.selectedSegment) {
        case 0:
            mode = YVSceneViewDisplayModeDeepsFirst;
            break;
        case 1:
            mode = YVSceneViewDisplayModeFlatten;
            break;
        case 2:
        default:
            mode = YVSceneViewDisplayModeSmart;
            break;
    }
    
    NSArray * children = self.window.contentViewController.childViewControllers;
    for (NSViewController * each in children) {
        if ([each isKindOfClass:YVMiddleViewController.class]) {
            YVMiddleViewController * eachmiddle = (YVMiddleViewController*)each;
            [eachmiddle changeDisplayMode:mode];
        }
    } ;
    
}
-(IBAction)onSplitSegmentEvent:(NSSegmentedControl*)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"seg event");
    NSSplitViewController * controller = (NSSplitViewController*)self.window.contentViewController;
    
    if (sender.selectedSegment == 0) {
        _isLeftSelected = !_isLeftSelected;
        if (_isLeftSelected) {
            [sender setImage:[NSImage imageNamed:@"left_blue"] forSegment:sender.selectedSegment];
            [controller.splitView setPosition:300 ofDividerAtIndex:0];
        }else{
            [sender setImage:[NSImage imageNamed:@"left_gray"] forSegment:sender.selectedSegment];
            [controller.splitView setPosition:0 ofDividerAtIndex:0];
        }
    }else{
        CGFloat windowWidth = NSApp.windows.firstObject.frame.size.width;
        
        _isRightSelected = !_isRightSelected;
        if (_isRightSelected) {
            [sender setImage:[NSImage imageNamed:@"right_blue.png"] forSegment:sender.selectedSegment];
            [controller.splitView setPosition:windowWidth - 300 ofDividerAtIndex:1];
        }else{
            [sender setImage:[NSImage imageNamed:@"right_gray.png"] forSegment:sender.selectedSegment];
            [controller.splitView setPosition:windowWidth ofDividerAtIndex:1];
            [controller.splitView setPosition:300 ofDividerAtIndex:0];
        }
    }
    NSLog(@"%ld",sender.selectedSegment);
}

-(IBAction)onDisplayCheckboxEvent:(NSButton*)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%ld",sender.state);
    NSArray * children = self.window.contentViewController.childViewControllers;
    for (NSViewController * each in children) {
        if ([each isKindOfClass:YVMiddleViewController.class]) {
            YVMiddleViewController * eachmiddle = (YVMiddleViewController*)each;
            [eachmiddle changeHiddenMode:sender.state];
        }
    } ;
}

-(IBAction)onRefreshButtonEvent:(NSButton*)sender
{
    if (self.isloading) {
        return;
    }
    [self starLoading];
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"refreshh button");
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8080?cmd=viewtree",self.host]];
    @weakify(self);
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        if (error == nil) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"request view tree success");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self notifyDataSuccess:dict];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSAlert alertWithError:error]runModal];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
                [self stopLoading];
        });
    }]resume];
}

-(void)stopLoading
{
    self.isloading = NO;
    self.loadingButton.hidden = NO;
    self.progress.hidden = YES;
    [self.progress stopAnimation:nil];}

-(void)starLoading
{
    self.isloading = YES;
    self.loadingButton.hidden = YES;
    self.progress.hidden = NO;
    [self.progress startAnimation:nil];
}

-(IBAction)onResetButtonEvent:(NSButton*)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%ld",sender.state);
    NSArray * children = self.window.contentViewController.childViewControllers;
    for (NSViewController * each in children) {
        if ([each isKindOfClass:YVMiddleViewController.class]) {
            YVMiddleViewController * eachmiddle = (YVMiddleViewController*)each;
            [eachmiddle reset];
        }
    } ;
}

-(IBAction)onJSPatchButtonEvent:(NSButton*)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if (self.jspathWindowController == nil) {
        NSStoryboard * sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
        NSWindowController * w =[sb instantiateControllerWithIdentifier:@"jspatch"];
        ((YVScriptEditorViewController*)w.contentViewController).host = self.host;
        self.jspathWindowController = w;
    }
    [self.jspathWindowController.window center];
    [self.jspathWindowController.window orderFront:self.window];

}

@end
