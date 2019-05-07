//
//  AppDelegate.h
//  TalkingDataSDKDemo
//
//  Created by liweiqiang on 2017/5/22.
//  Copyright © 2017年 TendCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
#import <UserNotifications/UserNotifications.h>
#endif
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
    UNUserNotificationCenterDelegate,
#endif
    CLLocationManagerDelegate,
    UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

