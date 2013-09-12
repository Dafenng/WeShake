//
//  WTShop.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShop.h"

@implementation WTShop

- (id)initWithShopID:(NSString *)shopID
                name:(NSString *)name
                addr:(NSString *)addr
                 tel:(NSString *)tel
              region:(NSString *)region
            location:(NSString *)location
              access:(NSString *)access
              budget:(NSString *)budget
            shopType:(NSString *)shopType
         cuisineType:(NSString *)cuisineType
             station:(NSString *)station
            latitude:(double)latitude
           longitude:(double)longitude
              rating:(double)rating
{
    self = [super init];
    
    if(self)
    {
        self.name = name;
        self.addr = addr;
        self.tel = tel;
        self.imageStr = nil;
        self.region = region;
        self.location = location;
        self.access = access;
        self.budget = budget;
        self.shopType = shopType;
        self.cuisineType = cuisineType;
        self.station = station;
        self.latitude = latitude;
        self.longitude = longitude;
        self.rating = rating;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"ShopID:%@, Name:%@, Addr:%@, ImageStr:%@, Tel:%@, Region:%@, Location:%@, Access:%@, Budget:%@, Shoptype:%@, Cuisinetype:%@, Station:%@", self.shopID, self.name, self.addr, self.imageStr, self.tel, self.region, self.location, self.access, self.budget, self.shopType, self.cuisineType, self.station];
}


@end
