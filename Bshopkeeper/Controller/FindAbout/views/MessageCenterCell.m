//
//  MessageCenterCell.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/21.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "MessageCenterCell.h"
#import "Configurations.h"
#import "UIImageView+WebCache.h"

@implementation MessageCenterCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        nameLabel = [UILabel labelWithFrame:CGRectMake(20, 4, SCREENWIDTH-40, 20) fontSize:14 fontColor:[UIColor blackColor] text:@""];
        [self.contentView addSubview:nameLabel];
        
        timeLabel = [UILabel labelWithFrame:CGRectMake(20, 30, 120, 18) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:timeLabel];
        
        readLabel = [UILabel labelWithFrame:CGRectMake(10, 22, 6, 6) fontSize:14 fontColor:[UIColor blackColor] text:@""];
        readLabel.layer.cornerRadius = 3;
        readLabel.clipsToBounds = YES;
        readLabel.hidden = YES;
        [self.contentView addSubview:readLabel];
        
    }
    return self;
}

- (void)bingMessgeCenterModer:(MessageCenterModel *)messageModel
{
    if (messageModel) {
        
        nameLabel.text = messageModel.content;
        if (messageModel.createdTime) {
            timeLabel.text = [UIUtils intoYYYYMMDDHHmmFrom:[messageModel.createdTime doubleValue]/1000];
        }
        
       
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
