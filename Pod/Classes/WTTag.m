//
//  WTTag.m
//  WTTagView
//
//  Created by wtlucky on 7/25/15.
//  Copyright (c) 2015 wtlucky. All rights reserved.
//

#import "WTTag.h"

@implementation WTTag

- (CGPoint)tagCenterPointPercentage
{
    return CGPointMake(self.x.floatValue, self.y.floatValue);
}

- (void)setTagCenterPointPercentage:(CGPoint)tagCenterPointPercentage
{
    self.x = [NSString stringWithFormat:@"%f", tagCenterPointPercentage.x];
    self.y = [NSString stringWithFormat:@"%f", tagCenterPointPercentage.y];
}

@end
