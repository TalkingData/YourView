//
//  YVRightCellViewFrame.h
//  YourView
//
//  Created by bliss_ddo on 2019/5/6.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVRightCellBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface YVRightCellViewFrame : YVRightCellBase
@property (weak) IBOutlet NSStepper *stepperx;
@property (weak) IBOutlet NSTextField *fieldx;
@property (weak) IBOutlet NSStepper *steppery;
@property (weak) IBOutlet NSTextField *fieldy;
@property (weak) IBOutlet NSStepper *stepperw;
@property (weak) IBOutlet NSTextField *fieldw;
@property (weak) IBOutlet NSStepper *stepperh;
@property (weak) IBOutlet NSTextField *fieldh;
- (IBAction)setFrameButtonPressed:(id)sender;

@end

NS_ASSUME_NONNULL_END
