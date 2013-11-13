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
    return @{@"shopPhotoId": @"id",
             @"photoType": @"photo_type",
             @"sizeType" : @"size_type",
             @"photoUrl": @"photo_url",
             @"shopId": @"shop_id",
             @"desc": @"description"
             };
}

@end
