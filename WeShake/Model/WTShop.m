//
//  WTShop.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShop.h"

@implementation WTShop

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"shopId": @"id",
             @"externId": @"extern_id",
             @"shopType": @"shop_type",
             @"cuisineType": @"cuisine_type",
             @"adjustedAddr": @"adjusted_addr"};
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"ShopID:%@, Name:%@, Addr:%@, Tel:%@, Region:%@, Location:%@, Access:%@, Budget:%@, Shoptype:%@, Cuisinetype:%@, Station:%@", self.shopId, self.name, self.addr, self.tel, self.region, self.location, self.access, self.budget, self.shopType, self.cuisineType, self.station];
}


@end
