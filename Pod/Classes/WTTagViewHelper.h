//
//  WTTagViewHelper.h
//  WTTagView
//
//  Created by wtlucky on 7/25/15.
//  Copyright (c) 2015 wtlucky. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HEXCOLORA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@interface WTTagViewHelper : NSObject

+ (BOOL)osVersionIsiOS8;

+ (NSString *)tagIconName;
+ (NSString *)tagLeftBgImageName;
+ (NSString *)tagRightBgImageName;

@end
