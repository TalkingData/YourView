//
//  YVRightCellViewInfo.h
//  YourView
//
//  Created by bliss_ddo on 2019/5/6.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YVRightCellBase.h"
NS_ASSUME_NONNULL_BEGIN

@interface YVRightCellViewInfo : YVRightCellBase
@property (weak) IBOutlet NSTextField *addressfield;
@property (weak) IBOutlet NSTextField *classfield;
@property (weak) IBOutlet NSTextField *viewcontrollerfield;
@property (weak) IBOutlet NSTextField *levelfield;
@property (weak) IBOutlet NSTextField *depthfield;
@property (weak) IBOutlet NSTextField *isintablefield;
@property (weak) IBOutlet NSTextField *isincollectionfield;
@property (weak) IBOutlet NSTextField *indexpathfield;
@property (weak) IBOutlet NSTextField *inheritfield;

-(IBAction)hereButtonPressed:(NSButton*)sender;
@end

NS_ASSUME_NONNULL_END
