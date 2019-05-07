//
//  YVWindowController.h
//  YourView
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVWindowController : NSWindowController
@property (weak) IBOutlet NSButton *loadingButton;
@property (weak) IBOutlet NSProgressIndicator *progress;

-(void)showToolbar:(BOOL)visable;
-(void)updateAppInfo:(NSDictionary*)appinfo;
-(void)updateViewTree:(NSDictionary*)dict;
-(void)configureSplit;

-(IBAction)onDisplayModeSegmentEvent:(NSSegmentedControl*)sender;
-(IBAction)onSplitSegmentEvent:(NSSegmentedControl*)sender;
-(IBAction)onDisplayCheckboxEvent:(NSButton*)sender;
-(IBAction)onRefreshButtonEvent:(NSButton*)sender;
-(IBAction)onResetButtonEvent:(NSButton*)sender;
-(IBAction)onJSPatchButtonEvent:(NSButton*)sender;


@property (nonatomic) NSString * host;
@end

NS_ASSUME_NONNULL_END
