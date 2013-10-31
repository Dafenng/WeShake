//
//  WTDataDef.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-12.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define TEST_ENV

#ifdef TEST_ENV

#define BaseURL @"http://localhost:3000"
#define ApiKey @"6ae1d580123c3955b845ef010e0bbb7a"

#else

#define BaseURL @"http://weshakeserver-env-fnaviqzav8.elasticbeanstalk.com/"
#define ApiKey @"b37b05b0ad3697273489100a84f156da"

#endif


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
