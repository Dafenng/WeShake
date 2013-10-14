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
#import "AFNetworking.h"
#import "JSONKit.h"
#import "WTUser.h"
#import "WTHttpEngine.h"
#import "WTDataDef.h"

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
//    [self getTwitterAccountDetail];
    return self.account != nil;
}

- (NSString *)userName
{
    if ([self.account.accountType.identifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
        return [self.account valueForKeyPath:@"properties.fullname"];
    }
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
                              @"ACFacebookPermissionsKey" : @[@"email", @"user_about_me"],
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

- (void)getFacebookAccountDetail
{
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=128&height=128", [self.account valueForKeyPath:@"properties.uid"]]] parameters:@{@"width": [NSNumber numberWithInt:128], @"height": [NSNumber numberWithInt:128]} ];
    
    request.account = self.account;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        if (responseData) {
            [self createNewUserWithUserName:[self userName] avatarImage:[UIImage imageWithData:responseData] progress:^(CGFloat progress) {
                ;
            } completion:^(BOOL success, NSError *error) {
                ;
            }];
        }
    }];
}

- (void)getTwitterAccountDetail
{
    SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:@{@"screen_name": self.account.username}];
    twitterInfoRequest.account = self.account;
    
    [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {

        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        
        if (responseData) {
            NSDictionary *dict = [responseData objectFromJSONData];
            //默认头像太小，获取稍大图
            NSString *profileImageUrl = [dict objectForKey:@"profile_image_url"];
            [self getProfileImage:[NSString stringWithFormat:@"%@%@", [profileImageUrl substringToIndex:[profileImageUrl length] - 10], @"bigger.png"]];
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

        }];
    
    [operation start];
}

- (void)createNewUserWithUserName:(NSString *)username avatarImage:(UIImage *)image progress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/users"];
    NSDictionary *params = @{
                             @"user[username]" : username
                             };
    
    NSDictionary *imageDic = @{@"image": image,
                               @"name": @"user[avatar]",
                               @"filename": @"avatar.jpg",
                               @"mimetype": @"image/jpg"
                               };
    
    [WTHttpEngine startHttpConnectionWithImageDic:imageDic path:path method:@"POST" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Created, %@", responseObject);
        WTUser* user = [WTUser sharedInstance];
        [user initWithUserDic:responseObject];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"用户注册失败");
    }];
}

@end
