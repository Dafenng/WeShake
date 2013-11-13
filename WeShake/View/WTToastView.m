//
//  WTToastView.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTToastView.h"
#import <QuartzCore/QuartzCore.h>
#import "WTShopPhoto.h"
#import "UIImageView+AFNetworking.h"
#import "WTDataDef.h"
#import "EDStarRating.h"

@interface WTToastView ()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopInfoLabel;
@property (weak, nonatomic) IBOutlet EDStarRating *ratingStar;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
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

- (void)setupStarRatingSatrWithRating:(CGFloat)rating
{
    self.ratingStar.backgroundColor  = [UIColor clearColor];
    self.ratingStar.starImage = [UIImage imageNamed:@"grey_star.png"];
    self.ratingStar.starHighlightedImage = [UIImage imageNamed:@"star.png"];
    self.ratingStar.maxRating = 5.0;
    self.ratingStar.horizontalMargin = 0.0;
    self.ratingStar.editable = NO;
    self.ratingStar.rating = rating;
    self.ratingStar.displayMode=EDStarRatingDisplayHalf;
    [self.ratingStar  setNeedsDisplay];
}

- (void)setupWithShop:(WTShop *)aShop
{
    self.layer.cornerRadius = 10.f;
    self.backgroundColor = UIColorFromRGB(0xf4565a);
    
    __block WTShopPhoto *shopPhoto;
    [aShop.shopPhotos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([((WTShopPhoto *)obj).photoType isEqualToString:@"outside"] &&
            [((WTShopPhoto *)obj).sizeType isEqualToString:@"square"])
        {
            shopPhoto = obj;
            *stop = YES;
        }
    }];
    
    [self.shopImageView setImageWithURL:[NSURL URLWithString:shopPhoto.photoUrl] placeholderImage:[UIImage imageNamed:@"shop_toast_image.png"]];
    self.shopInfoLabel.text = aShop.name;
    [self setupStarRatingSatrWithRating:aShop.rating.floatValue];
    if (aShop.lunchBudgetAverage.integerValue == 0) {
        self.budgetLabel.text = @"¥未知";
    } else {
        self.budgetLabel.text = [NSString stringWithFormat:@"¥%d", aShop.lunchBudgetAverage.integerValue];
    }
    self.genreLabel.text = aShop.shopType;
    self.shopDistanceLabel.text = [NSString stringWithFormat:@"%dm", aShop.distance];
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
