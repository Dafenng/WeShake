//
//  WTShop.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShop.h"

@implementation WTShop

- (id)initWithShopId:(NSString *)shopId
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
        self.shopId = shopId;
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

- (id)initWithDict:(NSDictionary *)dict
{
    return [self initWithShopId:[dict objectForKey:@"shopId"] name:[dict objectForKey:@"name"] addr:[dict objectForKey:@"addr"] tel:[dict objectForKey:@"tel"] region:[dict objectForKey:@"region"] location:[dict objectForKey:@"location"] access:[dict objectForKey:@"access"] budget:[dict objectForKey:@"budget"] shopType:[dict objectForKey:@"shopType"] cuisineType:[dict objectForKey:@"cuisineType"] station:[dict objectForKey:@"station"] latitude:[[dict objectForKey:@"latitude"] doubleValue] longitude:[[dict objectForKey:@"longitude"] doubleValue] rating:[[dict objectForKey:@"rating"] doubleValue]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"ShopID:%@, Name:%@, Addr:%@, ImageStr:%@, Tel:%@, Region:%@, Location:%@, Access:%@, Budget:%@, Shoptype:%@, Cuisinetype:%@, Station:%@", self.shopId, self.name, self.addr, self.imageStr, self.tel, self.region, self.location, self.access, self.budget, self.shopType, self.cuisineType, self.station];
}


@end
