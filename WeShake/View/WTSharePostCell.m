//
//  WTSharePostCell.m
//  WeShake
//
//  Created by Dafeng Jin on 13-10-13.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTSharePostCell.h"
#import "UIImageView+AFNetworking.h"
#import "WTUser.h"
#import "WTDataDef.h"

@interface WTSharePostCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shareShopImageView;


@end

@implementation WTSharePostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (id)cellFromNib
{
	NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"WTSharePostCell" owner:nil options:nil];
	return [nibs objectAtIndex:0];
}

- (void)initWithPost:(WTPost *)post
{
    [self.headImageView setImageWithURL:[NSURL URLWithString:[[WTUser sharedInstance] avatar]] placeholderImage:nil];
    self.nameLabel.text = [[WTUser sharedInstance] username];
    self.dateLabel.text = [[WTPost dateFormatter] stringFromDate:post.createTime];
    self.messageLabel.text = post.message;
    [self.shareShopImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BaseURL, post.photo]] placeholderImage:nil];
}
@end
