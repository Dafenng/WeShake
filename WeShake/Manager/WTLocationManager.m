//
//  WTLocationManager.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTLocationManager.h"
#import <MapKit/MapKit.h>
#import "WTDataDef.h"

@interface WTLocationManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) CLLocationCoordinate2D currentCoordinate;
@property (assign, nonatomic) double radius;

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

- (double)latitude
{
    return _currentCoordinate.latitude;
}

- (double)longitude
{
    return _currentCoordinate.longitude;
}

- (double)radius
{
    return _radius;
}

- (CLLocationCoordinate2D)coordinate
{
    return _currentCoordinate;
}

- (void)setupWithBaseSettings
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.delegate = self;
    
    self.currentCoordinate = CLLocationCoordinate2DMake(kBaseLatitude, kBaseLongitude);
    self.radius = kBaseRadius;
}

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation:(NSString *)state {
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}

- (BOOL)increaseRadius
{
    if ([[WTLocationManager sharedInstance] radius] > 4.0) {
        return NO;
    }
    
    [[WTLocationManager sharedInstance] increaseRadius];
    return YES;

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

- (int)getDistanceTo:(CLLocationCoordinate2D)coordinate
{
    return [self getDistanceFrom:self.currentCoordinate to:coordinate];
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
    [self updateCurrentCoordinate];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSString *region = [placemark administrativeArea];
            NSString *city = [placemark locality];
            if (region && ![region isEqualToString:@""]) {
                NSLog(@"%@", region);
                [[NSUserDefaults standardUserDefaults] setObject:region forKey:@"region"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:region forKey:@"regionAndCity"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:Region_Update_Notification object:[NSString stringWithFormat:@"%@%@", region, city]];
                [self.locationManager stopUpdatingLocation];
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] != kCLErrorLocationUnknown) {
        [self.locationManager stopUpdatingLocation];
    }
}

@end
