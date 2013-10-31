//
//  WTHttpEngine.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-14.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTHttpEngine.h"
#import "WTDataDef.h"

@implementation WTHttpEngine

+ (void)startHttpConnectionWithPath:(NSString *)path
                             method:(NSString *)method
                        usingParams:(NSDictionary *)params
                    andSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    
    NSURL *url = [NSURL URLWithString:BaseURL];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setAuthorizationHeaderWithToken:ApiKey];
    
    NSURLRequest *request = [httpClient requestWithMethod:method path:path parameters:params];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [operation start];
}

+ (void)startHttpConnectionWithImageDic:(NSDictionary *)imageDic
                                   path:(NSString *)path
                                 method:(NSString *)method
                            usingParams:(NSDictionary *)params
                        andSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    
    NSURL *url = [NSURL URLWithString:BaseURL];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setAuthorizationHeaderWithToken:ApiKey];
    
    NSData *imageData = UIImageJPEGRepresentation(imageDic[@"image"], 1.0);
    NSURLRequest *request = [httpClient multipartFormRequestWithMethod:method path:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:imageDic[@"name"] fileName:imageDic[@"filename"] mimeType:imageDic[@"mimetype"]];
    }];
    
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        //        CGFloat progress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
//        //        progressBlock(progress);
//    }];
    
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [operation start];
}

@end
