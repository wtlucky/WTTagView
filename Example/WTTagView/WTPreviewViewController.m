//
//  WTPreviewViewController.m
//  WTTagView
//
//  Created by wtlucky on 7/25/15.
//  Copyright (c) 2015 wtlucky. All rights reserved.
//

#import "WTPreviewViewController.h"
#import <WTTagView/WTTagView.h>
#import <WTTagView/WTTagViewMItem.h>
#import <WTTagView/WTTag.h>

@interface WTPreviewViewController ()<WTTagViewDataSouce, WTTagViewDelegate>

@property (nonatomic, weak) IBOutlet WTTagView *tagView;

@end

@implementation WTPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"展示页面";
    
    self.tagView.backgroundImageView.image = [UIImage imageNamed:@"background"];
    [self.tagView reloadData];
    [self.tagView makeTagItemsAnimated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WTTagView DataSource

- (NSInteger)numberOfTagViewItemsInTagView:(WTTagView *)tagView
{
    return self.tags.count;
}

- (UIView<WTTagViewItemMethods> *)tagView:(WTTagView *)tagView tagViewItemAtIndex:(NSInteger)index
{
    WTTag *tag = self.tags[index];
    
    WTTagViewMItem *tagViewItem = [[WTTagViewMItem alloc] init];
    tagViewItem.titleText = tag.titleString;
    tagViewItem.tagViewItemDirection = tag.tagDirection;
    tagViewItem.centerPointPercentage = tag.tagCenterPointPercentage;
    return tagViewItem;
}


#pragma mark - WTTagView Delegate

- (void)tagView:(WTTagView *)tagView didTappedTagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem atIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:((WTTagViewMItem *)tagViewItem).titleText delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


@end
