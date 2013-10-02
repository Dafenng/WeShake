//
//  WTShopParser.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTShopParser : NSObject

+ (NSMutableArray *)parseShopFromXML:(NSString *)xmlText;
+ (NSMutableArray *)parseShopFromJSON:(NSString *)jsonText;

@end
