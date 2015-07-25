//
//  WTTagView.m
//  WTTagView
//
//  Created by wtlucky on 7/25/15.
//  Copyright (c) 2015 wtlucky. All rights reserved.
//

#import "WTTagView.h"
#import "Masonry.h"

@interface WTTagView ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *tagsContainer;

@end

@implementation WTTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInitialize];
    }
    return self;
}

- (void)commonInitialize
{
    // Initialization code
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.backgroundImageView.userInteractionEnabled = YES;
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    self.tagsContainer = [[UIView alloc]initWithFrame:CGRectZero];
    self.tagsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.clipsToBounds = YES;
    self.tagsContainer.backgroundColor = [UIColor clearColor];
    self.tagsContainer.userInteractionEnabled = YES;
    [self addSubview:self.tagsContainer];
    [self.tagsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundViewDidTapped:)];
    tap.delegate = self;
    [self.backgroundImageView addGestureRecognizer:tap];
    
    self.disableTagArea = CGRectZero;
}

#pragma mark - Tags Relation Methods

- (void)reloadData
{
    NSAssert(self.dataSource, @"You should set tagView's dataSource!");
    
    //remove old tags
    [self.tagsContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIView *)obj removeFromSuperview];
    }];
    
    NSInteger tagCount = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfTagViewItemsInTagView:)]) {
        tagCount = [self.dataSource numberOfTagViewItemsInTagView:self];
    }
    
    if ([self.dataSource respondsToSelector:@selector(tagView:tagViewItemAtIndex:)]) {
        for (NSInteger i = 0; i < tagCount; i ++) {
            UIView<WTTagViewItemMethods> *tagViewItem = [self.dataSource tagView:self tagViewItemAtIndex:i];
            tagViewItem.containerCountIndex = i;
            tagViewItem.adaptViewScale = self.bounds.size.width / 320.0f;
            
            //编辑模式独有事件
            if (self.viewMode == WTTagViewModeEdit) {
                //长按事件
                UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tagViewItemLongPressed:)];
                [tagViewItem addGestureRecognizer:longPressGesture];
                
                //拖动事件
                UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tagViewItemDidDraged:)];
                [tagViewItem addGestureRecognizer:panGesture];
            }
            
            //点击事件
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagViewItemTapped:)];
            [tagViewItem addGestureRecognizer:tapGesture];
            
            [tagViewItem adjustViewFrameWithGivenPositionPercentage:tagViewItem.centerPointPercentage andContainerSize:self.bounds.size];
            
            
            //编辑模式独有事件
            if (self.viewMode == WTTagViewModeEdit) {
                
                //编辑模式下位置有可能改变
                if ([self.delegate respondsToSelector:@selector(tagView:didMoveTagViewItem:atIndex:toNewPositonPercentage:)]) {
                    CGPoint itemPosition = tagViewItem.layer.position;
                    CGPoint centerPointPercentage = CGPointMake(itemPosition.x / self.bounds.size.width, itemPosition.y / self.bounds.size.height);
                    [self.delegate tagView:self didMoveTagViewItem:tagViewItem atIndex:tagViewItem.containerCountIndex toNewPositonPercentage:centerPointPercentage];
                }
                
            }
            
            [self.tagsContainer addSubview:tagViewItem];
        }
    }
}

#pragma mark - TagsContainer Show & Hide

- (void)showTagItems
{
    NSAssert(self.viewMode == WTTagViewModePreview, @"You can only call this method in Preview mode");
    
    if ([self.delegate respondsToSelector:@selector(tagViewItemsWillShowInTagView:)]) {
        [self.delegate tagViewItemsWillShowInTagView:self];
    }
    [UIView animateWithDuration:0.15f animations:^{
        self.tagsContainer.alpha = self.tagsContainer.hidden ? 1: 0;
        self.tagsContainer.hidden = !self.tagsContainer.hidden;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(tagViewItemsDidShowInTagView:)]) {
            [self.delegate tagViewItemsDidShowInTagView:self];
        }
    }];
}

- (void)hideTagItems
{
    NSAssert(self.viewMode == WTTagViewModePreview, @"You can only call this method in Preview mode");
    
    if ([self.delegate respondsToSelector:@selector(tagViewItemsWillHideInTagView:)]) {
        [self.delegate tagViewItemsWillHideInTagView:self];
    }
    [UIView animateWithDuration:0.15f animations:^{
        self.tagsContainer.alpha = self.tagsContainer.hidden ? 1: 0;
    } completion:^(BOOL finished) {
        self.tagsContainer.hidden = !self.tagsContainer.hidden;
        if ([self.delegate respondsToSelector:@selector(tagViewItemsDidHideInTagView:)]) {
            [self.delegate tagViewItemsDidHideInTagView:self];
        }
    }];
}

- (void)makeTagItemsAnimated
{
    [self.tagsContainer.subviews enumerateObjectsUsingBlock:^(UIView<WTTagViewItemMethods> *item, NSUInteger idx, BOOL *stop) {
        [item runAnimation];
    }];
}

#pragma mark - Gesture CallBack Methods

- (void)backGroundViewDidTapped:(UIGestureRecognizer *)recognizer
{
    if (self.viewMode == WTTagViewModePreview) {
        [self showTagItems];
    }
}

