//
//  WTShopAnnotation.m
//  WeShake
//
//  Created by Dafeng Jin on 13-11-1.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShopAnnotation.h"

@implementation WTShopAnnotation

- (id)initWithShop:(WTShop *)shop
{
    self = [super init];
    if (self) {
        _title = shop.name;
//        _coordinate = CLLocationCoordinate2DMake(30.222000, 120.222000);
        _coordinate = CLLocationCoordinate2DMake(shop.latitude.doubleValue, shop.longitude.doubleValue);
    }
    
    return self;
}

@end
