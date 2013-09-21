//
//  WTSearchViewCell.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-14.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTSearchViewCell.h"

@interface WTSearchViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopCuisineLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopAddrLabel;

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

- (void)setupSearchViewCellWithShop:(WTShop *)shop
{
    self.shopNameLabel.text = shop.name;
    self.shopCuisineLabel.text = shop.cuisineType;
    self.shopDistanceLabel.text = [NSString stringWithFormat:@"%dm", shop.distance];
    self.shopAddrLabel.text = shop.addr;
}

@end
