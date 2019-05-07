//
//  YVSceneView.h
//  YourView
//
//  Created by bliss_ddo on 2019/4/28.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YVSceneViewDelegate <NSObject>

-(void)sceneView:(SCNView*)scnview DidSelectedNode:(SCNNode*)node;

@end

@interface YVSceneView : SCNView
@property(nonatomic,weak) id <YVSceneViewDelegate> delegate;
-(void)selectedNode:(NSString*)uuid;
@end

NS_ASSUME_NONNULL_END
