//
//  WTShopManager.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShopManager.h"
#import "AFNetworking.h"
#import "WTLocationManager.h"
#import "WTShopParser.h"
#import "NSMutableArray+Shuffling.h"

@interface WTShopManager ()

@property (strong, nonatomic) NSMutableArray *suggestShopList;
@property (copy, nonatomic) GetShopSucceedBlock getShopSucceedBlock;
@property (copy, nonatomic) GetShopFailBlock getShopFailBlock;

@end

@implementation WTShopManager

+ (WTShopManager *)sharedInstance
{
    static WTShopManager *_sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _sharedInstance = [[WTShopManager alloc] init];
        
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSInteger)getShopCount
{
    return self.suggestShopList.count;
}

- (void)requestShopData
{
    CLLocationCoordinate2D coordinate = [[WTLocationManager sharedInstance] currentCoordinate];
    NSString *latitudeStr = [NSString stringWithFormat:@"%.20f", coordinate.latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%.20f", coordinate.longitude];
    
    //TODO: 用与NetPeriod类似的方式统一化网络请求 将URL移出
    NSString *url = [NSString stringWithFormat:@"http://localhost:3000/shops.json?latitude=%@&longitude=%@&radius=%f", latitudeStr, longitudeStr, [[WTLocationManager sharedInstance] radius]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"returnedXML.xml"];
//    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseShopData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get Suggest Error");
    }];
    
    [operation start];
}

- (void)parseShopData:(id)shopData
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *xmlFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"returnedXML.xml"];
//    NSString *xmlText = [[NSString alloc] initWithContentsOfFile:xmlFilePath
//                                                        encoding:NSUTF8StringEncoding
//                                                           error:nil];
    
    //TODO:XML解析的方式要换掉
    self.suggestShopList = [WTShopParser parseShopFromJSON:shopData];
    
    if ([self.suggestShopList count] > 0) {
        if (self.shopIndex >= self.suggestShopList.count) {
            // get a shop from shopList and pass it
            [self.suggestShopList shuffle];
            self.shopIndex = 0;
        }
        
        if (self.shouldActivateHTTPRequest) {
            for (WTShop *aShop in self.suggestShopList) {
                aShop.distance = [[WTLocationManager sharedInstance] getDistanceFrom:[[WTLocationManager sharedInstance] currentCoordinate] to:CLLocationCoordinate2DMake(aShop.latitude, aShop.longitude)];
            }
            
            //商铺按距离排序
            /*
             NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
             NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
             self.shopList = [NSMutableArray arrayWithArray:[self.shopList sortedArrayUsingDescriptors:sortDescriptors]];
             */
        }
        
        self.shopIndex = 0;
        self.shouldActivateHTTPRequest = NO;
        WTShop *shop = [self.suggestShopList objectAtIndex:self.shopIndex++];
        self.getShopSucceedBlock(shop);
    } else {
        [WTLocationManager sharedInstance].radius += kBaseRadiusStep;
        if ([[WTLocationManager sharedInstance] radius] <= kBaseRadiusMax) {
            [self requestShopData];
        } else {
            self.getShopFailBlock();
        }
    }
}

- (void)getOneSuggestShopWithSuccess:(GetShopSucceedBlock)succeedBlock
                             failure:(GetShopFailBlock)failBlock
{
    self.getShopSucceedBlock = [succeedBlock copy];
    self.getShopFailBlock = [failBlock copy];
    
    if (self.shouldActivateHTTPRequest) {
        [self requestShopData];
    } else if (self.suggestShopList.count > 0) {
        WTShop *shop = [self.suggestShopList objectAtIndex:self.shopIndex++];
        self.getShopSucceedBlock(shop);
    } else {
        self.getShopFailBlock();
    }
    
    
}

- (void)getSearchShopsWithConditionOfLatitude:(double)latitude
                                    longitude:(double)longitude
                                      succsee:(void (^)(NSArray *shops))successBlock
                                      failure:(void (^)(NSString *error))failureBlock
{
    NSString *url = [NSString stringWithFormat:@"http://localhost:3000/shops.json?latitude=%f&longitude=%f&radius=%@", latitude, longitude, @"1.0"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"returnedResult.xml"];
//    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *xmlFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"returnedResult.xml"];
//        NSString *xmlText = [[NSString alloc] initWithContentsOfFile:xmlFilePath
//                                                            encoding:NSUTF8StringEncoding
//                                                               error:nil];
        NSArray *searchShopList = [WTShopParser parseShopFromJSON:responseObject];
        
        for (WTShop *aShop in searchShopList) {
            aShop.distance = [[WTLocationManager sharedInstance] getDistanceFrom:CLLocationCoordinate2DMake(latitude, longitude) to:CLLocationCoordinate2DMake(aShop.latitude, aShop.longitude)];
        }
        
        if (searchShopList.count) {
            for (WTShop *aShop in searchShopList) {
                aShop.distance = [[WTLocationManager sharedInstance] getDistanceFrom:CLLocationCoordinate2DMake(latitude, longitude) to:CLLocationCoordinate2DMake(aShop.latitude, aShop.longitude)];
            }
            successBlock(searchShopList);
        }
        else {
            failureBlock(@"No restaurant found! Please try other conditions.");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failureBlock(@"Network Error");
    }];
    
    [operation start];
}

@end
