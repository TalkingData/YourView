//
//  SCNNode+YVVisual.m
//  YourView
//
//  Created by bliss_ddo on 2019/5/5.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "SCNNode+YVVisual.h"

@implementation SCNNode (YVVisual)
-(void)hover
{
    SCNNode * borderChild = [self childNodeWithName:YVNodeNameBorder recursively:YES];
    if (borderChild) {
        borderChild.geometry.firstMaterial.diffuse.contents = YVTHEME_NODE_HOVERBORDERCOLOR;
    }
}
-(void)unhover
{
    SCNNode * borderChild = [self childNodeWithName:YVNodeNameBorder recursively:YES];
    if (borderChild) {
        borderChild.geometry.firstMaterial.diffuse.contents = YVTHEME_NODE_HOVERBORDERNORMALCOLOR;
    }
}

-(void)highlight
{
    SCNNode * indicator = [self childNodeWithName:YVNodeNameIndicator recursively:YES];
    if (indicator) {
        indicator.hidden = NO;
    }
}
-(void)lowlight
{
    SCNNode * indicator = [self childNodeWithName:YVNodeNameIndicator recursively:YES];
    if (indicator) {
        indicator.hidden = YES;
    }
}
@end
