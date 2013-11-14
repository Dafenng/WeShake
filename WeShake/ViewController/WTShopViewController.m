//
//  WTShopViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-10.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShopViewController.h"
#import "WTToastView.h"
#import "UIImageView+AFNetworking.h"
#import "WTShopInfoView.h"
#import <QuartzCore/QuartzCore.h>
#import "WTHttpEngine.h"
#import "WTUser.h"

#define PhotoContainerScrollViewTag 2000

@interface WTShopViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *shopPhotoContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *shopPhotoScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) WTShopInfoView *shopInfoView;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;

@end

@implementation WTShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self getShopPhotos];
    [self setupInfoView];
    [self checkFavorStatus];
    
    self.shopPhotoScrollView.layer.cornerRadius = 5.f;
    self.shopPhotoContainerView.layer.cornerRadius = 10.f;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGSize size = self.mainScrollView.frame.size;
    size.height = self.shopInfoView.frame.origin.y + self.shopInfoView.frame.size.height + 10.f;
    [self.mainScrollView setContentSize:size];
}

- (void)setupPhotoView
{
    __block NSMutableArray *photoArray = [NSMutableArray array];
    [self.shop.shopPhotos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[(WTShopPhoto *)obj sizeType] isEqualToString:@"rect"]) {
            [photoArray addObject:obj];
        }
    }];
    
    NSInteger shopPhotoCount = [photoArray count];
    
    self.pageControl.numberOfPages = shopPhotoCount;
    self.pageControl.currentPage = 0;
    
    if (shopPhotoCount > 0) {
        
        self.shopPhotoScrollView.contentSize = CGSizeMake(shopPhotoCount * self.shopPhotoScrollView.frame.size.width, 1);
        for (NSInteger i = 0; i < shopPhotoCount; i++) {
            WTShopPhoto *shopPhoto = photoArray[i];
            UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.shopPhotoScrollView.frame.size.width, 0, self.shopPhotoScrollView.frame.size.width, self.shopPhotoScrollView.frame.size.height)];
            photoImageView.contentMode = UIViewContentModeScaleAspectFill;
            photoImageView.clipsToBounds = YES;
            [photoImageView setImageWithURL:[NSURL URLWithString:shopPhoto.photoUrl] placeholderImage:[UIImage imageNamed:@"default_shop_pic.png"]];
            [self.shopPhotoScrollView addSubview:photoImageView];
            
            if (shopPhoto.desc) {
                UIView *descView = [[UIView alloc] initWithFrame:CGRectMake(i * self.shopPhotoScrollView.frame.size.width, self.shopPhotoScrollView.frame.size.height - 30, self.shopPhotoScrollView.frame.size.width, 30)];
                descView.backgroundColor = [UIColor blackColor];
                descView.alpha = 0.5f;
                UILabel *descLabel = [[UILabel alloc] initWithFrame:descView.bounds];
                descLabel.font = [UIFont systemFontOfSize:14];
                descLabel.textColor = [UIColor whiteColor];
                descLabel.text = [NSString stringWithFormat:@"  %@", shopPhoto.desc];
                [descView addSubview:descLabel];
                [self.shopPhotoScrollView addSubview:descView];
            }
        }
    } else {
        self.shopPhotoScrollView.contentSize = CGSizeMake(self.shopPhotoScrollView.frame.size.width, 1);
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:self.shopPhotoScrollView.bounds];
        photoImageView.image = [UIImage imageNamed:@"default_shop_pic.png"];
        [self.shopPhotoScrollView addSubview:photoImageView];
    }
}

- (void)setupInfoView
{
    self.shopInfoView = [[WTShopInfoView alloc] init];
    [self.shopInfoView setupInfoViewWithShop:self.shop];
    self.shopInfoView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.shopInfoView];
    self.shopInfoView.layer.cornerRadius = 10.f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkFavorStatus
{
    NSString *path = [NSString stringWithFormat:@"/api/v1/favors"];
    NSDictionary *params = @{
                             @"favor[user_id]" : [[WTUser sharedInstance] userId],
                             @"favor[shop_id]" : self.shop.shopId
                             };
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"GET" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if ([[responseObject valueForKeyPath:@"result.status"] isEqualToString:@"existent"]) {
            self.favorButton.selected = YES;
        } else {
            self.favorButton.selected = NO;
        }
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fav检查失败");
    }];
}

- (void)getShopPhotos
{
    NSString *path = [NSString stringWithFormat:@"/api/v1/shop_photos"];
    NSDictionary *params = @{
                             @"shop_id" : self.shop.shopId
                             };
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"GET" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        [self.shop.shopPhotos removeAllObjects];
        [(NSArray *)[responseObject objectForKey:@"shop_photos"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WTShopPhoto *shopPhoto = [MTLJSONAdapter modelOfClass:WTShopPhoto.class fromJSONDictionary:obj error:nil];
            [self.shop.shopPhotos addObject:shopPhoto];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupPhotoView];
        });
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get shopPhotos 失败");
    }];
}

- (void)makePhoneCall:(NSString *)tel {
    NSMutableString *telString = [[NSMutableString alloc] init];
    [telString appendString:@"tel://"];
    [telString appendString:tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

- (IBAction)callButtonClicked:(id)sender {
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"yes"] title:@"Yes" action:^{
                           [self makePhoneCall:self.shop.tel];
                       }],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"no"] title:@"Cancel"],
                       ];
    NSInteger numberOfOptions = items.count;
    
    RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    gridMenu.delegate = self;
    [gridMenu showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (IBAction)locatButtonClicked:(id)sender {
//    [self showMapByLatitude:self.shop.latitude.doubleValue longitude:self.shop.longitude.doubleValue];
    
    [self performSegueWithIdentifier:@"ShopViewToMapView" sender:sender];
}

- (IBAction)favorButtonClicked:(id)sender {
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/favors"];
    NSDictionary *params = @{
                             @"favor[user_id]" : [[WTUser sharedInstance] userId],
                             @"favor[shop_id]" : self.shop.shopId,
                             };
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"POST" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if ([[responseObject valueForKeyPath:@"result.status"] isEqualToString:@"destroyed"]) {
            self.favorButton.selected = NO;
        } else {
            self.favorButton.selected = YES;
        }
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"用户注册失败");
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShopViewToMapView"]) {
        [[segue destinationViewController] setShop:self.shop];
    }
}

#pragma mark scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == PhotoContainerScrollViewTag) {
        self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}
@end
