//
//  WTHttpEngine.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-14.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WTHttpEngine : NSObject

+ (void)startHttpConnectionWithPath:(NSString *)path
                             method:(NSString *)method
                        usingParams:(NSDictionary *)params
                    andSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+ (void)startHttpConnectionWithImageDic:(NSDictionary *)imageDic
                                   path:(NSString *)path
                                 method:(NSString *)method
                            usingParams:(NSDictionary *)params
                        andSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
