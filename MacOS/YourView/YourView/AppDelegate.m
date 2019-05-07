//
//  AppDelegate.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/24.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (strong) NSWindow * window;
@end

@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window = NSApp.windows.firstObject;
    [self.window center];
}
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag{
    if (!flag){
        [NSApp activateIgnoringOtherApps:NO];
        [self.window makeKeyAndOrderFront:self];
    }
    return YES;
}
@end
