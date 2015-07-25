//
//  WTTagViewMItem.m
//  WTTagView
//
//  Created by wtlucky on 7/25/15.
//  Copyright (c) 2015 wtlucky. All rights reserved.
//

#import "WTTagViewMItem.h"
#import "WTTagViewHelper.h"

static const CGFloat kTagViewItemSideEdge = 6.0f;
static const CGFloat kTagViewItemCornerSideEdge = 10.0f;

@interface WTTagViewMItem ()

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIImageView *tagImageView;
@property (strong, nonatomic) UIImageView *titleBgImageView;
@property (strong, nonatomic) UIImage *leftBgImage;
@property (strong, nonatomic) UIImage *rightBgImage;

@property (assign, nonatomic) CGSize cachedTagSize;

@end

@implementation WTTagViewMItem

- (instancetype)init
{
    if (self = [self initWithFrame:CGRectZero]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    UIImageView *tagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[WTTagViewHelper tagIconName]]];
    tagImageView.layer.zPosition = 2;
    [self addSubview:tagImageView];
    self.tagImageView = tagImageView;
    
    UIImageView *titleBgImageView = [[UIImageView alloc] initWithImage:self.leftBgImage];
    [self addSubview:titleBgImageView];
    self.titleBgImageView = titleBgImageView;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:[self getAdaptViewScaleConstant:11.0f]];
    titleLabel.shadowOffset = CGSizeMake(0.5f, 1.0f);
    titleLabel.shadowColor = HEXCOLORA(0x000000, 0.5);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    self.cachedTagSize = CGSizeZero;
}

#pragma mark - Setters/Getters

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (UIImage *)leftBgImage
{
    if (nil == _leftBgImage) {
        _leftBgImage = [[UIImage imageNamed:[WTTagViewHelper tagLeftBgImageName]] resizableImageWithCapInsets:UIEdgeInsetsMake([self getAdaptViewScaleConstant:8.0f], [self getAdaptViewScaleConstant:10.0f], [self getAdaptViewScaleConstant:2.0f], [self getAdaptViewScaleConstant:6.0f]) resizingMode:UIImageResizingModeStretch];
    }
    return _leftBgImage;
}

- (UIImage *)rightBgImage
{
    if (nil == _rightBgImage) {
        _rightBgImage = [[UIImage imageNamed:[WTTagViewHelper tagRightBgImageName]] resizableImageWithCapInsets:UIEdgeInsetsMake([self getAdaptViewScaleConstant:8.0f], [self getAdaptViewScaleConstant:10.0f], [self getAdaptViewScaleConstant:2.0f], [self getAdaptViewScaleConstant:6.0f]) resizingMode:UIImageResizingModeStretch];
    }
    return _rightBgImage;
}

- (CGSize)cachedTagSize
{
    if (CGSizeEqualToSize(_cachedTagSize, CGSizeZero)) {
        CGFloat imageWidth = [self getAdaptViewScaleConstant:21];
        CGFloat deltaSpace = [self getAdaptViewScaleConstant:kTagViewItemCornerSideEdge + kTagViewItemSideEdge];
        CGSize titleSize = [self.titleText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[self getAdaptViewScaleConstant:11.0f]]}];
        _cachedTagSize = CGSizeMake(imageWidth + deltaSpace + titleSize.width, imageWidth);
    }
    return _cachedTagSize;
}

#pragma mark - WTTagViewItem Methods

@synthesize centerPointPercentage = _centerPointPercentage;
@synthesize containerCountIndex = _containerCountIndex;
@synthesize tagViewItemDirection = _tagViewItemDirection;
@synthesize adaptViewScale = _adaptViewScale;

- (CGSize)tagSize
{
    return self.cachedTagSize;
}

- (CGFloat)tagWidth
{
    return self.tagSize.width;
}

- (CGFloat)tagHeight
{
    return self.tagSize.height;
}

- (void)setTagViewItemDirection:(WTTagViewItemDirection)tagViewItemDirection
{
    _tagViewItemDirection = tagViewItemDirection;
}

- (void)setAdaptViewScale:(CGFloat)adaptViewScale
{
    _adaptViewScale = adaptViewScale;
    //更新了adaptScale,字体需要改变，背景拉伸图需要改变，约束需要改变
    self.titleLabel.font = [UIFont systemFontOfSize:[self getAdaptViewScaleConstant:11.0f]];
    self.leftBgImage = nil;
    self.rightBgImage = nil;
    self.cachedTagSize = CGSizeZero;
}

- (CGFloat)getAdaptViewScaleConstant:(CGFloat)originalConstant
{
    return self.adaptViewScale * originalConstant;
}

- (void)configAdjustAnchorPoint
{
    CGPoint anchorPoint = CGPointZero;
    if (self.tagViewItemDirection == WTTagViewItemDirectionLeft) {
        if ([WTTagViewHelper osVersionIsiOS8]) {
            anchorPoint = CGPointMake([self getAdaptViewScaleConstant:13.0f] / self.tagWidth, [self getAdaptViewScaleConstant:4.0f] / self.tagHeight);
        } else {
            anchorPoint = CGPointMake(13.0f / self.tagWidth, 4.0 / self.tagHeight);
        }
    } else {
        if ([WTTagViewHelper osVersionIsiOS8]) {
            anchorPoint = CGPointMake((self.tagWidth - [self getAdaptViewScaleConstant:8.0f]) / self.tagWidth, [self getAdaptViewScaleConstant:4.0f] / self.tagHeight);
        } else {
            anchorPoint = CGPointMake((self.tagWidth - 8.0f) / self.tagWidth, 4.0f / self.tagHeight);
        }
    }
    self.layer.anchorPoint = anchorPoint;
}

