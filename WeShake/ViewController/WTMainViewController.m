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
#import "SVProgressHUD.h"

@interface WTMainViewController () {
    
}

@property (weak, nonatomic) IBOutlet UIButton *shakeButton;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;

@end

@implementation WTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRegion:) name:Region_Update_Notification object:nil];
    self.regionLabel.text =  [[NSUserDefaults standardUserDefaults] valueForKey:@"regionAndCity"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setupShakeAnimation];
    [[WTLocationManager sharedInstance] startUpdatingLocation];
    if (![[WTAccountManager sharedInstance] accountLogged]) {
        [self performSegueWithIdentifier:@"MainToUserLogin" sender:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Region_Update_Notification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupShakeAnimation
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [anim setToValue:[NSNumber numberWithFloat:0.0f]];
    [anim setFromValue:[NSNumber numberWithDouble:M_PI/16]];
    [anim setDuration:0.15];
    [anim setRepeatCount:NSUIntegerMax];
    [anim setAutoreverses:YES];
    
    [self.shakeButton.layer addAnimation:anim forKey:@"iconShake"];
}

- (IBAction)shake:(id)sender {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    //模拟时暂时关闭
//    int distance = [[WTLocationManager sharedInstance] getDistanceFromCurrentLocationToLocationManager];
//    [[WTLocationManager sharedInstance] updateCurrentCoordinate];
    [self getSuggestShop];
    
//    [[WTLocationManager sharedInstance] startUpdatingLocation];
}

- (void)showShopInfo:(WTShop *)shop
{
    WTToastView *toastView = [WTToastView toastviewFromNib];
    [toastView setupWithShop:shop];
    
    //TODO:需要调整边界情况
    toastView.frame = CGRectMake(0, 0, 280, 100);
    toastView.center = self.view.center;
    toastView.alpha= .0;
    toastView.tag = 10000;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectShop:)];
    objc_setAssociatedObject(tapGesture, "shop", shop, OBJC_ASSOCIATION_RETAIN);
    [toastView addGestureRecognizer:tapGesture];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.6f;
    alphaView.tag = 10001;
    UITapGestureRecognizer *alphaTagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissToastView:)];
    [alphaView addGestureRecognizer:alphaTagGesture];
    
    [self.view addSubview:alphaView];
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

- (void)showNetworkError
{
    
}

- (void)dismissToastView:(UITapGestureRecognizer *)tapGesture
{
    UIView *toast = [self.view viewWithTag:10000];
    if (toast) {
        [toast removeFromSuperview];
    }
    
    UIView *alphaView = [self.view viewWithTag:10001];
    if (alphaView) {
        [alphaView removeFromSuperview];
    }
}

- (void)selectShop:(UITapGestureRecognizer *)tapGesture
{
    UIView *toast = [self.view viewWithTag:10000];
    if (toast) {
        [toast removeFromSuperview];
    }
    
    UIView *alphaView = [self.view viewWithTag:10001];
    if (alphaView) {
        [alphaView removeFromSuperview];
    }
    
    WTShop *shop = objc_getAssociatedObject(tapGesture, "shop");
    [self performSegueWithIdentifier:@"MainViewToShopView" sender:shop];
}

- (void)getSuggestShop
{
    [self dismissToastView:nil];
    [SVProgressHUD showWithStatus:@"Searching" maskType:SVProgressHUDMaskTypeBlack];
    [[WTShopManager sharedInstance] getSuggestShopWithSuccess:^(WTShop *shop) {
        [SVProgressHUD dismiss];
        [self showShopInfo:shop];
    } failure:^(ErrorType errorCode) {
        [SVProgressHUD dismiss];;
        
        switch (errorCode) {
            case ZeroCountError:
                if ([[WTLocationManager sharedInstance] increaseRadius]) {
                    [self getSuggestShop];
                } else {
                    [self showNoShop];
                }
                break;
            case TotalUsedError:
                if ([[WTLocationManager sharedInstance] increaseRadius]) {
                    [self getSuggestShop];
                } else {
                    [self showNoShop];
                }
                break;
            case PreSameError:
                [self getSuggestShop];
                break;
            case NetworkError:
                [self showNetworkError];
                break;
            default:
                break;
        }
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
        [self shake:nil];
    }
}

- (IBAction)search:(id)sender {
    [self performSegueWithIdentifier:@"MainViewToSearchView" sender:sender];
}

- (IBAction)capture:(id)sender {
    
    [self performSegueWithIdentifier:@"MainToCapture" sender:sender];
}

- (IBAction)profile:(id)sender {
    [self performSegueWithIdentifier:@"MainToAboutMe" sender:sender];
}

- (IBAction)setting:(id)sender {
    [self performSegueWithIdentifier:@"MainToSetting" sender:sender];
}

#pragma mark - Notification

- (void)updateRegion:(NSNotification *)aNotification
{
    self.regionLabel.text = aNotification.object;
}

@end
