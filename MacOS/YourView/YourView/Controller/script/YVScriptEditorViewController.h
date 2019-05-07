//
//  YVScriptEditorViewController.h
//  YourView
//
//  Created by bliss_ddo on 2019/4/30.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVScriptEditorViewController : NSViewController
@property (nonatomic,strong) NSString * host;
-(IBAction)onSendingEvent:(NSButton*)sender;
@property (nonatomic) IBOutlet NSTextView * tv;
@end

NS_ASSUME_NONNULL_END
