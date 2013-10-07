//
//  WTLocationManager.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTLocationManager.h"

@interface WTLocationManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation WTLocationManager

+ (WTLocationManager *)sharedInstance
{
    static WTLocationManager *_sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _sharedInstance = [[WTLocationManager alloc] init];
        [_sharedInstance setupWithBaseSettings];
    });
    return _sharedInstance;
}

- (void)setupWithBaseSettings
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.delegate = self;
    
    self.currentCoordinate = CLLocationCoordinate2DMake(kBaseLatitude, kBaseLongitude);
    self.radius = kBaseRadius;
}

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
    [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:30.0];
}

- (void)stopUpdatingLocation:(NSString *)state {
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}

/**
 *  更新currentCoordinate到locationManager最新定位数据
 */
- (void)updateCurrentCoordinate
{
    self.currentCoordinate = self.locationManager.location.coordinate;
}

/**
 *  旧的currentLocation位置和新定位位置的差距
 *
 *  @return 两者距离
 */
- (int)getDistanceFromCurrentLocationToLocationManager
{
    return [self getDistanceFrom:self.currentCoordinate to:self.locationManager.location.coordinate];
}

- (int)getDistanceFrom:(CLLocationCoordinate2D)coordinate1  to:(CLLocationCoordinate2D)coordinate2 {
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:coordinate1.latitude longitude:coordinate1.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:coordinate2.latitude longitude:coordinate2.longitude];
    
    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
    
    return round(distance);
}


#pragma mark Location Manager Interactions

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    if (newLocation.horizontalAccuracy < 0) {
        return;
    }
    NSTimeInterval interval = -[newLocation.timestamp timeIntervalSinceNow];
    if (interval > 30) {
        return;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self.locationManager stopUpdatingLocation];
    }
}

@end
