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

- (void)didSelectNewSearchConditionWithLatitude:(double)latitude longitude:(double)longitude;
- (void)didSelectNewSearchConditionNotImplemented;

@end

@interface WTSearchMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) NSInteger menuType;
@property (assign, nonatomic) id<WTSearchMenuViewDelagate> delegate;

@end
