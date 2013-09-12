//
//  WTShopManager.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTShop.h"

typedef void (^GetShopSucceedBlock)(WTShop *shop);
typedef void (^GetShopFailBlock)();

@interface WTShopManager : NSObject

@property (assign, nonatomic) NSInteger shopIndex;
@property (assign, nonatomic) BOOL shouldActivateHTTPRequest;

+ (WTShopManager *)sharedInstance;
- (void)getOneSuggestShopWithSuccess:(GetShopSucceedBlock)succeedBlock
                             failure:(GetShopFailBlock)failBlock;

@end
