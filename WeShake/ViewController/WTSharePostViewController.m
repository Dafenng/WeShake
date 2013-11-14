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
#import "WTLoadMoreCell.h"
#import "WTDataDef.h"
#import "SVProgressHUD.h"
#import "WTSharePostShopCell.h"

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
@property (assign, nonatomic) BOOL noMoreShops;
@property (assign, nonatomic) CGFloat ratingFloat;
@property (strong, nonatomic) WTShop *selectShop;
@property (weak, nonatomic) IBOutlet UILabel *selectShopLabel;

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
    self.shopTableView.allowsSelection = YES;
    
    [self setupStarRating];
//    [self getNearShops];
    
    self.mainContainerView.layer.cornerRadius = 10.f;
//    self.shareImageView.layer.cornerRadius = 5.f;
    
//    self.shareContainerView.layer.borderWidth = 0.4f;
//    self.shareContainerView.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.commentTextView.layer.borderWidth = 0.4f;
    self.commentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
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
    _starRating.backgroundColor  = [UIColor clearColor];
    _starRating.starImage = [UIImage imageNamed:@"grey_star.png"];
    _starRating.starHighlightedImage = [UIImage imageNamed:@"star.png"];
    _starRating.maxRating = 5.0;
    _starRating.delegate = self;
    _starRating.horizontalMargin = 5.0;
    _starRating.editable=YES;
    _starRating.rating= 0.0;
    _starRating.displayMode=EDStarRatingDisplayHalf;
    [_starRating  setNeedsDisplay];
    [self starsSelectionChanged:_starRating rating:2.5];
}
     
- (IBAction)shareImage:(id)sender {
    
    if (!self.selectShop) {
        [SVProgressHUD showErrorWithStatus:@"请选择商家"];
        return;
    }
    
    [self postWithMessage:[NSString stringWithFormat:@"%@  我这家叫 %@ 的店，我评分为 %.1f", self.commentTextView.text, self.selectShop.name, self.ratingFloat] photo:self.shareImage progress:^(CGFloat progress) {
        ;
    } completion:^(BOOL success, NSError *error) {
        ;
    }];
    
    if (self.twitterButton.selected) {
        [self shareInTwitterWithImage:self.shareImage withStatus:[NSString stringWithFormat:@"%@  我这家叫 %@ 的店，我评分为 %f", self.commentTextView.text, self.selectShop.name, self.ratingFloat]];
    }

    if (self.facebookButton.selected) {
        [self shareInFacebookWithImage:self.shareImage withStatus:[NSString stringWithFormat:@"%@  我这家叫 %@ 的店，我评分为 %f", self.commentTextView.text, self.selectShop.name, self.ratingFloat]];
    }
}

- (void)postWithMessage:(NSString *)message photo:(UIImage *)image progress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(BOOL success, NSError *error))completionBlock {
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/users/%ld/posts", (long)[[[WTUser sharedInstance] userId] integerValue]];
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
//        if (responseData) {
//            NSInteger statusCode = urlResponse.statusCode;
//            if (statusCode >= 200 && statusCode < 300) {
//                NSLog(@"[SUCCESS!] Created Faebook");
//            }
//            else {
//                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
//                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
//            }
//        }
//        else {
//            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
//        }
    };
    
    
    NSArray *accounts = [[[WTAccountManager sharedInstance] accountStore] accountsWithAccountType:facebookType];
    ACAccount *account = [accounts firstObject];
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
    [request setAccount:account];
    [request performRequestWithHandler:requestHandler];
}

- (void)shareInTwitterWithImage:(UIImage *)image withStatus:(NSString *)status
{
    ACAccountType *twitterType =
    [[[WTAccountManager sharedInstance] accountStore] accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//        if (responseData) {
//            NSInteger statusCode = urlResponse.statusCode;
//            if (statusCode >= 200 && statusCode < 300) {
//                NSDictionary *postResponseData =
//                [NSJSONSerialization JSONObjectWithData:responseData
//                                                options:NSJSONReadingMutableContainers
//                                                  error:NULL];
//                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
//            }
//            else {
//                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
//                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
//            }
//        }
//        else {
//            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
//        }
    };
    
    
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
    [request setAccount:[accounts firstObject]];
    [request performRequestWithHandler:requestHandler];

}

