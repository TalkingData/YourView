//
//  YVSelectableTextView.m
//  YourView
//
//  Created by bliss_ddo on 2019/5/5.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVSelectableTextView.h"

@implementation YVSelectableTextView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

-(NSView *)hitTest:(NSPoint)point
{
    return self.superview;
}

@end
