//
//  WTSegmentedControl.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-12.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTSegmentedControl.h"

@implementation WTSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    if (self.selectedSegmentIndex == selectedSegmentIndex) {
        [super setSelectedSegmentIndex:UISegmentedControlNoSegment];
    } else {
        [super setSelectedSegmentIndex:selectedSegmentIndex];
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
