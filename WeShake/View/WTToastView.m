//
//  WTToastView.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTToastView.h"
#import <QuartzCore/QuartzCore.h>

@interface WTToastView ()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *shopDistanceLabel;

@end

@implementation WTToastView

+ (id)toastviewFromNib
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"WTToastView" owner:nil options:nil];
	return [nibs objectAtIndex:0];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupWithMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    
    if((message == nil) && (title == nil) && (image == nil)) return;
    
    self.layer.cornerRadius = 10.0;
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOpacity = CSToastShadowOpacity;
//    self.layer.shadowRadius = CSToastShadowRadius;
//    self.layer.shadowOffset = CSToastShadowOffset;
    self.backgroundColor = [UIColor blackColor];
    
    self.shopImageView.image = image;
    self.shopInfoLabel.text = title;
    self.shopDistanceLabel.text = message;
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
