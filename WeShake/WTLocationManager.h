//
//  WTLocationManager.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kBaseState @"東京都"
#define kBaseCity @"新宿"
#define kBaseLatitude 35.690415
#define kBaseLongitude 139.700211
#define kBaseRadius 0.5
#define kBaseRadiusStep 0.5
#define kBaseRadiusMax 1.0

@interface WTLocationManager : NSObject <CLLocationManagerDelegate>

@property (assign, nonatomic) CLLocationCoordinate2D currentCoordinate;
@property (assign, nonatomic) double radius;

+ (WTLocationManager *)sharedInstance;
- (void)setupWithBaseSettings;
- (void)startUpdatingLocation;
- (void)updateCurrentCoordinate;
- (int)getDistanceFromCurrentLocationToLocationManager;
- (int)getDistanceFrom:(CLLocationCoordinate2D)coordinate1  to:(CLLocationCoordinate2D)coordinate2;
@end
