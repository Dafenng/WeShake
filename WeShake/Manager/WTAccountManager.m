//
//  WTAccountManager.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-3.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTAccountManager.h"
#import <Social/Social.h>
#import "AFNetworking.h"
#import "JSONKit.h"
#import "WTUser.h"
#import "WTHttpEngine.h"
#import "WTDataDef.h"
#import "SVProgressHUD.h"

@interface WTAccountManager ()

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (copy, nonatomic) NSString *accountTypeIdentifier;
@property (copy, nonatomic) NSString *accountTypeId;
@property (strong, nonatomic) ACAccount *account;
@property (copy, nonatomic) UserRegisterBlock userRegisterBlock;

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
            _accountTypeIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountType"];
            _account = [_accountStore accountWithIdentifier:_accountTypeIdentifier];
        }
    }
    return self;
}

- (BOOL)accountLogged
{
    return self.account != nil;
//    return NO;
}

- (ACAccountStore *)accountStore
{
    return _accountStore;
}

- (NSString *)userName
{
    if ([self.account.accountType.identifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
        NSString *accountDesc = self.account.accountDescription;
        return [accountDesc substringFromIndex:1];
    }
    
    NSString *username = [self.account valueForKeyPath:@"properties.ACPropertyFullName"];
    
    if (!username) {
        username = [self.account valueForKeyPath:@"properties.fullname"];
    }
    
    if (!username) {
        username = self.account.username;
    }
    
    return username;
}

- (void)requestForTwitterAccessWithComplition:(void (^)())successBlock fail:(void (^)())failureBlock
{
    ACAccountType *twitterType =
    [[[WTAccountManager sharedInstance] accountStore] accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accounts = [[[WTAccountManager sharedInstance] accountStore] accountsWithAccountType:twitterType];
    if ([accounts count] > 0) {
        successBlock();
    } else {
        [SVProgressHUD showWithStatus:@"アカウントに接続中" maskType:SVProgressHUDMaskTypeBlack];
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
            if (granted) {
                successBlock();
            } else {
                failureBlock();
            }
        }];
    }
}

- (void)requestForFacebookAccessWithComplition:(void (^)())successBlock fail:(void (^)())failureBlock
{
    ACAccountType *facebookType =
    [[[WTAccountManager sharedInstance] accountStore] accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSArray *accounts = [[[WTAccountManager sharedInstance] accountStore] accountsWithAccountType:facebookType];
    if ([accounts count] > 0) {
        successBlock();
    } else {
        [SVProgressHUD showWithStatus:@"アカウントに接続中" maskType:SVProgressHUDMaskTypeBlack];
        ACAccountType *facebookAccountType = [self.accountStore
                                              accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        NSDictionary *options = @{
                                  @"ACFacebookAppIdKey" : @"727920337234915",
                                  @"ACFacebookPermissionsKey" : @[@"email", @"user_about_me"],
                                  @"ACFacebookAudienceKey" : ACFacebookAudienceEveryone};
        
        [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error) {
            if (granted) {
                NSDictionary *options = @{
                                          @"ACFacebookAppIdKey" : @"727920337234915",
                                          @"ACFacebookPermissionsKey" : @[@"publish_stream", @"publish_actions"],
                                          @"ACFacebookAudienceKey" : ACFacebookAudienceEveryone};
                
                [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error) {
                    if (granted) {
                        successBlock();
                    } else {
                        failureBlock();
                    }
                }];
            } else {
                failureBlock();
            }
        }];
    }
}

- (void)getTwitterAccountInformationWithCompletion:(UserRegisterBlock)completion
{
    self.userRegisterBlock = completion;
    ACAccountType *twitterAccountType = [self.accountStore
                                         accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accountsArray = [self.accountStore accountsWithAccountType:twitterAccountType];
            if ([accountsArray count] > 0) {
                self.account = [accountsArray objectAtIndex:0];
                self.accountTypeIdentifier = self.account.identifier;
                self.accountTypeId = [self.account valueForKeyPath:@"properties.user_id"];
                [self getTwitterAccountDetail];
            } else {
                self.userRegisterBlock(NO);
            }
        } else {
            self.userRegisterBlock(NO);
        }
    }];
}

