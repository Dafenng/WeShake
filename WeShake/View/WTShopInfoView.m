//
//  WTShopInfoView.m
//  WeShake
//
//  Created by Dafeng Jin on 13-11-9.
//  Copyright (c) 2013年 WeTech. All rights reserved.
//

#import "WTShopInfoView.h"
#import "EDStarRating.h"

@interface WTShopInfoView ()

@end

@implementation WTShopInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setupInfoViewWithShop:(WTShop *)aShop
{
    CGFloat leftXOffset = 10.f;
    CGFloat rightXOffset = 90.f;
    
    CGFloat leftWidth = 80.f;
    CGFloat rightWidtth = 200.f;
    
    CGFloat baseHeight = 21.f;
    CGFloat yOffset = 5.f;
    
    //店名
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftXOffset, yOffset, leftWidth, baseHeight)];
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightXOffset, yOffset, rightWidtth, baseHeight)];
    rightLabel.numberOfLines = 0;
    leftLabel.text = @"店名";
    rightLabel.text = aShop.name;
    [rightLabel sizeToFit];
    
    [self addSubview:leftLabel];
    [self addSubview:rightLabel];
    yOffset += rightLabel.frame.size.height > leftLabel.frame.size.height ? rightLabel.frame.size.height + 5.f: leftLabel.frame.size.height + 5.f;
    
    //地址
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftXOffset, yOffset, leftWidth, baseHeight)];
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightXOffset, yOffset, rightWidtth, baseHeight)];
    rightLabel.numberOfLines = 0;
    leftLabel.text = @"住所";
    rightLabel.text = aShop.addr;
    [rightLabel sizeToFit];
    
    [self addSubview:leftLabel];
    [self addSubview:rightLabel];
    yOffset += rightLabel.frame.size.height > leftLabel.frame.size.height ? rightLabel.frame.size.height + 5.f: leftLabel.frame.size.height + 5.f;
    
    //餐饮风格
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftXOffset, yOffset, leftWidth, baseHeight)];
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightXOffset, yOffset, rightWidtth, baseHeight)];
    rightLabel.numberOfLines = 0;
    leftLabel.text = @"ジャンル";
    rightLabel.text = aShop.genreInfo;
    [rightLabel sizeToFit];
    
    [self addSubview:leftLabel];
    [self addSubview:rightLabel];
    yOffset += rightLabel.frame.size.height > leftLabel.frame.size.height ? rightLabel.frame.size.height + 5.f: leftLabel.frame.size.height + 5.f;
    
    //电话
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftXOffset, yOffset, leftWidth, baseHeight)];
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightXOffset, yOffset, rightWidtth, baseHeight)];
    rightLabel.numberOfLines = 0;
    leftLabel.text = @"TEL";
    rightLabel.text = aShop.tel;
    [rightLabel sizeToFit];
    
    [self addSubview:leftLabel];
    [self addSubview:rightLabel];
    yOffset += rightLabel.frame.size.height > leftLabel.frame.size.height ? rightLabel.frame.size.height + 5.f: leftLabel.frame.size.height + 5.f;
    
    //附近
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftXOffset, yOffset, leftWidth, baseHeight)];
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightXOffset, yOffset, rightWidtth, baseHeight)];
    
    NSString *access = aShop.access;
    NSString *accessText = [access stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    
    CGSize accessSize = [access sizeWithFont:[UIFont systemFontOfSize:17] forWidth:rightWidtth lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newFrame = rightLabel.frame;
    newFrame.size.height = accessSize.height;
    rightLabel.frame = newFrame;
    
    rightLabel.numberOfLines = 0;
    leftLabel.text = @"アクセス";
    rightLabel.text = accessText;
    [rightLabel sizeToFit];
    
    [self addSubview:leftLabel];
    [self addSubview:rightLabel];
    yOffset += rightLabel.frame.size.height > leftLabel.frame.size.height ? rightLabel.frame.size.height + 5.f: leftLabel.frame.size.height + 5.f;
    
    //营业时间
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftXOffset, yOffset, leftWidth, baseHeight)];
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightXOffset, yOffset, rightWidtth, baseHeight)];
    
    NSString *openTime = aShop.openTime;
    NSString *openTimeText = [openTime stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    
    CGSize openSize = [openTime sizeWithFont:[UIFont systemFontOfSize:17] forWidth:rightWidtth lineBreakMode:NSLineBreakByWordWrapping];
    
    newFrame = rightLabel.frame;
    newFrame.size.height = openSize.height;
    rightLabel.frame = newFrame;
    
    rightLabel.numberOfLines = 0;
    leftLabel.text = @"営業時間";
    rightLabel.text = openTimeText;
    [rightLabel sizeToFit];
    
    [self addSubview:leftLabel];
    [self addSubview:rightLabel];
    yOffset += rightLabel.frame.size.height > leftLabel.frame.size.height ? rightLabel.frame.size.height + 5.f: leftLabel.frame.size.height + 5.f;
    
    //定休日
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftXOffset, yOffset, leftWidth, baseHeight)];
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightXOffset, yOffset, rightWidtth, baseHeight)];
    rightLabel.numberOfLines = 0;
    leftLabel.text = @"定休日";
    rightLabel.text = aShop.holiday ? aShop.holiday : @"無";
    [rightLabel sizeToFit];
    
    [self addSubview:leftLabel];
    [self addSubview:rightLabel];
    yOffset += rightLabel.frame.size.height > leftLabel.frame.size.height ? rightLabel.frame.size.height + 5.f: leftLabel.frame.size.height + 5.f;
    
    //午餐价位
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftXOffset, yOffset, leftWidth, baseHeight)];
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightXOffset, yOffset, rightWidtth, baseHeight)];
    rightLabel.numberOfLines = 0;
    leftLabel.text = @"ランチ";
    rightLabel.text = aShop.lunchBudget;
    [rightLabel sizeToFit];
    
    [self addSubview:leftLabel];
    [self addSubview:rightLabel];
    yOffset += rightLabel.frame.size.height > leftLabel.frame.size.height ? rightLabel.frame.size.height + 5.f: leftLabel.frame.size.height + 5.f;
    
    //晚餐价位
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftXOffset, yOffset, leftWidth, baseHeight)];
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightXOffset, yOffset, rightWidtth, baseHeight)];
    rightLabel.numberOfLines = 0;
    leftLabel.text = @"ディナー";
    rightLabel.text = aShop.dinnerBudget;
    [rightLabel sizeToFit];
    
    [self addSubview:leftLabel];
    [self addSubview:rightLabel];
    yOffset += rightLabel.frame.size.height > leftLabel.frame.size.height ? rightLabel.frame.size.height + 5.f: leftLabel.frame.size.height + 5.f;
    
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftXOffset, yOffset, leftWidth, baseHeight)];
    EDStarRating * ratingView = [[EDStarRating alloc] initWithFrame:CGRectMake(rightXOffset, yOffset, rightWidtth / 2, baseHeight)];
    leftLabel.text = @"評価";

    ratingView.backgroundColor  = [UIColor clearColor];
    ratingView.starImage = [UIImage imageNamed:@"grey_star.png"];
    ratingView.starHighlightedImage = [UIImage imageNamed:@"star.png"];
    ratingView.maxRating = 5.0;
    ratingView.horizontalMargin = 0.0;
    ratingView.editable = NO;
    ratingView.rating = aShop.rating.floatValue;
    ratingView.displayMode=EDStarRatingDisplayHalf;
    [ratingView  setNeedsDisplay];
    
    [self addSubview:leftLabel];
    [self addSubview:ratingView];
    yOffset += ratingView.frame.size.height + 20.f;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [(UILabel *)view setFont:[UIFont systemFontOfSize:14]];
        }
    }
    
//    CGRect frame = self.frame;
//    frame.size.height = yOffset;
//    self.frame = frame;
    
    self.frame = CGRectMake(10, 280, 300, yOffset);
}

@end
