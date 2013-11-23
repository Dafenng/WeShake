//
//  WTDataDef.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-12.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define TEST_ENV
#define REAL_LOCATION

#ifdef TEST_ENV

#define BaseURL @"http://localhost:3000"
#define ApiKey @"03faedf399ff6f3cea109f64bdc8403b"

#else

#define BaseURL @"http://weshakeserver-env-fnaviqzav8.elasticbeanstalk.com/"
#define ApiKey @"b37b05b0ad3697273489100a84f156da"

#endif


#define OS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef enum {
    
    NetworkError = 1,
    ZeroCountError,
    PreSameError,
    TotalUsedError
    
}ErrorType;

#define CountPerRequest 10

#define Region_Update_Notification @"RegionUpdateNotification"
#define Application_Become_Active @"ApplicationBecomeActive"
#define Application_Resign_Active @"ApplicationResignActive"

@interface WTDataDef : NSObject

@end
