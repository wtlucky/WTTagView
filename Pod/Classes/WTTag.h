//
//  WTTag.h
//  WTTagView
//
//  Created by wtlucky on 7/25/15.
//  Copyright (c) 2015 wtlucky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTTag : NSObject

@property (assign, nonatomic) NSInteger tagDirection;
@property (copy, nonatomic) NSString *x;
@property (copy, nonatomic) NSString *y;
@property (assign, nonatomic) CGPoint tagCenterPointPercentage;
@property (copy, nonatomic) NSString *titleString;

@end
