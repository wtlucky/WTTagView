//
//  WTEditViewController.m
//  
//
//  Created by wtlucky on 7/25/15.
//  Copyright (c) 2015 wtlucky. All rights reserved.
//

#import "WTEditViewController.h"
#import <WTTagView/WTTagView.h>
#import <WTTagView/WTTagViewItem.h>
#import <WTTagView/WTTag.h>
#import "WTInputTitleViewController.h"
#import "WTPreviewViewController.h"

@interface WTEditViewController ()<WTTagViewDataSouce, WTTagViewDelegate>

@property (nonatomic, weak) IBOutlet WTTagView *tagView;

@property (nonatomic, strong) NSMutableArray *addedTags;
@property (nonatomic, assign) CGPoint selectedPoint;

@end

@implementation WTEditViewController

- (NSMutableArray *)addedTags
{
    if (nil == _addedTags) {
        _addedTags = @[].mutableCopy;
    }
    return _addedTags;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tagView.backgroundImageView.image = [UIImage imageNamed:@"background"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showInputTitleVC"]) {
        WTInputTitleViewController *vc = segue.destinationViewController;
        __weak __typeof(self)weakSelf = self;
        vc.endInputTitleHandler = ^(NSString *inputTitle) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            WTTag *tag = [[WTTag alloc] init];
            tag.titleString = inputTitle;
            tag.tagDirection = WTTagViewItemDirectionLeft;
            tag.tagCenterPointPercentage = CGPointMake(strongSelf.selectedPoint.x / strongSelf.tagView.bounds.size.width, strongSelf.selectedPoint.y / strongSelf.tagView.bounds.size.height);
            
            [strongSelf.addedTags addObject:tag];
            [strongSelf.tagView reloadData];
        };
    } else {
        WTPreviewViewController *vc = segue.destinationViewController;
        vc.tags = self.addedTags;
    }
}

#pragma mark - WTTagView DataSource

- (NSInteger)numberOfTagViewItemsInTagView:(WTTagView *)tagView
{
    return self.addedTags.count;
}

- (UIView<WTTagViewItemMethods> *)tagView:(WTTagView *)tagView tagViewItemAtIndex:(NSInteger)index
{
    WTTag *tag = self.addedTags[index];
    
    WTTagViewItem *tagViewItem = [[WTTagViewItem alloc] init];
    tagViewItem.titleText = tag.titleString;
    tagViewItem.tagViewItemDirection = tag.tagDirection;
    tagViewItem.centerPointPercentage = tag.tagCenterPointPercentage;
    return tagViewItem;
}


#pragma mark - WTTagView Delegate

- (void)tagView:(WTTagView *)tagView didTappedTagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem atIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除标签" message:@"你确定要删除标签吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = index;
    [alert show];
}

//editMode
- (void)tagView:(WTTagView *)tagView tagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem didChangedDirection:(WTTagViewItemDirection)tagViewItemDirection AtIndex:(NSInteger)index
{
    WTTag *misc = self.addedTags[index];
    misc.tagDirection = tagViewItemDirection;
}

- (void)tagView:(WTTagView *)tagView didLongPressedTagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem atIndex:(NSInteger)index
{
    WTTag *misc = self.addedTags[index];
    [tagViewItem reverseTagViewItemDirection];
    misc.tagDirection = tagViewItem.tagViewItemDirection;
}

- (void)tagView:(WTTagView *)tagView didMoveTagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem atIndex:(NSInteger)index toNewPositonPercentage:(CGPoint)pointPercentage
{
    WTTag *misc = self.addedTags[index];
    misc.tagCenterPointPercentage = pointPercentage;
}

- (void)tagView:(WTTagView *)tagView addNewTagViewItemTappedAtPosition:(CGPoint)ponit
{
    if (self.addedTags.count == 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"最多添加3个标签" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.selectedPoint = ponit;
    
    [self performSegueWithIdentifier:@"showInputTitleVC" sender:self];
}

#pragma mark - UIAlertView delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        NSInteger index = alertView.tag;
        [self.addedTags removeObjectAtIndex:index];
        [self.tagView reloadData];
    }
}

@end
