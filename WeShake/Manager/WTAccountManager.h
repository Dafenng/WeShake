//
//  WTAccountManager.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-3.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

typedef void (^UserRegisterBlock)(BOOL success);

@interface WTAccountManager : NSObject

+ (WTAccountManager *)sharedInstance;
- (BOOL)accountLogged;
- (ACAccountStore *)accountStore;
- (NSString *)userName;


- (void)getTwitterAccountInformationWithCompletion:(UserRegisterBlock)completion;
- (void)getFacebookAccountInformationWithCompletion:(UserRegisterBlock)completion;

@end
