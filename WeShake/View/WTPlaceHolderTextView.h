//
//  WTPlaceHolderTextView.h
//  WeShake
//
//  Created by Dafeng Jin on 13-11-10.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 UITextView subclass that adds placeholder support like UITextField has.
 */

@interface WTPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
