//
//  WTPost.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-12.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface WTPost : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSDate *createTime;
@property (nonatomic, copy) NSNumber *postId;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *photo;

+ (NSDateFormatter *)dateFormatter;

@end
