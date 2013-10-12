//
//  WTUser.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTUser : NSObject

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *userId;

+ (WTUser *)sharedInstance;

@end
