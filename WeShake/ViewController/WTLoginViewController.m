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

@end
