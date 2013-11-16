//
//  WTLocationManager.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kBaseRegion @"東京都"
#define kBaseCity @"新宿"
#define kBaseLatitude 35.690415
#define kBaseLongitude 139.700211
#define kBaseRadius 0.5
#define kBaseRadiusStep 0.5
#define kBaseRadiusMax 4.0

@interface WTLocationManager : NSObject <CLLocationManagerDelegate>

@property (copy, nonatomic) NSString *region;
@property (copy, nonatomic) NSString *gpsRegion;

+ (WTLocationManager *)sharedInstance;

- (double)latitude;
- (double)longitude;
- (double)radius;
- (CLLocationCoordinate2D)coordinate;
- (BOOL)increaseRadius;

- (void)setupWithBaseSettings;
- (void)startUpdatingLocation;
- (void)updateCurrentCoordinate;
- (int)getDistanceFromCurrentLocationToLocationManager;
- (int)getDistanceTo:(CLLocationCoordinate2D)coordinate;
- (int)getDistanceFrom:(CLLocationCoordinate2D)coordinate1  to:(CLLocationCoordinate2D)coordinate2;

- (void)saveLocation;
- (void)updateRegion:(NSString *)aRegion;
- (BOOL)regionIsGPSRegion;
@end
