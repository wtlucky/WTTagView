//
//  WTTagView.h
//  WTTagView
//
//  Created by wtlucky on 7/25/15.
//  Copyright (c) 2015 wtlucky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WTTagViewMode) {
    WTTagViewModeEdit = 0, //编辑模式
    WTTagViewModePreview = 1, //查看模式
};

typedef NS_ENUM(NSInteger, WTTagViewItemDirection) {
    WTTagViewItemDirectionLeft = 0,
    WTTagViewItemDirectionRight = 1,
};

/**
 *  TagView上的tag视图需要实现的方法
 */
@protocol WTTagViewItemMethods <NSObject>

/**
 *  锚点所在位置的百分比
 */
@property (assign, nonatomic) CGPoint centerPointPercentage;
@property (assign, nonatomic, readonly) CGSize tagSize;
@property (assign, nonatomic, readonly) CGFloat tagWidth;
@property (assign, nonatomic, readonly) CGFloat tagHeight;
@property (assign, nonatomic) WTTagViewItemDirection tagViewItemDirection;

/**
 *  用于在容器中计数使用
 */
@property (assign, nonatomic) NSInteger containerCountIndex;

/**
 *  view尺寸适配缩放比
 */
@property (assign, nonatomic) CGFloat adaptViewScale;

/**
 *  计算适配尺寸的常量值，生成view的约束与字体值等常量都需要通过这个方法进行转换再使用
 *
 *  @param originalConstant 原始常量值
 *
 *  @return 适配后的常量值
 */
- (CGFloat)getAdaptViewScaleConstant:(CGFloat)originalConstant;

/**
 *  设置tag的锚点（layer.anchorPoint），即在图片上固定位置的点，所有的动画都是基于这个点的.
 */
- (void)configAdjustAnchorPoint;

/**
 *  根据指定的x，y百分比值，以及给定容器的size，计算tag的显示位置，这里设置layer.position即可，这里要保证view的frame已经存在，并且layer.anchorPoint已经被正确设置。PS:方法中应该实现，如果指定的位置放不下tag的处理方案，转向还是移动。
 *
 *  @param pointPercentage x,y坐标的百分比
 *  @param size            容器的size
 */
- (void)adjustViewFrameWithGivenPositionPercentage:(CGPoint)pointPercentage andContainerSize:(CGSize)size;

/**
 *  检查是否可以转向
 *
 *  @param size 容器的尺寸
 *
 *  @return 可否转向
 */
- (BOOL)checkCanReverseTagViewItemDirectionWithContainerSize:(CGSize)size;

/**
 *  反转tag方向
 */
- (void)reverseTagViewItemDirection;

@optional
/**
 *  播放tag动画
 */
- (void)runAnimation;

@end

@class WTTagView;

@protocol WTTagViewDataSouce <NSObject>

- (NSInteger)numberOfTagViewItemsInTagView:(WTTagView *)tagView;
- (UIView<WTTagViewItemMethods> *)tagView:(WTTagView *)tagView tagViewItemAtIndex:(NSInteger)index;

@end

@protocol WTTagViewDelegate <NSObject>

@optional

- (void)tagView:(WTTagView *)tagView didTappedTagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem atIndex:(NSInteger)index;

//editMode
- (void)tagView:(WTTagView *)tagView tagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem didChangedDirection:(WTTagViewItemDirection)tagViewItemDirection AtIndex:(NSInteger)index;
- (void)tagView:(WTTagView *)tagView didLongPressedTagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem atIndex:(NSInteger)index;
- (void)tagView:(WTTagView *)tagView didMoveTagViewItem:(UIView<WTTagViewItemMethods> *)tagViewItem atIndex:(NSInteger)index toNewPositonPercentage:(CGPoint)pointPercentage;
- (void)tagView:(WTTagView *)tagView addNewTagViewItemTappedAtPosition:(CGPoint)ponit;

- (void)tagViewItemsWillShowInTagView:(WTTagView *)tagView;
- (void)tagViewItemsDidShowInTagView:(WTTagView *)tagView;
- (void)tagViewItemsWillHideInTagView:(WTTagView *)tagView;
- (void)tagViewItemsDidHideInTagView:(WTTagView *)tagView;

@end


@interface WTTagView : UIView

@property (strong, nonatomic) UIImageView *backgroundImageView;

//更换了模式，必须调用reloadData才能生效
@property (assign, nonatomic) IBInspectable NSInteger viewMode;

@property (weak, nonatomic) IBOutlet id<WTTagViewDataSouce> dataSource;
@property (weak, nonatomic) IBOutlet id<WTTagViewDelegate> delegate;

/**
 *  编辑模式，不允许打tag的区域，这里只是表示tagViewItem的锚点不能进入的区域，并不表示整个tagViewItem不能进入的区域。默认为CGRectZero.
 */
@property (assign, nonatomic) CGRect disableTagArea;

- (instancetype)initWithFrame:(CGRect)frame;

//会废弃以前的tagItem,从dataSouse重新获取
- (void)reloadData;

//非编辑模式下启用
- (void)hideTagItems;
- (void)showTagItems;
- (void)makeTagItemsAnimated;


@end
