//
//  WTCustomNavigationController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-11-10.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTCustomNavigationController.h"

@interface WTCustomNavigationController ()

@end

@implementation WTCustomNavigationController

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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
