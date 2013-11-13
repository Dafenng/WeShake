//
//  WTShopMapViewController.m
//  WeShake
//
//  Created by Dafeng Jin on 13-11-1.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShopMapViewController.h"
#import "WTShopAnnotation.h"
#import <AddressBook/AddressBook.h>
#import "WTLocationManager.h"

@interface WTShopMapViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *openNav;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation WTShopMapViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self revealShop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)revealShop
{
//    CLLocationCoordinate2D shopLocation = CLLocationCoordinate2DMake(30.222000, 120.222000);
    CLLocationCoordinate2D shopLocation = CLLocationCoordinate2DMake(self.shop.latitude.doubleValue, self.shop.longitude.doubleValue);
    
    //TODO:根据用户与商家距离决定distance
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(shopLocation, 3000, 3000);
    MKCoordinateRegion adjustedRegion =  [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    [self getShopAnnotation];
}

- (void)getShopAnnotation
{
    WTShopAnnotation *shopAnnotation = [[WTShopAnnotation alloc] initWithShop:self.shop];
    [self.mapView addAnnotation:shopAnnotation];
}

- (IBAction)getDirections:(id)sender {
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.shop.latitude.doubleValue, self.shop.longitude.doubleValue);
    
    NSDictionary *addrDict = @{(NSString *)kABPersonAddressStreetKey: self.shop.addr};
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:addrDict];

    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    mapItem.name = self.shop.name;
//    mapItem.phoneNumber = @""
//    mapItem.url =
    
    NSDictionary *launchOptions = @{
                                    MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking
                                    };
    
    [MKMapItem openMapsWithItems:@[mapItem] launchOptions:launchOptions];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D shopLocation = CLLocationCoordinate2DMake(self.shop.latitude.doubleValue, self.shop.longitude.doubleValue);
    CLLocationCoordinate2D centerLocation = CLLocationCoordinate2DMake((shopLocation.latitude + userLocation.location.coordinate.latitude) / 2, (shopLocation.longitude + userLocation.location.coordinate.longitude) / 2);
    
    double latitudeOffset = fabsf(userLocation.location.coordinate.latitude - shopLocation.latitude);
    double longitudeOffset = fabsf(userLocation.location.coordinate.longitude - shopLocation.longitude);
    
    //按照经度差一度，距离差85km，纬度差一度，距离差110km算
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerLocation, latitudeOffset * 85000 * 2, longitudeOffset * 110000 * 2);
    [mapView setRegion:region animated:YES];
}

@end
