//
//  WTViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-8.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTMainViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WTLocationManager.h"
#import "WTShopManager.h"
#import "WTToastView.h"
#import "WTShopViewController.h"
#import <objc/runtime.h>
#import "WTAccountManager.h"

@interface WTMainViewController () {
    
}

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (weak, nonatomic) IBOutlet UIButton *shakeButton;

@end

@implementation WTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[WTLocationManager sharedInstance] startUpdatingLocation];
    if (![[WTAccountManager sharedInstance] accountLogged]) {
        [self performSegueWithIdentifier:@"MainToUserLogin" sender:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shake:(id)sender {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    //模拟时暂时关闭
    //    int distance = [[WTLocationManager sharedInstance] getDistanceFromCurrentLocationToLocationManager];
    //    if (distance > 50) {
    //        [[WTShopManager sharedInstance] setShouldActivateHTTPRequest:YES];
    //    }
    //    [[WTLocationManager sharedInstance] updateCurrentCoordinate];
    [[WTShopManager sharedInstance] setShouldActivateHTTPRequest:YES];
    [self getShopInfo];
}

- (void)setUpSubviews
{
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.center = self.view.center;
    [self.view addSubview:self.indicatorView];
}

- (void)showShopInfo:(WTShop *)shop
{
    WTToastView *toastView = [WTToastView toastviewFromNib];
    [toastView setupWithMessage:[NSString stringWithFormat:@"Distance: %dm", shop.distance] title:shop.name image:[UIImage imageNamed:@"shop_toast_image.png"]];
    
    //TODO:需要调整边界情况
    toastView.frame = CGRectMake(0, 0, 280, 100);
    toastView.center = self.view.center;
    toastView.alpha= .0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectShop:)];
    objc_setAssociatedObject(tapGesture, "shop", shop, OBJC_ASSOCIATION_RETAIN);
    
    [toastView addGestureRecognizer:tapGesture];
    [self.view addSubview:toastView];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toastView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)showNoShop
{
    
    
}

- (void)selectShop:(UITapGestureRecognizer *)tapGesture
{
    UIView *toast = tapGesture.view;
    if ([toast isKindOfClass:[WTToastView class]]) {
        [toast removeFromSuperview];
    }
    
    WTShop *shop = objc_getAssociatedObject(tapGesture, "shop");
    [self performSegueWithIdentifier:@"MainViewToShopView" sender:shop];
}

- (void)getShopInfo
{
    [self.indicatorView startAnimating];
    [[WTShopManager sharedInstance] getOneSuggestShopWithSuccess:^(WTShop *shop) {
        [self.indicatorView stopAnimating];
        [self showShopInfo:shop];
    } failure:^{
        [self.indicatorView stopAnimating];
        [self showNoShop];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MainViewToShopView"]) {
        [[segue destinationViewController] setShop:sender];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {
        [self getShopInfo];
    }
}

- (IBAction)search:(id)sender {
    [self performSegueWithIdentifier:@"MainViewToSearchView" sender:sender];
}

- (IBAction)capture:(id)sender {
    
    [self performSegueWithIdentifier:@"MainToCapture" sender:sender];
}

@end
