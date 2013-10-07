//
//  WTFBLoginViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-2.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTLoginViewController.h"
#import "WTAccountManager.h"

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
    [[WTAccountManager sharedInstance] getTwitterAccountInformationWithCompletion:^(BOOL success) {
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)loginWithFacebook
{
    [[WTAccountManager sharedInstance] getFacebookAccountInformationWithCompletion:^(BOOL success) {
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end