- (void)tagViewItemTapped:(UIGestureRecognizer *)gestureRecognizer
{
    UIView<WTTagViewItemMethods> *tagViewItem = (UIView<WTTagViewItemMethods> *)gestureRecognizer.view;
    if ([self.delegate respondsToSelector:@selector(tagView:didTappedTagViewItem:atIndex:)]) {
        [self.delegate tagView:self didTappedTagViewItem:tagViewItem atIndex:tagViewItem.containerCountIndex];
    }
}

- (void)tagViewItemLongPressed:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView<WTTagViewItemMethods> *tagViewItem = (UIView<WTTagViewItemMethods> *)gestureRecognizer.view;
        if ([self.delegate respondsToSelector:@selector(tagView:didLongPressedTagViewItem:atIndex:)]) {
            [self.delegate tagView:self didLongPressedTagViewItem:tagViewItem atIndex:tagViewItem.containerCountIndex];
        }
    }
}

- (void)tagViewItemDidDraged:(UIGestureRecognizer *)gestureRecognizer
{
    UIView<WTTagViewItemMethods> *tagViewItem = (UIView<WTTagViewItemMethods> *)gestureRecognizer.view;
    CGPoint centerPoint = [gestureRecognizer locationInView:self.tagsContainer];
    CGRect containerBounds = self.tagsContainer.bounds;
    
    void (^reportDelegateSavePosition)() = ^ {
        if ([self.delegate respondsToSelector:@selector(tagView:didMoveTagViewItem:atIndex:toNewPositonPercentage:)]) {
            CGPoint itemPosition = tagViewItem.layer.position;
            CGPoint centerPointPercentage = CGPointMake(itemPosition.x / self.bounds.size.width, itemPosition.y / self.bounds.size.height);
            [self.delegate tagView:self didMoveTagViewItem:tagViewItem atIndex:tagViewItem.containerCountIndex toNewPositonPercentage:centerPointPercentage];
        }
    };
    
    //判断不可放置tag区域
    if (CGRectContainsPoint(self.disableTagArea, centerPoint)) {
        reportDelegateSavePosition();
        return;
    }
    
    //判断纵向是否超出边界
    CGFloat tagViewTopHeight = tagViewItem.bounds.size.height * tagViewItem.layer.anchorPoint.y;
    CGFloat tagViewBottomHeight = tagViewItem.bounds.size.height - tagViewTopHeight;
    if (centerPoint.y - tagViewTopHeight < containerBounds.origin.y || centerPoint.y + tagViewBottomHeight > containerBounds.origin.y + containerBounds.size.height) {
        reportDelegateSavePosition();
        return;
    }
    
    //判断横向是否超出边界
    CGFloat tagViewLeftWidth = tagViewItem.bounds.size.width * tagViewItem.layer.anchorPoint.x;
    CGFloat tagViewRightWidth = tagViewItem.bounds.size.width - tagViewLeftWidth;
    
    if (tagViewItem.tagViewItemDirection == WTTagViewItemDirectionLeft) {
        centerPoint.x -= tagViewItem.bounds.size.width / 2;
        if (centerPoint.x - tagViewLeftWidth < containerBounds.origin.x || centerPoint.x + tagViewRightWidth > containerBounds.origin.x + containerBounds.size.width) {
            if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
                if ([tagViewItem checkCanReverseTagViewItemDirectionWithContainerSize:self.bounds.size])
                {
                    [tagViewItem reverseTagViewItemDirection];
                    if ([self.delegate respondsToSelector:@selector(tagView:tagViewItem:didChangedDirection:AtIndex:)]) {
                        [self.delegate tagView:self tagViewItem:tagViewItem didChangedDirection:tagViewItem.tagViewItemDirection AtIndex:tagViewItem.containerCountIndex];
                    }
                }
            }
            reportDelegateSavePosition();
            return;
        }
        [tagViewItem setCenter:CGPointMake(centerPoint.x, centerPoint.y)];
    } else {
        centerPoint.x += tagViewItem.bounds.size.width / 2;
        if (centerPoint.x - tagViewLeftWidth < containerBounds.origin.x || centerPoint.x + tagViewRightWidth > containerBounds.origin.x + containerBounds.size.width) {
            if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
                if ([tagViewItem checkCanReverseTagViewItemDirectionWithContainerSize:self.bounds.size])
                {
                    [tagViewItem reverseTagViewItemDirection];
                    if ([self.delegate respondsToSelector:@selector(tagView:tagViewItem:didChangedDirection:AtIndex:)]) {
                        [self.delegate tagView:self tagViewItem:tagViewItem didChangedDirection:tagViewItem.tagViewItemDirection AtIndex:tagViewItem.containerCountIndex];
                    }
                }
            }
            reportDelegateSavePosition();
            return;
        }
        [tagViewItem setCenter:CGPointMake(centerPoint.x, centerPoint.y)];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        reportDelegateSavePosition();
    }
    
    [tagViewItem setNeedsLayout];
    [tagViewItem setNeedsUpdateConstraints];
}

#pragma mark - UIGestureRecognize Delegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.backgroundImageView == touch.view) {
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == self.tagsContainer) {
        if (self.viewMode == WTTagViewModePreview) {
            [self hideTagItems];
        } else if (self.viewMode == WTTagViewModeEdit) {
            if ([self.delegate respondsToSelector:@selector(tagView:addNewTagViewItemTappedAtPosition:)]) {
                CGPoint position = [touch locationInView:self.tagsContainer];
                if (!CGRectContainsPoint(self.disableTagArea, position)) {
                    [self.delegate tagView:self addNewTagViewItemTappedAtPosition:position];
                }
            }
        }
    }
    
}

@end
