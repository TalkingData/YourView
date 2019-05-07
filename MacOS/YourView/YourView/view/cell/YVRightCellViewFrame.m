//
//  YVRightCellViewFrame.m
//  YourView
//
//  Created by bliss_ddo on 2019/5/6.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVRightCellViewFrame.h"

@implementation YVRightCellViewFrame

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


-(void)fillData:(NSDictionary*)data
{
    NSString * frameStr = data[@"localframe"];
    CGRect frame = NSRectFromString(frameStr);
    self.fieldx.floatValue = frame.origin.x;
    self.stepperx.floatValue = frame.origin.x;
    self.fieldy.floatValue = frame.origin.y;
    self.steppery.floatValue = frame.origin.y;
    self.fieldw.floatValue = frame.size.width;
    self.stepperw.floatValue = frame.size.width;
    self.fieldh.floatValue = frame.size.height;
    self.stepperh.floatValue = frame.size.height;
}
- (IBAction)setFrameButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidClick:withData:cmd:)]) {
        CGRect frame = CGRectMake(self.fieldx.floatValue, self.fieldy.floatValue, self.fieldw.floatValue, self.fieldh.floatValue);
        NSString * framestring = NSStringFromRect(frame);
        [self.delegate cellDidClick:self withData:framestring cmd:@"setframe"];
    }
}
@end
