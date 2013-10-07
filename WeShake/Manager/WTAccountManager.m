//
//  WTAccountManager.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-3.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTAccountManager.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface WTAccountManager ()

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (copy, nonatomic) NSString *accountType;
@property (strong, nonatomic) ACAccount *account;

@end

@implementation WTAccountManager

+ (WTAccountManager *)sharedInstance
{
    static WTAccountManager *_sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _sharedInstance = [[WTAccountManager alloc] init];
        
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
        if ([_accountStore.accounts count] > 0) {
            _account = [_accountStore.accounts firstObject];
        }
    }
    return self;
}

- (BOOL)accountLogged
{
    return self.account != nil;
}

- (NSString *)userName
{
    return self.account.username;
}

- (void)getTwitterAccountInformationWithCompletion:(void (^)(BOOL success))completion
{
    ACAccountType *twitterAccountType = [self.accountStore
                                         accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accountsArray = [self.accountStore accountsWithAccountType:twitterAccountType];
            if ([accountsArray count] > 0) {
                self.account = [accountsArray objectAtIndex:0];
                self.accountType = ACAccountTypeIdentifierTwitter;
                completion(YES);
            } else {
                completion(NO);
            }
        } else {
            completion(NO);
        }
    }];
}

- (void)getFacebookAccountInformationWithCompletion:(void (^)(BOOL success))completion
{
    ACAccountType *facebookAccountType = [self.accountStore
                                          accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{
                              @"ACFacebookAppIdKey" : @"727920337234915",
                              @"ACFacebookPermissionsKey" : @[@"user_about_me"],
                              @"ACFacebookAudienceKey" : ACFacebookAudienceEveryone};
    
    [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accountsArray = [self.accountStore accountsWithAccountType:facebookAccountType];
            
            if ([accountsArray count] > 0) {
                self.account = [accountsArray objectAtIndex:0];
                self.accountType = ACAccountTypeIdentifierFacebook;
                completion(YES);
            } else {
                completion(NO);
            }
        } else {
            completion(NO);
        }
    }];
}


@end
