//
//  WTUser.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTUser.h"

@implementation WTUser

+ (WTUser *)sharedInstance
{
    static WTUser *_sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _sharedInstance = [[WTUser alloc] init];
        
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        ;
    }
    return self;
}

- (NSString *)userId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}

- (void)setUserId:(NSString *)userId
{
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)nickname
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
}

- (void)setNickname:(NSString *)nickname
{
    [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)avatar
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
}

- (void)setAvatar:(NSString *)avatar
{
    [[NSUserDefaults standardUserDefaults] setObject:avatar forKey:@"avatar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
