//
//  WTShopParser.m
//  WeShake
//
//  Created by Dafeng Jin on 13-9-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShopParser.h"
#import "XMLReader.h"
#import "WTShop.h"
#import "JSONKit.h"

@implementation WTShopParser

+ (NSMutableArray *)parseShopFromXML:(NSString *)xmlText {
    
    NSError *parserError = nil;
    NSDictionary *xmlDict = [XMLReader dictionaryForXMLString:xmlText error:&parserError];
    
    //    NSData *xmlData = [xmlText dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *shopList = [[NSMutableArray alloc] init];
    
    NSDictionary *shopsRoot = [xmlDict objectForKey:@"restaurants"];
    
    if(shopsRoot)
    {
        NSArray *shops = [shopsRoot objectForKey:@"restaurant"];
        for (NSDictionary *aShop in shops) {
            WTShop *newShop = [[WTShop alloc] initWithShopId:[[aShop objectForKey:@"id-str"] objectForKey:@"text"]
                                                        name:[[aShop objectForKey:@"name"]objectForKey:@"text"]
                                                        addr:[[aShop objectForKey:@"addr"] objectForKey:@"text"]
                                                         tel:[[aShop objectForKey:@"tel"] objectForKey:@"text"]
                                                      region:[[aShop objectForKey:@"region"] objectForKey:@"text"]
                                                    location:[[aShop objectForKey:@"location"] objectForKey:@"text"]
                                                      access:[[aShop objectForKey:@"access"] objectForKey:@"text"]
                                                      budget:[[aShop objectForKey:@"budget"] objectForKey:@"text"]
                                                    shopType:[[aShop objectForKey:@"shopType"] objectForKey:@"text"]
                                                 cuisineType:[[aShop objectForKey:@"cuisineType"] objectForKey:@"text"]
                                                     station:[[aShop objectForKey:@"station"] objectForKey:@"text"]
                                                    latitude:[[[aShop objectForKey:@"latitude"] objectForKey:@"text"] doubleValue]
                                                   longitude:[[[aShop objectForKey:@"longitude"] objectForKey:@"text"] doubleValue]
                                                      rating:[[[aShop objectForKey:@"rating"] objectForKey:@"rating"] doubleValue]];
            
            [shopList addObject:newShop];
        }
    }
    
    return shopList;
    
}


+ (NSMutableArray *)parseShopFromJSON:(id)shopData
{
    NSMutableArray *shops = [NSMutableArray array];
    NSArray *shopArr = [shopData objectFromJSONData];
    for (NSDictionary *dict in shopArr) {
        WTShop *shop = [[WTShop alloc] initWithDict:dict];
        [shops addObject:shop];
    }
    
    return shops;
}

@end
