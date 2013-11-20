//
//  WTFBLoginViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-2.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTLoginViewController.h"
#import "WTAccountManager.h"
#import "SVProgressHUD.h"
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>

@interface WTLoginViewController()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation WTLoginViewController

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
    
    self.logoImageView.layer.cornerRadius = 20.f;
    self.logoImageView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginWithTwitter
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ご注意ください" message:@"このiPhoneは、Twitterアカウントが設定されていまん。iPhoneの設定にしてください。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"ログイン中" maskType:SVProgressHUDMaskTypeBlack];
    [[WTAccountManager sharedInstance] getTwitterAccountInformationWithCompletion:^(BOOL success) {
        if (success) {
            [SVProgressHUD dismiss];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"承認エラー"];
            });
        }
    }];
}

- (IBAction)loginWithFacebook
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ご注意ください" message:@"このiPhoneは、Facebookアカウントが設定されていまん。iPhoneの設定にしてください。" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"ログイン中" maskType:SVProgressHUDMaskTypeBlack];
    [[WTAccountManager sharedInstance] getFacebookAccountInformationWithCompletion:^(BOOL success) {
        if (success) {
            [SVProgressHUD dismiss];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"承認エラー"];
            });
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
