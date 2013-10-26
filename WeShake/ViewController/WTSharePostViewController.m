//
//  WTSharePostViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-25.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTSharePostViewController.h"
#import "WTHttpEngine.h"
#import "WTUser.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "WTAccountManager.h"
#import "WTLocationManager.h"
#import "WTShop.h"

@interface WTSharePostViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;
@property (weak, nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (weak, nonatomic) IBOutlet UITableView *shopTableView;

@property (strong, nonatomic) NSMutableArray *nearShops;
@end

@implementation WTSharePostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _nearShops = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.shareImageView setImage:self.shareImage];
    
    [self getNearShops];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retakeImage:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareImage:(id)sender {
    [self postWithMessage:@"This shop is excellent" photo:self.shareImage progress:^(CGFloat progress) {
        ;
    } completion:^(BOOL success, NSError *error) {
        ;
    }];
    
//    if (self.twitterSwitch.on) {
//        [self shareInTwitterWithImage:self.shareImage withStatus:@"Test"];
//    }
    
    if (self.facebookSwitch.on) {
        [self shareInFacebookWithImage:self.shareImage withStatus:@"Test"];
    }
}

- (void)postWithMessage:(NSString *)message photo:(UIImage *)image progress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/users/%d/posts", [[[WTUser sharedInstance] userId] integerValue]];
    NSDictionary *params = @{
                             @"post[message]" : message,
                             @"user_id"      : [[WTUser sharedInstance] userId],
                             @"auth_token"  : [[WTUser sharedInstance] authToken]
                             };
    
    NSDictionary *imageDic = @{@"image": image,
                               @"name": @"post[photo]",
                               @"filename": @"photo.jpg",
                               @"mimetype": @"image/jpg"
                               };
    
    [WTHttpEngine startHttpConnectionWithImageDic:imageDic path:path method:@"POST" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        [self dismissViewControllerAnimated:YES completion:nil];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)shareInFacebookWithImage:(UIImage *)image withStatus:(NSString *)status
{
    ACAccountType *facebookType =
    [[[WTAccountManager sharedInstance] accountStore] accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSLog(@"[SUCCESS!] Created Faebook");
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [[[WTAccountManager sharedInstance] accountStore] accountsWithAccountType:facebookType];
            ACAccount *account = [accounts lastObject];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/photos", [account valueForKeyPath:@"properties.uid"]]];
            NSDictionary *params = @{@"message": status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            [request addMultipartData:imageData
                             withName:@"picture"
                                 type:@"image/png"
                             filename:nil];
            [request setAccount:[accounts lastObject]];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    NSDictionary *options = @{
                              @"ACFacebookAppIdKey" : @"727920337234915",
                              @"ACFacebookPermissionsKey" : @[@"publish_stream", @"publish_actions"],
                              @"ACFacebookAudienceKey" : ACFacebookAudienceEveryone};
    [[[WTAccountManager sharedInstance] accountStore] requestAccessToAccountsWithType:facebookType
                                                                              options:options
                                                                           completion:accountStoreHandler];
}

- (void)shareInTwitterWithImage:(UIImage *)image withStatus:(NSString *)status
{
    ACAccountType *twitterType =
    [[[WTAccountManager sharedInstance] accountStore] accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [[[WTAccountManager sharedInstance] accountStore] accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            NSDictionary *params = @{@"status" : status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            [request addMultipartData:imageData
                             withName:@"media[]"
                                 type:@"image/jpeg"
                             filename:@"image.jpg"];
            [request setAccount:[accounts lastObject]];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [[[WTAccountManager sharedInstance] accountStore] requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
}

- (void)getNearShops
{
    NSString *path = [NSString stringWithFormat:@"/api/v1/shops"];
    
    NSDictionary *params = @{@"process": @"around",
                             @"latitude": @([[WTLocationManager sharedInstance] latitude]),
                             @"longitude": @([[WTLocationManager sharedInstance] longitude])
                             };
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"GET" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        [(NSArray *)[responseObject objectForKey:@"shops"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WTShop *shop = [MTLJSONAdapter modelOfClass:WTShop.class fromJSONDictionary:obj error:nil];
            shop.distance = [[WTLocationManager sharedInstance] getDistanceTo:CLLocationCoordinate2DMake(shop.latitude.doubleValue, shop.longitude.doubleValue)];
            [self.nearShops addObject:shop];
            [self.shopTableView reloadData];
        }];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nearShops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShopCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    WTShop *shop = self.nearShops[indexPath.row];
    cell.textLabel.text = shop.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (IBAction)facebookSwitchChanged:(id)sender {
    
}

- (IBAction)twitterSwitchChanged:(id)sender {
    
}

@end