- (void)getFacebookAccountInformationWithCompletion:(UserRegisterBlock)completion
{
    self.userRegisterBlock = completion;
    ACAccountType *facebookAccountType = [self.accountStore
                                          accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{
                              @"ACFacebookAppIdKey" : @"727920337234915",
                              @"ACFacebookPermissionsKey" : @[@"email", @"user_about_me"],
                              @"ACFacebookAudienceKey" : ACFacebookAudienceEveryone};
    
    [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accountsArray = [self.accountStore accountsWithAccountType:facebookAccountType];
            
            if ([accountsArray count] > 0) {
                self.account = [accountsArray objectAtIndex:0];
                self.accountTypeIdentifier = self.account.identifier;
                self.accountTypeId = [self.account valueForKeyPath:@"properties.uid"];
                [self getFacebookAccountDetail];
            } else {
                self.userRegisterBlock(NO);
            }
        } else {
            self.userRegisterBlock(NO);
        }
    }];
}

- (void)getFacebookAccountDetail
{
    ACAccountType *facebookAccountType = [self.accountStore
                                          accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{
                              @"ACFacebookAppIdKey" : @"727920337234915",
                              @"ACFacebookPermissionsKey" : @[@"publish_stream", @"publish_actions"],
                              @"ACFacebookAudienceKey" : ACFacebookAudienceEveryone};
    
    [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            [self getProfileImage:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=128&height=128", [self.account valueForKeyPath:@"properties.uid"]]];
        } else {
            self.userRegisterBlock(NO);
        }
    }];
}

- (void)getTwitterAccountDetail
{
    SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:@{@"screen_name": [self userName]}];
    twitterInfoRequest.account = self.account;
    
    [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {

        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            self.userRegisterBlock(NO);
            return;
        }
        
        if (responseData) {
            NSDictionary *dict = [responseData objectFromJSONData];
            //默认头像太小，获取稍大图
            NSString *profileImageUrl = [dict objectForKey:@"profile_image_url"];
            if (!profileImageUrl) {
                self.userRegisterBlock(NO);
            } else {
                 [self getProfileImage:[profileImageUrl stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]];
            }
        }
    }];
    
}

- (void)getProfileImage:(NSString *)urlString
{
    AFImageRequestOperation* operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] imageProcessingBlock:nil
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
        {
            NSLog(@"response: %@", response);
            [self createNewUserWithUserName:[self userName] avatarImage:image progress:^(CGFloat progress) {
                ;
            } completion:^(BOOL success, NSError *error) {
                ;
            }];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            self.userRegisterBlock(NO);
        }];
    
    [operation start];
}

- (void)createNewUserWithUserName:(NSString *)username avatarImage:(UIImage *)image progress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock {
    
    NSString *accountType = @"";
    if ([self.account.accountType.identifier isEqualToString:ACAccountTypeIdentifierTwitter]) {
        accountType = @"Twitter";
    } else if ([self.account.accountType.identifier isEqualToString:ACAccountTypeIdentifierFacebook]){
        accountType = @"Facebook";
    }
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/users"];
    NSDictionary *params = @{
                             @"user[username]" : username,
                             @"user[user_type]" : accountType,
                             @"user[type_id]" : self.accountTypeId
                             };
    
    NSDictionary *imageDic = @{@"image": image,
                               @"name": @"user[avatar]",
                               @"filename": @"avatar.jpg",
                               @"mimetype": @"image/jpg"
                               };
    
    [WTHttpEngine startHttpConnectionWithImageDic:imageDic path:path method:@"POST" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        WTUser* user = [WTUser sharedInstance];
        [user initWithUserDic:[responseObject objectForKey:@"user"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.accountTypeIdentifier forKey:@"accountType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (self.userRegisterBlock) {
            self.userRegisterBlock(YES);
        }
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userRegisterBlock) {
            self.userRegisterBlock(NO);
        };
    }];
}

@end
