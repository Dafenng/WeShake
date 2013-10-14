//
//  WTShop.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface WTShop : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSNumber *shopId;
@property (copy, nonatomic) NSNumber *externId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *addr;
@property (copy, nonatomic) NSString *tel;
@property (copy, nonatomic) NSString *region;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *access;
@property (copy, nonatomic) NSString *budget;
@property (copy, nonatomic) NSString *shopType;
@property (copy, nonatomic) NSString *cuisineType;
@property (copy, nonatomic) NSString *station;
@property (copy, nonatomic) NSString *adjustedAddr;
@property (copy, nonatomic) NSNumber *latitude;
@property (copy, nonatomic) NSNumber *longitude;
@property (copy, nonatomic) NSNumber *rating;

@property (assign, nonatomic) int distance;

@end