- (void)getNearShops
{
    NSString *path = [NSString stringWithFormat:@"/api/v1/shops"];
    
    NSDictionary *params = @{@"process": @"around",
                             @"latitude": @([[WTLocationManager sharedInstance] latitude]),
                             @"longitude": @([[WTLocationManager sharedInstance] longitude]),
                             @"start": @([self.nearShops count]),
                             @"count": @(CountPerRequest)
                             };
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"GET" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *shops = [NSMutableArray array];
        [(NSArray *)[responseObject objectForKey:@"shops"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WTShop *shop = [MTLJSONAdapter modelOfClass:WTShop.class fromJSONDictionary:obj error:nil];
            shop.distance = [[WTLocationManager sharedInstance] getDistanceTo:CLLocationCoordinate2DMake(shop.latitude.doubleValue, shop.longitude.doubleValue)];
            
            
            [shops addObject:shop];
        }];
        
        if ([shops count] == 0) {
            //刚好加载完所有
            self.noMoreShops = YES;
            [self.shopTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.nearShops count] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            if ([shops count] < CountPerRequest) {
                self.noMoreShops = YES;
            }
            if ([self.nearShops count] == 0) {
                [self.nearShops addObjectsFromArray:shops];
                [self.shopTableView reloadData];
            } else {
                [self.nearShops addObjectsFromArray:shops];
                NSMutableArray *insertIndexPaths = [NSMutableArray array];
                for (NSInteger i = [self.nearShops count] - [shops count]; i < [self.nearShops count]; i++) {
                    [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                
                [self.shopTableView beginUpdates];
                [self.shopTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                [self.shopTableView endUpdates];
            }
        }

    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showNetworkError];
    }];
}

- (void)showNetworkError
{
    [SVProgressHUD showErrorWithStatus:@"网络出错了"];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nearShops count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SharePostShopCell";
    static NSString *LoadMoreIdentifier = @"LoadMoreCell";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == [self.nearShops count]) {
        cell = (WTLoadMoreCell *)[tableView dequeueReusableCellWithIdentifier:LoadMoreIdentifier];
        if (cell == nil) {
            cell = [WTLoadMoreCell loadMoreCellFromNib];
        }
        
        if (self.noMoreShops) {
            ((WTLoadMoreCell *)cell).indicator.hidden = YES;
            [((WTLoadMoreCell *)cell).indicator stopAnimating];
            ((WTLoadMoreCell *)cell).status.text = @"No More";
        } else {
            ((WTLoadMoreCell *)cell).indicator.hidden = NO;
            [((WTLoadMoreCell *)cell).indicator startAnimating];
            ((WTLoadMoreCell *)cell).status.text = @"Loading";
            [self getNearShops];
        }
    } else {
        cell = (WTSharePostShopCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[WTSharePostShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        WTShop *shop = self.nearShops[indexPath.row];
        ((WTSharePostShopCell *)cell).shopNameLabel.text = shop.name;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectShop = [self.nearShops objectAtIndex:indexPath.row];
    self.selectShopLabel.text = self.selectShop.name;
}

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    self.ratingFloat = rating;
}

- (IBAction)handleTap:(id)sender {
    [self.commentTextView resignFirstResponder];
}

- (IBAction)facebookButtonClicked:(id)sender {
    if (!self.facebookButton.selected) {
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机未关联Facebook账户，请前往设置关联" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        [[WTAccountManager sharedInstance] requestForFacebookAccessWithComplition:^{
            [SVProgressHUD dismiss];
            self.facebookButton.selected = YES;
        } fail:^{
            [SVProgressHUD showErrorWithStatus:@"授权失败"];
            self.facebookButton.selected = NO;
        }];
    } else {
        self.facebookButton.selected = NO;
    }
}

- (IBAction)twitterButtonClicked:(id)sender {
    if (!self.twitterButton.selected) {
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机未关联Twitter账户，请前往设置关联" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        [[WTAccountManager sharedInstance] requestForTwitterAccessWithComplition:^{
            [SVProgressHUD dismiss];
            self.twitterButton.selected = YES;
        } fail:^{
            [SVProgressHUD showErrorWithStatus:@"授权失败"];
            self.twitterButton.selected = NO;
        }];
    } else {
        self.twitterButton.selected = NO;
    }
}

@end
