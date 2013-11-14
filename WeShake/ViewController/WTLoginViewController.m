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

@interface WTLoginViewController()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginWithTwitter
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机未关联Twitter账户，请前往设置关联" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Logging" maskType:SVProgressHUDMaskTypeBlack];
    [[WTAccountManager sharedInstance] getTwitterAccountInformationWithCompletion:^(BOOL success) {
        if (success) {
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"Auth Error"];
            });
        }
    }];
}

- (IBAction)loginWithFacebook
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机未关联Facebook账户，请前往设置关联" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Logging" maskType:SVProgressHUDMaskTypeBlack];
    [[WTAccountManager sharedInstance] getFacebookAccountInformationWithCompletion:^(BOOL success) {
        if (success) {
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"Auth Error"];
            });
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
