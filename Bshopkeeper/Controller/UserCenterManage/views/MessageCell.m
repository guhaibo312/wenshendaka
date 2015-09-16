//
//  MessageCell.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/9.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "MessageCell.h"
#import "CellFrameModel.h"
#import "MessageModel.h"
#import "UIImage+ResizeImage.h"
#import "UIUtils.h"

@interface MessageCell()
{
    UILabel *_timeLabel;
    UIImageView *_iconView;
    UIButton *_textView;
}
@end

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
        
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
        _textView = [UIButton buttonWithType:UIButtonTypeCustom];
        _textView.titleLabel.numberOfLines = 0;
        _textView.titleLabel.font = [UIFont systemFontOfSize:13];
        _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self.contentView addSubview:_textView];
        
    }
    return self;
}
- (void)setCellFrame:(CellFrameModel *)cellFrame
{
    _cellFrame = cellFrame;
    MessageModel *message = cellFrame.message;
    
    _timeLabel.frame = cellFrame.timeFrame;
    double time = [message.created_at doubleValue];
    _timeLabel.text = [UIUtils intoMMDDHHmmFrom:time/1000];
    
    _iconView.frame = cellFrame.iconFrame;
    
    NSString *iconStr = message.type ? @"other" : @"me";
    _iconView.layer.cornerRadius = cellFrame.iconFrame.size.width/2;
    _iconView.layer.masksToBounds = YES;
    _iconView.image = [UIImage imageNamed:iconStr];

    
    _textView.frame = cellFrame.textFrame;
    
    NSString *textBg = @"chat_recive_nor";
    UIColor *textColor = [UIColor blackColor];
    if ([message.type isEqualToString:@"user_reply"]) {
        textBg = @"chat_send_nor";
        textColor = [UIColor whiteColor];
    }
    [_textView setTitleColor:textColor forState:UIControlStateNormal];
    [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
    [_textView setTitle:message.content forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
