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

@interface WTShopViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *shopPhotoScrollView;



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
    
    self.nameLabel.text = [self.shop name];
    self.addrLabel.text = [self.shop addr];
    self.priceLabel.text = [self.shop budget];
    
    NSInteger shopPhotoCount = [self.shop.shopPhotos count];
    if (shopPhotoCount > 0) {
        self.shopPhotoScrollView.contentSize = CGSizeMake(shopPhotoCount * 300, 1);
        for (NSInteger i = 0; i < shopPhotoCount; i++) {
            WTShopPhoto *shopPhoto = self.shop.shopPhotos[i];
            UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 300, 0, self.shopPhotoScrollView.frame.size.width, self.shopPhotoScrollView.frame.size.height)];
            [photoImageView setImageWithURL:[NSURL URLWithString:shopPhoto.photoUrl] placeholderImage:[UIImage imageNamed:@"shop_no_photo.png"]];
            [self.shopPhotoScrollView addSubview:photoImageView];
        }
    } else {
        self.shopPhotoScrollView.contentSize = CGSizeMake(300, 1);
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:self.shopPhotoScrollView.bounds];
        photoImageView.image = [UIImage imageNamed:@"shop_no_photo.png"];
        [self.shopPhotoScrollView addSubview:photoImageView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makePhoneCall:(NSString *)tel {
    NSMutableString *telString = [[NSMutableString alloc] init];
    [telString appendString:@"tel://"];
    [telString appendString:tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

- (void)showMapByLatitude:(double)latitude longitude:(double)longitude {
    // check if google map (first choice) is installed.
    NSString *urlPrefix = nil;
    BOOL canHandle = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.google.com"]];
    if (canHandle) {
        urlPrefix = @"http://maps.google.com/maps?q=@%@";
    }
    else {
        urlPrefix = @"maps.apple.com/maps?ll=%@";
    }
    
    NSMutableString *latlong = [[NSMutableString alloc] init];
    [latlong appendString:[NSString stringWithFormat:@"%f", latitude]];
    [latlong appendString:@","];
    [latlong appendString:[NSString stringWithFormat:@"%f", longitude]];
    NSString *url = [NSString stringWithFormat:urlPrefix, [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"url %@", url);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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
    [self showMapByLatitude:self.shop.latitude.doubleValue longitude:self.shop.longitude.doubleValue];
}

- (IBAction)favorButtonClicked:(id)sender {
    
    
}
@end
