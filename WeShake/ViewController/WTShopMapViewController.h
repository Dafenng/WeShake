//
//  WTShopMapViewController.h
//  WeShake
//
//  Created by Dafeng Jin on 13-11-1.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WTShop.h"

@interface WTShopMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) WTShop *shop;

@end
