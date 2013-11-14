//
//  WTShop.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShop.h"

@implementation WTShop

- (id)init
{
    self = [super init];
    if (self) {
        _shopPhotos = [NSMutableArray array];
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"shopId": @"id",
             @"externId": @"extern_id",
             @"genreInfo": @"genre_info",
             @"openTime": @"open_time",
             @"lunchBudget": @"lunch_budget",
             @"lunchBudgetAverage": @"lunch_budget_average",
             @"dinnerBudget": @"dinner_budget",
             @"dinnerBudgetAverage": @"dinner_budget_average",
             @"shopType": @"shop_type",
             @"defaultSquareImage": @"default_square_image"
             };
}

+ (NSValueTransformer *)shopPhotosJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:WTShopPhoto.class];
}

//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"ShopID:%@, Name:%@, Addr:%@, Tel:%@, Region:%@, Location:%@, Access:%@, Budget:%@, Shoptype:%@, Cuisinetype:%@, Station:%@", self.shopId, self.name, self.addr, self.tel, self.region, self.location, self.access, self.budget, self.shopType, self.cuisineType, self.station];
//}


@end
