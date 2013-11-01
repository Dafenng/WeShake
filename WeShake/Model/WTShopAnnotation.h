//
//  WTShopAnnotation.h
//  WeShake
//
//  Created by Dafeng Jin on 13-11-1.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShop.h"
#import <MapKit/MapKit.h>

@interface WTShopAnnotation : WTShop <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly, copy) NSString *title;

- (id)initWithShop:(WTShop *)shop;

@end
