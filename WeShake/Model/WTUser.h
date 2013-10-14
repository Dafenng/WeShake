//
//  WTUser.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTUser : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *authToken;

+ (WTUser *)sharedInstance;
- (void)initWithUserDic:(NSDictionary *)dic;

@end
