//
//  YVRightCellBase.h
//  YourView
//
//  Created by bliss_ddo on 2019/5/6.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YVRightCellProtocol <NSObject>
-(void)cellDidClick:(NSView*)cell withData:(nullable id)data cmd:(NSString*)cmd;
@end

@interface YVRightCellBase : NSView
+(instancetype)makeView:(NSTableView*)tableView owner:(id)owner identifer:(NSString*)identifer;
-(void)fillData:(id)data;
@property(nonatomic,weak) id <YVRightCellProtocol> delegate;
@end

NS_ASSUME_NONNULL_END
