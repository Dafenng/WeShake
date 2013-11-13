//
//  WTShop.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
#import "WTShopPhoto.h"

@interface WTShop : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSNumber *shopId;
@property (copy, nonatomic) NSNumber *externId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *addr;
@property (copy, nonatomic) NSNumber *latitude;
@property (copy, nonatomic) NSNumber *longitude;
@property (copy, nonatomic) NSString *tel;
@property (copy, nonatomic) NSString *access;
@property (copy, nonatomic) NSString *genreInfo;
@property (copy, nonatomic) NSString *openTime;
@property (copy, nonatomic) NSString *holiday;
@property (copy, nonatomic) NSString *lunchBudget;
@property (copy, nonatomic) NSNumber *lunchBudgetAverage;
@property (copy, nonatomic) NSString *dinnerBudget;
@property (copy, nonatomic) NSNumber *dinnerBudgetAverage;
@property (copy, nonatomic) NSNumber *rating;
@property (copy, nonatomic) NSString *region;
@property (copy, nonatomic) NSString *area;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *shopType;
@property (copy, nonatomic) NSString *genre;
@property (copy, nonatomic) NSString *cuisine;
@property (strong, nonatomic) NSArray *shopPhotos;

@property (assign, nonatomic) int distance;

@end

