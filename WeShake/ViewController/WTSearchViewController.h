//
//  WTSearchViewController.h
//  WeShake
//
//  Created by Dafeng Jin on 13-9-11.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTSearchMenuViewController.h"
#import "WTRegionViewController.h"

@interface WTSearchViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, WTSearchMenuViewDelagate, WTRegionViewDelegate>

@end
