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
#import <QuartzCore/QuartzCore.h>
#import "WTPlaceHolderTextView.h"

@interface WTSharePostViewController ()


@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;
@property (weak, nonatomic) IBOutlet UITableView *shopTableView;
@property (weak, nonatomic) IBOutlet EDStarRating *starRating;

@property (weak, nonatomic) IBOutlet UIView *shareContainerView;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet WTPlaceHolderTextView *commentTextView;

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
    
    [self setupStarRating];
    [self getNearShops];
    
    self.mainContainerView.layer.cornerRadius = 10.f;
    self.shareImageView.layer.cornerRadius = 5.f;
    
    self.shareContainerView.layer.borderWidth = 0.4f;
    self.shareContainerView.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.commentTextView.layer.borderWidth = 0.4f;
    self.commentTextView.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)setupStarRating
{
    _starRating.backgroundColor  = [UIColor colorWithWhite:0.9 alpha:1.0];
    _starRating.starImage = [UIImage imageNamed:@"grey_star.png"];
    _starRating.starHighlightedImage = [UIImage imageNamed:@"star.png"];
    _starRating.maxRating = 5.0;
    _starRating.delegate = self;
    _starRating.horizontalMargin = 15.0;
    _starRating.editable=YES;
    _starRating.rating= 2.5;
    _starRating.displayMode=EDStarRatingDisplayHalf;
    [_starRating  setNeedsDisplay];
    [self starsSelectionChanged:_starRating rating:2.5];
}
     
- (IBAction)shareImage:(id)sender {
    [self postWithMessage:@"This shop is excellent" photo:self.shareImage progress:^(CGFloat progress) {
        ;
    } completion:^(BOOL success, NSError *error) {
        ;
    }];
    
//    if (self.twitterButton.selected) {
//        [self shareInTwitterWithImage:self.shareImage withStatus:@"Test"];
//    }
//    
//    if (self.facebookButton.selected) {
//        [self shareInFacebookWithImage:self.shareImage withStatus:@"Test"];
//    }
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
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    NSString *ratingString = [NSString stringWithFormat:@"Rating: %.1f", rating];
    NSLog(@"%@", ratingString);
}

- (IBAction)handleTap:(id)sender {
    [self.commentTextView resignFirstResponder];
}

@end
