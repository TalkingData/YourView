//
//  AppDelegate.m
//  TalkingDataSDKDemo
//
//  Created by liweiqiang on 2017/5/22.
//  Copyright © 2017年 TendCloud. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    <UNUserNotificationCenterDelegate>
#endif

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    

    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 10.0;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Register for notifications with device token:%@", deviceToken);

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Fail to register for remote notifications with error:%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Receive remote notification:%@", userInfo);

}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {

    completionHandler();
}
#endif

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"Update location:%@", locations);
}




-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return YES;
    
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return YES;
}


@end
