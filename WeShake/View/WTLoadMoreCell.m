//
//  WTLoadMoreCell.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-24.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTLoadMoreCell.h"

@implementation WTLoadMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)loadMoreCellFromNib
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"WTLoadMoreCell" owner:nil options:nil];
	return [nibs objectAtIndex:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
