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
@property (strong, nonatomic) NSMutableArray *regions;

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

- (void)updateRegion:(NSString *)aRegion
{
    self.region = aRegion;
}

- (BOOL)regionIsGPSRegion
{
    return [self.region isEqualToString:self.gpsRegion];
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
    
    [self recoverLocation];
    self.radius = kBaseRadius;
    
    NSArray *regionsPlist = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"region_area.plist" ofType:nil]];
    __block NSMutableArray *areasArr;
    [regionsPlist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [areasArr addObject:[obj objectForKey:@"Prefecture"]];
    }];
    
    self.regions = [NSMutableArray array];
    [self.regions addObjectsFromArray:areasArr];
}

- (BOOL)regionExist:(NSString *)region
{
    __block BOOL exist = NO;
    [self.regions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:region]) {
            exist = YES;
            *stop = YES;
        }
    }];
    
    return exist;
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
    if ([[WTLocationManager sharedInstance] radius] > kBaseRadiusMax) {
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
    
#ifdef REAL_LOCATION
    [self updateCurrentCoordinate];
#endif
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
#ifdef REAL_LOCATION
            self.gpsRegion = [placemark administrativeArea];
#else
            self.gpsRegion = @"東京都";
#endif
            if ([self regionExist:self.gpsRegion]) {
                self.region = self.gpsRegion;
                [self saveLocation];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:Region_Update_Notification object:self.gpsRegion];
            [self.locationManager stopUpdatingLocation];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] != kCLErrorLocationUnknown) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)recoverLocation
{
    NSString *aRegion = [[NSUserDefaults standardUserDefaults] valueForKey:@"region"];
    self.region = aRegion ? aRegion : kBaseRegion;
    
    double aLatitude = [(NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"] doubleValue];
    double aLongitude = [(NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"] doubleValue];
    if (aLatitude && aLongitude) {
        self.currentCoordinate = CLLocationCoordinate2DMake(aLatitude, aLongitude);
    } else {
        self.currentCoordinate = CLLocationCoordinate2DMake(kBaseLatitude, kBaseLongitude);
    }
}

- (void)saveLocation
{
    [[NSUserDefaults standardUserDefaults] setObject:self.region forKey:@"region"];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.latitude) forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.longitude) forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
