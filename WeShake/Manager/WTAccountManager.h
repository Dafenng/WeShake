//
//  WTAccountManager.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-3.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTAccountManager : NSObject

+ (WTAccountManager *)sharedInstance;
- (BOOL)accountLogged;

- (NSString *)userName;

- (void)getTwitterAccountInformationWithCompletion:(void (^)(BOOL success))completion;
- (void)getFacebookAccountInformationWithCompletion:(void (^)(BOOL success))completion;

@end
