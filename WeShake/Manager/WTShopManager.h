//
//  WTShopManager.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTShop.h"
#import "WTDataDef.h"

@interface WTShopManager : NSObject

+ (WTShopManager *)sharedInstance;
- (void)getSuggestShopWithSuccess:(void (^)(WTShop *shop))successBlock
                          failure:(void (^)(ErrorType errorCode))failureBlock;

- (void)getSearchShopsFrom:(NSInteger)start
                     count:(NSInteger)count
                   success:(void (^)(NSArray *shops))successBlock
                   failure:(void (^)(ErrorType errorCode))failureBlock;

- (void)getSearchShopsWithRegion:(NSString *)aRegion
                            area:(NSString *)anArea
                        district:(NSString *)aDistrict
                           genre:(NSString *)aGenre
                         cuisine:(NSString *)aCuisine
                          period:(NSString *)aPeriod
                          budget:(NSString *)aBudget
                            from:(NSInteger)start
                           count:(NSInteger)aCount
                         sucsess:(void (^)(NSArray *shops))successBlock
                         failure:(void (^)(ErrorType errorCode))failureBlock;
@end
