//
//  WTSearchMenuViewController.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-12.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SHOP_MENU_LOCATION    0
#define SHOP_MENU_CUISINE     1
#define SHOP_MENU_BUDGET      2

@protocol WTSearchMenuViewDelagate <NSObject>

- (void)didSelectNewSearchConditionWithRegion:(NSString *)aRegion
                                         area:(NSString *)anArea
                                     district:(NSString *)aDistrict
                                        genre:(NSString *)aGenre
                                      cuisine:(NSString *)aCuisine
                                       period:(NSString *)aPeriod
                                       budget:(NSString *)aBudget;

- (void)didSelectNewSearchConditionNotImplemented;

@end

@interface WTSearchMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) NSInteger menuType;
@property (assign, nonatomic) id<WTSearchMenuViewDelagate> delegate;

@property (copy, nonatomic) NSString *region;
@property (copy, nonatomic) NSString *area;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *genre;
@property (copy, nonatomic) NSString *cuisine;
@property (copy, nonatomic) NSString *period;
@property (copy, nonatomic) NSString *budget;

@end
