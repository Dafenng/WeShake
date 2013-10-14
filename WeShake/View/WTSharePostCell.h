//
//  WTSharePostCell.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-13.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTPost.h"

@interface WTSharePostCell : UITableViewCell

+ (id)cellFromNib;
- (void)initWithPost:(WTPost *)post;

@end
