//
//  WTPost.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-12.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTPost.h"
#import "WTDataDef.h"

@implementation WTPost

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
#ifdef TEST_ENV
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss+08:00";
#else
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss+00:00";
#endif
    return dateFormatter;
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"postId": @"id",
             @"userId": @"user_id",
             @"createTime": @"created_at",
             @"photo": @"photo_url"
             };
}

+ (NSValueTransformer *)createTimeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}


@end
