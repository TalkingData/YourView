//
//  YVLoadingViewController.h
//  YourView
//
//  Created by bliss_ddo on 2019/4/25.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVLoadingViewController : NSViewController
@property (weak) IBOutlet NSTextField *infolabel;
@property (nonatomic,copy) NSString * host;
@end

NS_ASSUME_NONNULL_END
