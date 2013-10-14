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
#import "NSMutableArray+Shuffling.h"
#import "WTUser.h"
#import "WTHttpEngine.h"

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
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/shops"];
    NSDictionary *params = @{
                             @"latitude": @(coordinate.latitude),
                             @"longitude": @(coordinate.longitude),
                             @"radius": @([[WTLocationManager sharedInstance] radius])
    };
    
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"GET" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201)
        {
            [self parseShopData:responseObject];
        }
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get Suggest Error");
    }];

}

- (void)parseShopData:(id)shopData
{
    [self.suggestShopList removeAllObjects];
    [(NSArray *)shopData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        WTShop *shop = [MTLJSONAdapter modelOfClass:WTShop.class fromJSONDictionary:obj error:nil];
        [self.suggestShopList addObject:shop];
    }];
    
    if ([self.suggestShopList count] > 0) {
        if (self.shopIndex >= self.suggestShopList.count) {
            // get a shop from shopList and pass it
            [self.suggestShopList shuffle];
            self.shopIndex = 0;
        }
        
        if (self.shouldActivateHTTPRequest) {
            for (WTShop *aShop in self.suggestShopList) {
                aShop.distance = [[WTLocationManager sharedInstance] getDistanceFrom:[[WTLocationManager sharedInstance] currentCoordinate] to:CLLocationCoordinate2DMake(aShop.latitude.doubleValue, aShop.longitude.doubleValue)];
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
    NSString *path = [NSString stringWithFormat:@"/api/v1/shops"];
    NSDictionary *params = @{
                             @"latitude": @(latitude),
                             @"longitude": @(longitude),
                             @"radius": @1.0
                             };
    
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"GET" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *searchShopList = [NSMutableArray array];
        [(NSArray *)responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WTShop *shop = [MTLJSONAdapter modelOfClass:WTShop.class fromJSONDictionary:obj error:nil];
            [searchShopList addObject:shop];
        }];
        
        if (searchShopList.count) {
            for (WTShop *aShop in searchShopList) {
                aShop.distance = [[WTLocationManager sharedInstance] getDistanceFrom:CLLocationCoordinate2DMake(latitude, longitude) to:CLLocationCoordinate2DMake(aShop.latitude.doubleValue, aShop.longitude.doubleValue)];
            }
            successBlock(searchShopList);
        }
        else {
            failureBlock(@"No restaurant found! Please try other conditions.");
        }
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failureBlock(@"Network Error");
    }];
}

@end
