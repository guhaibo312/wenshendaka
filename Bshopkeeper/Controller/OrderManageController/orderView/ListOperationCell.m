//
//  ListOperationCell.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ListOperationCell.h"
#import "UIViewExt.h"

@implementation ListOperationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 9, 26, 26)];
        _headImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_headImg];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25+26+10, 2, 200, 40)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}


@end
