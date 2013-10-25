//
//  WTUser.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTUser.h"
#import "WTDataDef.h"

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

- (void)initWithUserDic:(NSDictionary *)dic
{
    self.userId = [dic objectForKey:@"id"];
    self.username = [dic objectForKey:@"username"];
    self.avatar = [dic objectForKey:@"avatar_url"];
    self.authToken = [dic objectForKey:@"auth_token"];
}

- (NSNumber *)userId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}

- (void)setUserId:(NSNumber *)userId
{
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)authToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
}

- (void)setAuthToken:(NSString *)authToken
{
    [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:@"authToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)username
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

- (void)setUsername:(NSString *)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
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
