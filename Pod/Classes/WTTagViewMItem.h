//
//  WTTagViewMItem.h
//  WTTagView
//
//  Created by wtlucky on 7/25/15.
//  Copyright (c) 2015 wtlucky. All rights reserved.
//

#import "WTTagView.h"

/**
 *  Implementation using frame layout.
 */
@interface WTTagViewMItem : UIView<WTTagViewItemMethods>

@property (copy, nonatomic) NSString *titleText;

- (instancetype)init;

@end
