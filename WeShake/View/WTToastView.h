//
//  WTToastView.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat CSToastCornerRadius        = 10.0;
static const CGFloat CSToastHorizontalPadding   = 10.0;
static const CGFloat CSToastVerticalPadding     = 10.0;
static const CGFloat CSToastOpacity             = 0.8;
static const CGFloat CSToastFontSize            = 16.0;
static const CGFloat CSToastMaxTitleLines       = 0;
static const CGFloat CSToastMaxMessageLines     = 0;
static const CGFloat CSToastMaxWidth            = 0.8;
static const CGFloat CSToastMaxHeight           = 0.8;
static const CGFloat CSToastFadeDuration        = 1.2;
static const BOOL    CSToastDisplayShadow       = YES;

static const CGFloat CSToastImageViewWidth      = 80.0;
static const CGFloat CSToastImageViewHeight     = 80.0;

static const CGFloat CSToastShadowOpacity       = 0.8;
static const CGFloat CSToastShadowRadius        = 6.0;
static const CGSize  CSToastShadowOffset        = { 4.0, 4.0 };

@interface WTToastView : UIView

- (id)initWithMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;

@end
