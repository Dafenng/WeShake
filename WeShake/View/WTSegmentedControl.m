//
//  WTSegmentedControl.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-12.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTSegmentedControl.h"
#import "WTDataDef.h"
#import <QuartzCore/QuartzCore.h>

@implementation WTSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initColors];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initColors];
    }
    
    return self;
}

- (void)initColors
{
    self.cornerRadius = 5.0;
    self.selectedColor = UIColorFromRGB(0xf4565a);
    self.deselectedColor = [UIColor clearColor];
    self.dividerColor = UIColorFromRGB(0xf4565a);
    self.selectedFont = [UIFont fontWithName:@"Arial" size:14.0];
    self.deselectedFont = [UIFont fontWithName:@"Arial" size:14.0];
    self.selectedFontColor = [UIColor whiteColor];
    self.deselectedFontColor = UIColorFromRGB(0xf4565a);
    
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = UIColorFromRGB(0xf4565a).CGColor;
    self.layer.borderWidth = 1.f;
    
}
         
+ (BOOL)isIOS7 {
    static BOOL isIOS7 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUInteger deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
        if (deviceSystemMajorVersion >= 7) {
            isIOS7 = YES;
        }
        else {
            isIOS7 = NO;
        }
    });
    return isIOS7;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    [super touchesBegan:touches withEvent:event];
    if (![[self class] isIOS7]) {
        // before iOS7 the segment is selected in touchesBegan
        if (previousSelectedSegmentIndex == self.selectedSegmentIndex) {
            // if the selectedSegmentIndex before the selection process is equal to the selectedSegmentIndex
            // after the selection process the superclass won't send a UIControlEventValueChanged event.
            // So we have to do this ourselves.
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    [super touchesEnded:touches withEvent:event];
    if ([[self class] isIOS7]) {
        // on iOS7 the segment is selected in touchesEnded
        if (previousSelectedSegmentIndex == self.selectedSegmentIndex) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
