//
//  UIView+YVNodeInfo.m
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "UIView+YVNodeInfo.h"

@implementation UIView (YVNodeInfo)
-(NSDictionary*)nodeInfo
{
    NSString * _snapshot = [self _snapWithSublayer:NO];
    NSString * _localframe = [self _localframe];
    NSString * _windowframe = [self _windowFrame];
    NSNumber * _isOffScreen = [self _isOffScreen];
    NSDictionary * selfinfo = @{
             @"snapshot":_snapshot,
             @"localframe":_localframe,
             @"windowframe":_windowframe,
             @"isoffscreen":_isOffScreen
             };
    NSDictionary * superinfo = [super nodeInfo];
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    [result addEntriesFromDictionary:selfinfo];
    [result addEntriesFromDictionary:superinfo];
    return result.copy;
}

-(NSString*)_windowFrame
{
    CGRect windowRect = [UIScreen mainScreen].bounds;
    windowRect = [self convertRect:self.bounds toView:nil];
    return NSStringFromCGRect(windowRect);
}

-(NSString*)_localframe
{
    return NSStringFromCGRect(self.frame);
}


-(NSString*)_snapWithSublayer:(BOOL)containSublayer
{

    NSMutableArray * restoreArray = [NSMutableArray array];
    if (!containSublayer) {
        for (CALayer*ly in self.layer.sublayers) {
            if (!ly.hidden && ![ly isKindOfClass:NSClassFromString(@"_UILabelContentLayer")]) {
                ly.hidden = YES;
                [restoreArray addObject:ly];
            }
        }
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData * imageData = UIImagePNGRepresentation(snapshot);
    NSString * imageStringBase64 = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    if (!containSublayer) {
        for (CALayer*ly in restoreArray) {
            ly.hidden = NO;
        }
    }
    if (imageStringBase64 == nil) {
        NSLog(@"view snap shot is nil");
        NSLog(@"[❌%@]",self);
    }
    return imageStringBase64==nil ?@"":imageStringBase64;
}

-(NSNumber*)_isOffScreen
{
    CGRect windowRect = [UIScreen mainScreen].bounds;
    windowRect = [self convertRect:self.bounds toView:nil];
    CGFloat x = windowRect.origin.x;
    CGFloat y = windowRect.origin.y;
    CGFloat screenWidth = [[UIScreen mainScreen]bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen]bounds].size.height;
    BOOL isoffscreen = NO;
    if (x < 0 || y < 0 || x >= screenWidth || y >= screenHeight) {
        isoffscreen = YES;
    }
    return @(isoffscreen);
}

@end
