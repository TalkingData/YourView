//
//  Main.m
//  libyourview
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "Main.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "UIView+YVViewTree.h"
#import "GCDWebServerMultiPartFormRequest.h"
#import "GCDWebServerDataRequest.h"
#import "YVObjectManager.h"

@implementation Main

+(void)load
{
    [self _main];
}

+(void)_main
{
    GCDWebServer* webServer = [[GCDWebServer alloc] init];
    [webServer addDefaultHandlerForMethod:@"GET"
                             requestClass:[GCDWebServerRequest class]
                             processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                 return [GCDWebServerDataResponse responseWithJSONObject:[self _excuteCmd:request.query]];
                             }];
    
    [webServer addDefaultHandlerForMethod:@"POST" requestClass:[GCDWebServerDataRequest class] processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerDataRequest * _Nonnull request) {
        if ([request.query[@"cmd"] isEqualToString:@"setframe"]) {
            NSString * address = request.query[@"address"];
            NSDictionary * bodydict = (NSDictionary*)request.jsonObject;
            NSString * framestr = bodydict[@"framestring"];
            CGRect frame = CGRectFromString(framestr);
            NSMapTable * maptable = [YVObjectManager sharedInstance].context.viewMap;
            UIView* v = [maptable objectForKey:address];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [v setFrame:frame];
            });
        }

        return [GCDWebServerDataResponse responseWithJSONObject:@{}];
    }];
    
    [webServer startWithPort:8080 bonjourName:@"bonjour.yourview"];
    NSLog(@"Visit %@ in your web browser", webServer.serverURL);
}



+(NSDictionary *)_excuteCmd:(NSDictionary *)query
{
    NSString * cmd = query[@"cmd"];
    if ([cmd isEqualToString:@"viewtree"]) {
        __block NSDictionary * viewtree ;
        dispatch_sync(dispatch_get_main_queue(), ^{
            viewtree = [UIView rootViewTreeDictionary];
        });
        return viewtree;
    }else if ([cmd isEqualToString:@"appinfo"]){
        NSMutableDictionary * res               = [NSMutableDictionary dictionary];
        NSDictionary        * infoDict          = [[NSBundle mainBundle] infoDictionary];
        NSArray             * iconsArr          = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
        NSString            * iconLastName      = [iconsArr lastObject];
        UIImage             * iconImage         = [UIImage imageNamed:iconLastName];
        NSData              * imageData         = UIImagePNGRepresentation(iconImage);
        NSString            * imageBase64String = [imageData base64EncodedStringWithOptions:0];
        UIDevice            * currentDevice     = [UIDevice currentDevice];
        NSString            * deviceName        = currentDevice.name; // e.g. "My iPhone"
        NSString            * devicemodel       = currentDevice.model; // e.g. @"iPhone", @"iPod touch"
        NSString            * systemName        = currentDevice.systemName; // e.g. @"iOS"
        NSString            * systemVersion     = currentDevice.systemVersion; // e.g. @"4.0"
        res[@"iconimage"]                       = imageBase64String;
        res[@"devicename"]                      = deviceName;
        res[@"devicemodel"]                     = devicemodel;
        res[@"systemname"]                      = systemName;
        res[@"systemversion"]                   = systemVersion;
        [res addEntriesFromDictionary:infoDict];
        
        return res.copy;
        
    }else if ([cmd isEqualToString:@"changeapperance"]){
        
    }else if ([cmd isEqualToString:@"shake"]){
        NSString * address = query[@"address"];
        NSMapTable * maptable = [YVObjectManager sharedInstance].context.viewMap;
        UIView* v = [maptable objectForKey:address];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self shake2:v];
        });
    }else if([cmd isEqualToString:@"setframe"]){
        
    }
    return @{};
}


+ (void)shake:(UIView *)view
{
    CGRect frame = view.frame;
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
    int index;
    for (index = 3; index >=0; --index)
    {
        CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2 - frame.size.width * 0.02f * index, frame.origin.y+frame.size.height/2);
        CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2 + frame.size.width * 0.02f * index, frame.origin.y+frame.size.height/2);
    }
    CGPathCloseSubpath(shakePath);
    
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = 0.5f;
    shakeAnimation.removedOnCompletion = YES;
    
    [view.layer addAnimation:shakeAnimation forKey:nil];
    CFRelease(shakePath);
    
    
    
}


+(void)shake2:(UIView*)v
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.fromValue = [NSNumber numberWithFloat:-15];
    shake.toValue = [NSNumber numberWithFloat:15];
    shake.duration = 0.08;
    shake.autoreverses = YES;
    shake.repeatCount = 2;
    [v.layer addAnimation:shake forKey:@"shakeAnimation"];
}

@end
