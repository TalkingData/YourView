//
//  YVScriptEditorViewController.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/30.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVScriptEditorViewController.h"

@implementation YVScriptEditorViewController
-(IBAction)onSendingEvent:(NSButton*)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if (!self.tv.string) {
        return;
    }
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8080?cmd=jspatch",self.host]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = [self.tv.string dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request addValue:@"text/text" forHTTPHeaderField:@"Content-Type"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    }]resume];
}
@end