- (void)adjustViewFrameWithGivenPositionPercentage:(CGPoint)pointPercentage andContainerSize:(CGSize)size
{
    self.frame = CGRectMake(0, 0, self.tagWidth, self.tagHeight);
    [self configAdjustAnchorPoint];
    CGPoint exactPoint = CGPointMake(pointPercentage.x * size.width, pointPercentage.y * size.height);
    
    //左边标签超出边界
    if (exactPoint.x - self.tagWidth * self.layer.anchorPoint.x < 0) {
        exactPoint.x = self.tagWidth * self.layer.anchorPoint.x;
    }
    //右边标签超出边界
    if (exactPoint.x + self.tagWidth * (1 - self.layer.anchorPoint.x) > size.width) {
        exactPoint.x = size.width - self.tagWidth * (1 - self.layer.anchorPoint.x);
    }
    //上边标签超出边界
    if (exactPoint.y - self.tagHeight * self.layer.anchorPoint.y < 0) {
        exactPoint.y = self.tagHeight * self.layer.anchorPoint.y;
    }
    //下边标签超出边界
    if (exactPoint.y + self.tagHeight * (1 - self.layer.anchorPoint.y) > size.height) {
        exactPoint.y = size.height - self.tagHeight * (1 - self.layer.anchorPoint.y);
    }
    
    self.layer.position = exactPoint;
}

- (void)reverseTagViewItemDirection
{
    CGPoint currentCenter = self.center;
    CGFloat offsetLength = self.tagWidth - ([WTTagViewHelper osVersionIsiOS8] ? [self getAdaptViewScaleConstant:21.0f] : 21.0f);
    CGPoint newCenter = currentCenter;
    if (self.tagViewItemDirection == WTTagViewItemDirectionLeft) {
        self.tagViewItemDirection = WTTagViewItemDirectionRight;
        newCenter.x += offsetLength;
    } else {
        self.tagViewItemDirection = WTTagViewItemDirectionLeft;
        newCenter.x -= offsetLength;
    }
    
    //iOS7下 AutoLayout的bug，开始计算出的tagWidth尺寸不对，所以需要重新计算下
    if (![WTTagViewHelper osVersionIsiOS8]) {
        self.frame = CGRectMake(0, 0, self.tagWidth, self.tagHeight);
    }
    
    [self configAdjustAnchorPoint];
    [self setCenter:newCenter];
    
    [self setNeedsLayout];
}

- (BOOL)checkCanReverseTagViewItemDirectionWithContainerSize:(CGSize)size
{
    if (self.tagViewItemDirection == WTTagViewItemDirectionLeft) {
        if (self.frame.origin.x <= self.tagWidth / 2) {
            return NO;
        }
        return YES;
    } else {
        if (size.width - self.frame.origin.x - self.tagWidth <= self.tagWidth / 2) {
            return NO;
        }
        return YES;
    }
}

- (void)runAnimation
{
    //设置旋转点 根据资源图片计算得出
    CGPoint newAnchorPoint = CGPointMake(0.61, 0.19);
    self.tagImageView.layer.anchorPoint = newAnchorPoint;
    //移动到正确的位置
    CGSize imageViewSize = CGSizeMake(self.tagHeight, self.tagHeight);
    self.tagImageView.transform = CGAffineTransformMakeTranslation((newAnchorPoint.x - 0.5) * imageViewSize.width, (newAnchorPoint.y - 0.5) * imageViewSize.height);
    
    //关键帧动画
    CALayer *layer = self.tagImageView.layer;
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1.0f;
    animation.cumulative = YES;
    animation.repeatCount = INFINITY;
    animation.values = @[
                         @(0.0f),
                         @(-M_PI / 5),
                         @(-M_PI / 3),
                         @(-M_PI / 5),
                         @(0.0f)
                         ];
    animation.timingFunctions = @[
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                                  ];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [layer addAnimation:animation forKey:@"tagViewItemRotate"];
}

#pragma mark - Override Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.tagViewItemDirection == WTTagViewItemDirectionLeft) {
        CGRect frame = CGRectMake(0, 0, self.tagHeight, self.tagHeight);
        self.tagImageView.frame = frame;
        frame.origin.x += self.tagHeight;
        frame.size.width = self.tagWidth - self.tagHeight;
        self.titleBgImageView.frame = frame;
        self.titleBgImageView.image = self.leftBgImage;
        frame.origin.x += [self getAdaptViewScaleConstant:kTagViewItemCornerSideEdge];
        self.titleLabel.frame = frame;
    } else {
        CGRect frame = CGRectMake(0, 0, self.tagWidth - self.tagHeight, self.tagHeight);
        self.titleBgImageView.frame = frame;
        self.titleBgImageView.image = self.rightBgImage;
        frame.origin.x += [self getAdaptViewScaleConstant:kTagViewItemSideEdge];
        self.titleLabel.frame = frame;
        frame.origin.x = self.tagWidth - self.tagHeight;
        frame.size.width = self.tagHeight;
        self.tagImageView.frame = frame;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect frame = CGRectInset(self.bounds, -20, -20);
    
    return CGRectContainsPoint(frame, point) ? self : nil;
}

@end
