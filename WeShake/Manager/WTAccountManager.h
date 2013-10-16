//
//  WTAccountManager.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-3.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UserRegisterBlock)(BOOL success);

@interface WTAccountManager : NSObject

+ (WTAccountManager *)sharedInstance;
- (BOOL)accountLogged;

- (NSString *)userName;

- (void)getTwitterAccountInformationWithCompletion:(UserRegisterBlock)completion;
- (void)getFacebookAccountInformationWithCompletion:(UserRegisterBlock)completion;

@end
