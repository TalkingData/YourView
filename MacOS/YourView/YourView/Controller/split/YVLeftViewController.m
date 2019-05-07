//
//  YVLeftViewController.m
//  YourView
//
//  Created by bliss_ddo on 2019/4/25.
//  Copyright © 2019 bliss_ddo. All rights reserved.
//

#import "YVLeftViewController.h"
#import "YVSelectableTextView.h"
#import "SCNNode+YVZindex.h"
#import "SCNNode+YVIdentifier.h"

@interface YVLeftViewController ()
@property (nonatomic) IBOutlet NSOutlineView * treeview;
@property (nonatomic) IBOutlet NSTextField * textfield;
@property (nonatomic) NSDictionary * dataSource;
@property (nonatomic) NSString * searchString;
@end

@implementation YVLeftViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)dataOK:(NSNotification*)noti
{
    NSDictionary * viewtreeinfo = (NSDictionary*)noti.object;
    self.dataSource = viewtreeinfo[@"viewtree"];
    [self.treeview reloadData];
    [self.treeview expandItem:nil expandChildren:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataOK:) name:YVViewTreeDidLoadNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(contextDidChange:) name:NSControlTextDidChangeNotification object:self.textfield];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(middleSelectionDidChange:) name:YVSelectionChangeMiddleToLeft object:nil];
}

-(void)middleSelectionDidChange:(NSNotification*)noti
{
    NSNumber * index = (NSNumber*)noti.object;
    if (index) {
        NSInteger sindex = index.integerValue;
        [self.treeview expandItem:nil expandChildren:YES];
        [self.treeview selectRowIndexes:[NSIndexSet indexSetWithIndex:sindex] byExtendingSelection:false];
        [self.treeview scrollRowToVisible:sindex];
        [self notifyRight:sindex];
    }else{
        //        [self.treeview selectRowIndexes: nil byExtendingSelection:false];
    }
}
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selectedRow = self.treeview.selectedRow;
    NSDictionary * selectedItem = [self.treeview itemAtRow:selectedRow];
    NSString * uuid = selectedItem[@"view_level"];
    NSLog(@"%@",uuid);
    [self notifyMiddle:uuid];
    [self notifyRight:selectedRow];
}

-(void)notifyRight:(NSInteger)index
{
    NSDictionary * selectedItem = [self.treeview itemAtRow:index];
    [[NSNotificationCenter defaultCenter]postNotificationName:YVSelectionChangeLeftToRight object:selectedItem];
}
-(void)notifyMiddle:(NSString*)uuid
{
    [[NSNotificationCenter defaultCenter]postNotificationName:YVSelectionChangeLeftToMiddle object:uuid];
}




#pragma mark NSOutlineViewDelegate
- (void)outlineView:(NSOutlineView *)outlineView didClickTableColumn:(NSTableColumn *)tableColumn
{
    NSLog(@"%@",tableColumn);
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectTableColumn:(nullable NSTableColumn *)tableColumn
{
    NSLog(@"%@",tableColumn);
    return YES;
}

-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    NSDictionary * ds = (NSDictionary*)item;
    if (ds == nil) {
        return 1;
    }
    NSArray * arr = ds[@"children"];
    return arr.count;
}

-(id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    NSDictionary * ds = (NSDictionary*)item;
    if (ds == nil) {
        return self.dataSource;
    }
    NSArray * arr = ds[@"children"];
    return arr[index];
}
-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    NSDictionary * ds = (NSDictionary*)item;
    if (ds == nil) {
        return YES;
    }
    NSArray * arr = ds[@"children"];
    return arr.count > 0;
}

-(id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    if (item == nil) {
        return self.dataSource[@"class"];
    }
    NSString * type = ((NSDictionary*)item)[@"class"];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:type];
    [attrStr setAttributes:@{NSFontAttributeName:[NSFont systemFontOfSize:12]} range:NSMakeRange(0, type.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[NSColor darkGrayColor] range:NSMakeRange(0, type.length)];

    if (self.searchString) {
        NSRange searchRange = [type.lowercaseString rangeOfString:self.searchString.lowercaseString];
        if (searchRange.location != NSNotFound) {
            [attrStr addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:searchRange];
            [attrStr addAttribute:NSBackgroundColorAttributeName value:[NSColor yellowColor] range:searchRange];
        }
    }
    
    [attrStr insertAttributedString:[[NSMutableAttributedString alloc]initWithString:@" "] atIndex:0];
    
//    NSString *imageName = @"left_blue.png";
    NSString *imageName = @"cellimage_view@2x.png";
    NSImage * img = [NSImage imageNamed:imageName];
    NSData * imgData = [img TIFFRepresentationUsingCompression:6 factor:0.5];

    NSFileWrapper *imageFileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:imgData];
    imageFileWrapper.filename = imageName;
    imageFileWrapper.preferredFilename = imageName;
    
    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] initWithFileWrapper:imageFileWrapper];
//    imageAttachment.bounds = CGRectMake(0, -paddingTop, font.lineHeight, font.lineHeight);
//    CGFloat paddingTop = displayFont.lineHeight - displayFont.pointSize;

    imageAttachment.bounds = CGRectMake(0, -20, 10, 10);

    NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    [attrStr insertAttributedString:imageAttributedString atIndex:0];

    
    return attrStr;
}


-(NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    YVSelectableTextView *cellView = [outlineView makeViewWithIdentifier:@"cellView" owner:nil];
    if (cellView == nil) {
        cellView = [[YVSelectableTextView alloc] init];
        cellView.identifier = @"cellView";
        cellView.editable = NO;
        cellView.textContainer.widthTracksTextView = NO;
        cellView.textContainer.containerSize = CGSizeMake(10000, 10000);
        cellView.backgroundColor = [NSColor clearColor];
    }
    
    NSAttributedString * attrStr = [self outlineView:outlineView objectValueForTableColumn:tableColumn byItem:item];
    [cellView.textStorage setAttributedString:attrStr];
    return cellView;
}
- (CGFloat)outlineView:(NSOutlineView *)outlineView
     heightOfRowByItem:(id)item
{
    return 18;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item
{
    return YES;
}

- (void)contextDidChange:(NSNotification *)notification
{
    NSLog(@"change");
    self.searchString = self.textfield.stringValue;
    [self.treeview expandItem:nil expandChildren:YES];
    [self.treeview reloadData];
    
}



@end
