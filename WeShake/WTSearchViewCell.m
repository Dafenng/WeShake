//
//  WTSearchViewCell.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-14.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTSearchViewCell.h"
#import "EDStarRating.h"
#import "UIImageView+AFNetworking.h"
#import "WTShopPhoto.h"
#import <QuartzCore/QuartzCore.h>

@interface WTSearchViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet EDStarRating *shopRatingView;
@property (weak, nonatomic) IBOutlet UILabel *shopBudgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopCuisineLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopDistanceLabel;

@end

@implementation WTSearchViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupStarRatingViewWithRating:(CGFloat)rating
{
    self.shopRatingView.backgroundColor  = [UIColor clearColor];
    self.shopRatingView.starImage = [UIImage imageNamed:@"grey_star.png"];
    self.shopRatingView.starHighlightedImage = [UIImage imageNamed:@"star.png"];
    self.shopRatingView.maxRating = 5.0;
    self.shopRatingView.horizontalMargin = 0.0;
    self.shopRatingView.editable = NO;
    self.shopRatingView.rating = rating;
    self.shopRatingView.displayMode=EDStarRatingDisplayHalf;
    [self.shopRatingView  setNeedsDisplay];
}

- (void)setupSearchViewCellWithShop:(WTShop *)shop
{
    self.containerView.layer.cornerRadius = 5.f;
    
    [self.shopImageView setImageWithURL:[NSURL URLWithString:shop.defaultSquareImage] placeholderImage:[UIImage imageNamed:@"cell_shop_profile_default.png"]];
    self.shopNameLabel.text = shop.name;
    [self setupStarRatingViewWithRating:shop.rating.floatValue];
    if (shop.lunchBudgetAverage.integerValue == 0) {
        self.shopBudgetLabel.text = @"¥不明";
    } else {
        self.shopBudgetLabel.text = [NSString stringWithFormat:@"予算: ¥%ld", (long)shop.lunchBudgetAverage.integerValue];
    }
    
    self.shopCuisineLabel.text = shop.shopType;
    self.shopDistanceLabel.text = [NSString stringWithFormat:@"%dm", shop.distance];
}

@end
