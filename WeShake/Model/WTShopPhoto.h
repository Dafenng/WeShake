//
//  WTShopPhoto.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-25.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface WTShopPhoto : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *numId;
@property (nonatomic, copy) NSNumber *shopPhotoId;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, copy) NSNumber *shopId;

@end
