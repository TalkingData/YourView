//
//  YVSceneView.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVSceneView.h"
#import "SCNNode+YVVisual.h"
#import "SCNNode+YVZindex.h"
#import "SCNNode+YVIdentifier.h"

@interface YVSceneView()
@property (nonatomic,strong) NSTrackingArea * trackingArea;
@property (nonatomic,strong) SCNNode * hoverNode;
@property (nonatomic,strong) SCNNode * selectedNode;
@end

@implementation YVSceneView
@synthesize delegate = _delegate;

-(void)awakeFromNib
{
    NSLog(@"awake from nib");
    self.backgroundColor = YVTHEME_SCNVIEW_BACKGROUNDCOLOR;
    if (self.trackingArea == nil) {
        [self createTrackingArea];
        self.hoverNode = nil;
    }
    NSClickGestureRecognizer *clickGesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(onMouseClick:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:clickGesture];
    [gestureRecognizers addObjectsFromArray:self.gestureRecognizers];
    self.gestureRecognizers = gestureRecognizers;
}

-(void)createTrackingArea
{
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                                options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow )
                                                                  owner:self
                                                               userInfo:nil];
    self.trackingArea = trackingArea;
    [self addTrackingArea:trackingArea];
}

- (void)updateTrackingAreas
{
    NSLog(@"update tracking areas");
    [self removeTrackingArea:self.trackingArea];
    self.trackingArea = nil;
    [self createTrackingArea];
    [super updateTrackingAreas];
}


#pragma mark MouseEvent

- (void)onMouseClick:(NSGestureRecognizer *)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self];
    NSArray *hitResults = [self hitTest:p options:@{SCNHitTestOptionCategoryBitMask:[NSNumber numberWithInteger:
                                                                                     (YVHitTestOptionCategoryBitMaskPlaneNode)],SCNHitTestIgnoreHiddenNodesKey:@(YES)}];
    if ([hitResults count] > 0) {
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        SCNNode * hitNode = result.node;
        if (self.selectedNode != hitNode) {
            [self.selectedNode lowlight];
            [hitNode highlight];
            self.selectedNode = hitNode;
        }
    }else{
        [self.selectedNode lowlight];
        self.selectedNode = nil;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sceneView:DidSelectedNode:)]) {
        [self.delegate sceneView:self DidSelectedNode:self.selectedNode];
    }
}



-(void)onMouseMoved:(NSEvent*)theEvent
{
    NSPoint p = theEvent.locationInWindow;
    NSPoint converted = [self convertPoint:p fromView:nil];
    NSArray *hitResults = [self hitTest:converted options:@{SCNHitTestOptionCategoryBitMask:[NSNumber numberWithInteger:
                                                                                             (YVHitTestOptionCategoryBitMaskPlaneNode)],SCNHitTestIgnoreHiddenNodesKey:@(YES)}];
    if ([hitResults count] > 0) {
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        SCNNode * hitNode = result.node;
        if (hitNode != self.hoverNode){
            [self.hoverNode unhover];
            [hitNode hover];
            self.hoverNode = hitNode;
        }
    }
    else{
        [self.hoverNode unhover];
        self.hoverNode = nil;
    }
}

-(void)mouseMoved:(NSEvent *)theEvent
{
    [super mouseMoved:theEvent];
    [self onMouseMoved:theEvent];
}

-(void)selectedNode:(NSString*)uuid
{
    @weakify(self);
    [self.scene.rootNode childNodesPassingTest:^BOOL(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        @strongify(self);
        if ([child.name isEqualToString:YVNodeNamePlane]) {
            if ([child.uniqueID isEqualToString:uuid]) {
                if (child != self.selectedNode){
                    [self.selectedNode lowlight];
                    [child highlight];
                    self.selectedNode = child;
                }
                *stop = YES;
            }
        }
        return YES;
    }];
}

@end
