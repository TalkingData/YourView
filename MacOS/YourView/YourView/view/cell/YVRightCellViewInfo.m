//
//  YVRightCellViewInfo.m
//  YourView
//
//  Created by bliss_ddo on 2019/5/6.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVRightCellViewInfo.h"

@implementation YVRightCellViewInfo

-(void)fillData:(NSDictionary*)data
{
    NSString * address = data[@"address"];
    NSString * class = data[@"class"];
    NSString * vc = data[@"assign_to_viewcontroller"];
    NSString * level =data[@"view_level"];
    NSNumber * depth = data[@"view_deepth"];
    NSNumber * isintable = data[@"is_in_tableview"];
    NSNumber * isincollection = data[@"is_in_collectionview"];
    NSString * indexrow = data[@"index_row"];
    NSString * indexsection = data[@"index_section"];
    NSString * inherit = data[@"inherit"];
    self.addressfield.stringValue = [NSString stringWithFormat:@"%@",address];
    self.classfield.stringValue = [NSString stringWithFormat:@"%@",class];
    self.viewcontrollerfield.stringValue = [NSString stringWithFormat:@"%@",vc];
    self.levelfield.stringValue = [NSString stringWithFormat:@"%@",level];
    self.depthfield.stringValue = [NSString stringWithFormat:@"%@",depth];
    self.isintablefield.stringValue = [NSString stringWithFormat:@"%@",isintable];
    self.isincollectionfield.stringValue = [NSString stringWithFormat:@"%@",isincollection];
    self.indexpathfield.stringValue = [NSString stringWithFormat:@"(%@,%@)",indexsection,indexrow];
    self.inheritfield.stringValue = [NSString stringWithFormat:@"%@",inherit];

}
-(IBAction)hereButtonPressed:(NSButton*)sender
{
    NSLog(@"btn pressed");
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidClick:withData:cmd:)]) {
        [self.delegate cellDidClick:self withData:nil cmd:@"shake"];
    }
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
