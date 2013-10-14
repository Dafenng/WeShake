//
//  WTPost.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-12.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTPost.h"

@implementation WTPost

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"postId": @"id",
             @"userId": @"user_id",
             @"createTime": @"created_at",
             @"photo": @"photo.url"
             };
}

@end
