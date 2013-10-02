//
//  WTShop.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTShop : NSObject

@property (copy, nonatomic) NSString *shopId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *addr;
@property (copy, nonatomic) NSString *imageStr;
@property (copy, nonatomic) NSString *tel;
@property (copy, nonatomic) NSString *region;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *access;
@property (copy, nonatomic) NSString *budget;
@property (copy, nonatomic) NSString *shopType;
@property (copy, nonatomic) NSString *cuisineType;
@property (copy, nonatomic) NSString *station;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) double rating;
@property (assign, nonatomic) int distance;


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
              rating:(double)rating;

- (id)initWithDict:(NSDictionary *)dict;
@end

