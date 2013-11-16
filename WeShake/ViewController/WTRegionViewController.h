//
//  WTRegionViewController.h
//  WeShake
//
//  Created by Dafeng Jin on 13-11-14.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTRegionViewDelegate <NSObject>

- (void)didSelectRegion:(NSString *)aRegion;

@end

@interface WTRegionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<WTRegionViewDelegate>delegate;

@end
