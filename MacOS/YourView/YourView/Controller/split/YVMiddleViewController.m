//
//  MiddleViewController.m
//  revealY
//
//  Created by bliss_ddo on 2019/4/20.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVMiddleViewController.h"
#import "TravseralContext.h"
#import "YVCGRectHelper.h"
#import "YVNodeBackTracking.h"
#import "YVDisplayControl.h"

#import "SCNNode+YVPlane.h"
#import "SCNNode+YVBorder.h"
#import "SCNNode+YVSelected.h"
#import "SCNNode+YVZIndex.h"
#import "SCNNode+YVIdentifier.h"

#import "YVSceneView.h"

@interface YVMiddleViewController () <YVSceneViewDelegate>
@property (nonatomic) NSDictionary * dataSource;
@property (nonatomic) NSDictionary * extrainfo;
@property (nonatomic,strong) YVDisplayControl * displayControl;
@property (nonatomic,strong) SCNNode * cameraNode;
@end

@implementation YVMiddleViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)sceneView:(SCNView*)scnview DidSelectedNode:(SCNNode*)node
{
    NSLog(@"sceneView did select node %@",node);
    if (node) {
        [self notifyLeft:node.ZDeepsFirst];
    }else{
        [self notifyLeft:nil];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ((YVSceneView*)self.view).delegate = self;
    self.displayControl = [[YVDisplayControl alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataOK:) name:YVViewTreeDidLoadNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftControllerDidSelectedNodeIndex:) name:YVSelectionChangeLeftToMiddle object:nil];
}

-(void)notifyLeft:(NSNumber*)index
{
    [[NSNotificationCenter defaultCenter]postNotificationName:YVSelectionChangeMiddleToLeft object:index];
}

-(void)leftControllerDidSelectedNodeIndex:(NSNotification*)noti
{
    NSString * uuid = noti.object;
    [((YVSceneView*)self.view) selectedNode:uuid];
}

-(void)dataOK:(NSNotification*)noti
{
    NSDictionary * viewtreeinfo = (NSDictionary*)noti.object;
    self.dataSource = viewtreeinfo[@"viewtree"];
    self.extrainfo = viewtreeinfo[@"extrainfo"];
    CGRect screenRect = NSRectFromString(self.extrainfo[@"screeninfo"]);
    self.displayControl.screenSize = screenRect.size;
    [self createView];
}

-(void)createView
{
    SCNScene *scene = [SCNScene sceneNamed:@"empty.scn"];
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.usesOrthographicProjection = YES;
    cameraNode.camera.orthographicScale = 6;
    cameraNode.camera.automaticallyAdjustsZRange = NO;
    cameraNode.camera.zFar = 200.0f;
    self.cameraNode = cameraNode;
    [scene.rootNode addChildNode:cameraNode];
    cameraNode.position = SCNVector3Make(0, 0, 30);
    cameraNode.name = YVNodeNameCamera;
    SCNView *scnView = (SCNView *)self.view;
    scnView.scene = scene;
    scnView.allowsCameraControl = YES;
    scnView.showsStatistics = YES;
    scnView.backgroundColor = YVTHEME_SCNVIEW_BACKGROUNDCOLOR;
    NSMutableDictionary * levelDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * levelDict1 = [NSMutableDictionary dictionary];
    TravseralContext * context = [[TravseralContext alloc]init];
    [self addNode:self.dataSource deepth:0 levelDict:levelDict levelDictWithoutHiddenObject:levelDict1 context:context];
    [self reloadScreen];
}

