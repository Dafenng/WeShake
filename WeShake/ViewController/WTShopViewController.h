//
//  WTShopViewController.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-10.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTShop.h"
#import "RNGridMenu.h"

@interface WTShopViewController : UIViewController <RNGridMenuDelegate>

@property (strong, nonatomic) WTShop *shop;

@end
