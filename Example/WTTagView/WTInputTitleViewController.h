//
//  WTInputTitleViewController.h
//  WTTagView
//
//  Created by wtlucky on 7/25/15.
//  Copyright (c) 2015 wtlucky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTInputTitleViewController : UIViewController

@property (nonatomic, copy) void (^endInputTitleHandler)(NSString *inputTitle);

@end
