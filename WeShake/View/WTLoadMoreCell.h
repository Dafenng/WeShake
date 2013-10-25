//
//  WTLoadMoreCell.h
//  WeShake
//
//  Created by Dafeng Jin on 13-10-24.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTLoadMoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *status;


+ (id)loadMoreCellFromNib;

@end
