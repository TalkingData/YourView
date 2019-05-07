//
//  YVMiddleViewController.h
//  YourView
//
//  Created by bliss_ddo on 2019/4/25.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVMiddleViewController : NSViewController
-(void)changeDisplayMode:(YVSceneViewDisplayMode)newmode;
-(void)changeHiddenMode:(BOOL)newmode;
-(void)reset;
@end

NS_ASSUME_NONNULL_END
