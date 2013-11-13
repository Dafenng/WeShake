//
//  WTToastView.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTShop.h"

@interface WTToastView : UIView

+ (id)toastviewFromNib;
- (void)setupWithMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;
- (void)setupWithShop:(WTShop *)aShop;
@end