-(void)addNode:(NSDictionary*)node deepth:(NSInteger)fatherDepth levelDict:(NSMutableDictionary*)levelDict levelDictWithoutHiddenObject:(NSMutableDictionary*)levelDictWithoutHiddenObject context:(TravseralContext*)context
{
    NSString * uuid = node[@"view_level"];
    CGRect windowRect = NSRectFromString(node[@"windowframe"]);
    NSString * snapshot = node[@"snapshot"];
    BOOL isoffscreen = [node[@"isoffscreen"] boolValue];
    CGRect transformedRect = [YVCGRectHelper UIKitRectTransformToSceneRect:windowRect withScreenSize:self.displayControl.screenSize];
    [context stepinOffScreen:isoffscreen];
    SCNNode * planeNode = [SCNNode yvplaneWithWidth:transformedRect.size.width*self.displayControl.defaultDisplayFactor height:transformedRect.size.height*self.displayControl.defaultDisplayFactor content:snapshot];
    SCNNode* selectedIndicatorNode = [SCNNode yvselectedNodeWithwidth:transformedRect.size.width*self.displayControl.defaultDisplayFactor height:transformedRect.size.height*self.displayControl.defaultDisplayFactor];
    SCNNode * borderNode = [SCNNode borderNodeWithPlane:planeNode];
    [planeNode addChildNode:selectedIndicatorNode];
    [planeNode addChildNode:borderNode];
    NSInteger bestZ = [YVNodeBackTracking findBestZFromlevelDict:levelDict minDepth:fatherDepth maxDepth:context.objectCounter frame:windowRect];
    NSInteger bestZZ = -9999999; //you dont have so much views.
    if (!isoffscreen) {
        bestZZ = [YVNodeBackTracking findBestZFromlevelDict:levelDictWithoutHiddenObject minDepth:fatherDepth maxDepth:context.objectCounterWithoutOffScreenObject frame:windowRect];
    }
    planeNode.uniqueID = uuid;
    planeNode.isOffScreen = @(isoffscreen);
    planeNode.hidden = isoffscreen;
    planeNode.position = SCNVector3Make(transformedRect.origin.x*self.displayControl.defaultDisplayFactor, transformedRect.origin.y*self.displayControl.defaultDisplayFactor, 0);
    planeNode.ZSmart = @(bestZ);
    planeNode.ZSmartWihtoutOffScreenItem = @(bestZZ);
    planeNode.ZDeepsFirst = @(context.objectCounter);
    planeNode.ZDeepsFirstWithoutOffScreenItem = @(context.objectCounterWithoutOffScreenObject);
    planeNode.ZFlatten = @(fatherDepth);
    planeNode.ZFlattenWithoutOffScreenItem = @(fatherDepth);
    self.displayControl.maxZSmart = MAX(self.displayControl.maxZSmart, bestZ);
    self.displayControl.maxZSmartOoffScreen = MAX(self.displayControl.maxZSmart, bestZZ);
    self.displayControl.maxZDFS = MAX(self.displayControl.maxZDFS, context.objectCounter);
    self.displayControl.maxZDFSOffScreen = MAX(self.displayControl.maxZDFSOffScreen, context.objectCounterWithoutOffScreenObject);
    self.displayControl.maxZFlatten = MAX(self.displayControl.maxZFlatten, fatherDepth+1);
    self.displayControl.maxZFlattenOffScreen =MAX(self.displayControl.maxZFlattenOffScreen, fatherDepth+1);
    SCNView *scnView = (SCNView *)self.view;
    [scnView.scene.rootNode addChildNode:planeNode];
    NSArray * sub = node[@"children"];
    for (NSInteger i = 0; i < sub.count; i++) {
        NSDictionary * each = sub[i];
        [self addNode:each deepth:fatherDepth+1 levelDict:levelDict levelDictWithoutHiddenObject:levelDictWithoutHiddenObject  context:context];
    }
}
-(void)changeDisplayMode:(YVSceneViewDisplayMode)newmode
{
    self.displayControl.displayMode = newmode;
    [self onDisplayModeChange];
}

-(void)changeHiddenMode:(BOOL)newmode
{
    self.displayControl.displayHiddenObject = newmode;
    [self onDisplayModeChange];
}

-(void)onDisplayModeChange
{
    [self reloadScreen];
}

-(void)reset
{
    SCNView *scnView = (SCNView *)self.view;
    [self.cameraNode lookAt:SCNVector3Make(0, 0, 0)];
    self.cameraNode.worldPosition = SCNVector3Make(0, 0, 80);
    self.cameraNode.eulerAngles = SCNVector3Make(0, 0, 0);
    scnView.pointOfView = self.cameraNode;
}
-(void)reloadScreen
{
    SCNView *scnView = (SCNView *)self.view;
    NSArray * arr = scnView.scene.rootNode.childNodes;
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.5];
    for (SCNNode * each in arr) {
        if ([each.name isEqualToString:YVNodeNamePlane]) {
            [each reloadZ:self.displayControl];
        }else{
            NSLog(@"%@",each.name);
        }
    }
    [SCNTransaction commit];
}

@end
