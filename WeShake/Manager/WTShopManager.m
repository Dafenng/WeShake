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

@property (strong, nonatomic) NSMutableArray *suggestShopIds;
@property (assign, nonatomic) NSInteger preSuggestShopId;
@property (assign, nonatomic) NSInteger suggestShopCount;

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
        _suggestShopIds = [NSMutableArray array];
    }
    return self;
}

- (BOOL)shopIdExist:(NSInteger)shopId
{
    __block BOOL idExist = NO;
    [_suggestShopIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj integerValue] == shopId) {
            idExist = YES;
            *stop = YES;
        }
    }];
    
    return idExist;
}

- (void)getSuggestShopWithSuccess:(void (^)(WTShop *shop))successBlock
                          failure:(void (^)(ErrorType errorCode))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"/api/v1/shops"];
    NSDictionary *params = @{
                             @"process": @"suggest",
                             @"latitude": @([[WTLocationManager sharedInstance] latitude]),
                             @"longitude": @([[WTLocationManager sharedInstance] longitude]),
                             @"radius": @([[WTLocationManager sharedInstance] radius])
                             };
    
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"GET" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.suggestShopCount = (NSInteger)[responseObject valueForKeyPath:@"result.total"];
        
        //当前位置，当前半径下无可推荐shop，返回去扩大半径范围
        if (self.suggestShopCount == 0) {
            failureBlock(ZeroCountError);
            return;
        }
        
        WTShop *shop = [MTLJSONAdapter modelOfClass:WTShop.class fromJSONDictionary:[responseObject objectForKey:@"shop"] error:nil];
        shop.distance = [[WTLocationManager sharedInstance] getDistanceTo:CLLocationCoordinate2DMake(shop.latitude.doubleValue, shop.longitude.doubleValue)];
        
        //当前半径下均已经推荐过，返回扩大半径再推荐，需调整
        if (self.suggestShopCount == [self.suggestShopIds count]) {
            failureBlock(TotalUsedError);
            return;
        }
        
        //和上一次推荐相同，返回重新推荐
        if (shop.shopId.integerValue == self.preSuggestShopId) {
            failureBlock(PreSameError);
            return;
        }
        
        if (![self shopIdExist:shop.shopId.integerValue]) {
            [self.suggestShopIds addObject:shop.shopId];
        }
        
        self.preSuggestShopId = shop.shopId.integerValue;
        successBlock(shop);
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(NetworkError);
    }];

}


- (void)getSearchShopsWithRegion:(NSString *)aRegion
                             area:(NSString *)anArea
                         district:(NSString *)aDistrict
                           genre:(NSString *)aGenre
                         cuisine:(NSString *)aCuisine
                          period:(NSString *)aPeriod
                          budget:(NSString *)aBudget
                             from:(NSInteger)start
                            count:(NSInteger)aCount
                          sucsess:(void (^)(NSArray *shops))successBlock
                          failure:(void (^)(ErrorType errorCode))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"/api/v1/shops"];
    NSDictionary *params = @{
                             @"process": @"search",
                             @"latitude": @([[WTLocationManager sharedInstance] latitude]),
                             @"longitude": @([[WTLocationManager sharedInstance] longitude]),
                             @"region": aRegion,
                             @"area": anArea,
                             @"district": aDistrict,
                             @"genre": aGenre,
                             @"cuisine": aCuisine,
                             @"period": aPeriod,
                             @"budget": aBudget,
                             @"start" : @(start),
                             @"count" : @(aCount)
                             };
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"GET" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *searchShopList = [NSMutableArray array];
        [(NSArray *)[responseObject objectForKey:@"shops"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WTShop *shop = [MTLJSONAdapter modelOfClass:WTShop.class fromJSONDictionary:obj error:nil];
            shop.distance = [[WTLocationManager sharedInstance] getDistanceTo:CLLocationCoordinate2DMake(shop.latitude.doubleValue, shop.longitude.doubleValue)];
            [searchShopList addObject:shop];
        }];
        
        successBlock(searchShopList);
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(NetworkError);
    }];

}

- (void)getSearchShopsFrom:(NSInteger)start
                     count:(NSInteger)count
                   success:(void (^)(NSArray *shops))successBlock
                   failure:(void (^)(ErrorType errorCode))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"/api/v1/shops"];
    NSDictionary *params = @{
                             @"process": @"search",
                             @"search_type": @"search_location",
                             @"latitude": @([[WTLocationManager sharedInstance] latitude]),
                             @"longitude": @([[WTLocationManager sharedInstance] longitude]),
                             @"radius": @([[WTLocationManager sharedInstance] radius]),
                             @"start" : @(start),
                             @"count" : @(count)
                             };
    
    [WTHttpEngine startHttpConnectionWithPath:path method:@"GET" usingParams:params andSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *searchShopList = [NSMutableArray array];
        [(NSArray *)[responseObject objectForKey:@"shops"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WTShop *shop = [MTLJSONAdapter modelOfClass:WTShop.class fromJSONDictionary:obj error:nil];
            shop.distance = [[WTLocationManager sharedInstance] getDistanceTo:CLLocationCoordinate2DMake(shop.latitude.doubleValue, shop.longitude.doubleValue)];
            [searchShopList addObject:shop];
        }];
        
        successBlock(searchShopList);
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(NetworkError);
    }];
}

@end
