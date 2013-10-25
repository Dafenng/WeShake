//
//  WTDataDef.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-12.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TestURL @"http://localhost:3000"

#define BaseURL @"http://weshakeserver-env-kdmkxun8wi.elasticbeanstalk.com"

#define ApiKeyTest @"6ae1d580123c3955b845ef010e0bbb7a"

#define ApiKeyServer @"b37b05b0ad3697273489100a84f156da"

#define OS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

typedef enum {
    
    NetworkError = 1,
    ZeroCountError,
    PreSameError,
    TotalUsedError
    
}ErrorType;

#define CountPerRequest 20

@interface WTDataDef : NSObject

@end
