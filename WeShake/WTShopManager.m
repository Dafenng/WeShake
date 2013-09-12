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

@property (assign, nonatomic) double radius;
@property (strong, nonatomic) NSMutableArray *shopList;
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

- (NSInteger)getShopCount
{
    return self.shopList.count;
}

- (void)requestShopData
{
    CLLocationCoordinate2D coordinate = [[WTLocationManager sharedInstance] currentCoordinate];
    NSString *latitudeStr = [NSString stringWithFormat:@"%.20f", coordinate.latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%.20f", coordinate.longitude];
    
    //TODO: 用与NetPeriod类似的方式统一化网络请求 将URL移出
    NSString *url = [NSString stringWithFormat:@"http://jdang.me:3001/restaurants.xml?latitude=%@&longitude=%@&radius=%f", latitudeStr, longitudeStr, [[WTLocationManager sharedInstance] radius]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"returnedXML.xml"];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseShopData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get xml error");
    }];
    
    [operation start];
}

- (void)parseShopData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *xmlFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"returnedXML.xml"];
    NSString *xmlText = [[NSString alloc] initWithContentsOfFile:xmlFilePath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
    
    //TODO:XML解析的方式要换掉
    self.shopList = [WTShopParser parseShopFromXML:xmlText];
    
    if (self.shopList.count > 0) {
        if (self.shopIndex >= self.shopList.count) {
            // get a shop from shopList and pass it
            [self.shopList shuffle];
            self.shopIndex = 0;
        }
        
        // if get array for the first time, calculate distance and sort by distance, or other algorithm to determin the sequence of appearence !!!!!
        if (self.shouldActivateHTTPRequest) {
            for (WTShop *aShop in self.shopList) {
                aShop.distance = [[WTLocationManager sharedInstance] getDistanceFrom:[[WTLocationManager sharedInstance] currentCoordinate] to:CLLocationCoordinate2DMake(aShop.latitude, aShop.longitude)];
            }
            
            // sort shop list by distance, optional
            /*
             NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
             NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
             self.shopList = [NSMutableArray arrayWithArray:[self.shopList sortedArrayUsingDescriptors:sortDescriptors]];
             */
        }
        
        self.shopIndex = 0;
        self.shouldActivateHTTPRequest = NO;
        WTShop *shop = [self.shopList objectAtIndex:self.shopIndex++];
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
    } else if (self.shopList.count > 0) {
        WTShop *shop = [self.shopList objectAtIndex:self.shopIndex++];
        self.getShopSucceedBlock(shop);
    } else {
        self.getShopFailBlock();
    }
    
    
}

@end
