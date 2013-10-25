//
//  WTShopPhoto.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-25.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShopPhoto.h"

@implementation WTShopPhoto

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"numId": @"num_id",
             @"shopPhotoId": @"id",
             @"photoUrl": @"photo_url",
             @"shopId": @"shop_id"
             };
}

@end
