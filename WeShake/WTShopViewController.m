//
//  WTShopViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-10.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShopViewController.h"
#import "WTToastView.h"

@interface WTShopViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *frontImageView;


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
    
    NSDictionary *shopImageDict = @{@"居酒屋": @"shop_izakaya.png",
                                    @"焼肉・韓国料理": @"shop_korean.png",
                                    @"イタリアン・フレンチ": @"shop_italian.png",
                                    @"中華": @"shop_chinese.png",
                                    @"バー・カクテル": @"shop_bar.png",
                                    @"カラオケ・パーティ": @"shop_karaok.png",
                                    @"ダイニングバー": @"shop_dinnerbar.png"};
    self.shop.imageStr = shopImageDict[self.shop.shopType];
    self.frontImageView.image = [UIImage imageNamed:self.shop.imageStr];
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
    [self showMapByLatitude:self.shop.latitude longitude:self.shop.longitude];
}

- (IBAction)favorButtonClicked:(id)sender {
    
    WTToastView *toastView = [[WTToastView alloc]
                              initWithMessage:@"Sorry, no restaurant found near you in 1 km"
                              title:nil
                              image:nil];
    toastView.center = self.view.center;
    toastView.alpha = .0;
    [self.view addSubview:toastView];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toastView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:CSToastFadeDuration
                                               delay:CSToastFadeDuration
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toastView.alpha = .0;
                                          } completion:^(BOOL finished) {
                                              [toastView removeFromSuperview];
                                          }];
                     }];

}
@end
