//
//  CellFrameModel.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/9.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CellFrameModel.h"
#import "Configurations.h"
#import "NSString+Extension.h"
#import "MessageModel.h"
#import "NSString+URLEncoding.h"

#define timeH 40
#define padding 10
#define iconW 40
#define iconH 40
#define textW 150

@implementation CellFrameModel

- (void)setMessage:(MessageModel *)message
{
    _message = message;
    CGRect frame = [UIScreen mainScreen].bounds;
    
    //1.时间的Frame
    if (message.showTime) {
        CGFloat timeFrameX = 0;
        CGFloat timeFrameY = 0;
        CGFloat timeFrameW = frame.size.width;
        CGFloat timeFrameH = timeH;
        _timeFrame = CGRectMake(timeFrameX, timeFrameY, timeFrameW, timeFrameH);
    }
    
    //2.头像的Frame
    CGFloat iconFrameX = message.type ? padding : (frame.size.width - padding - iconW);
    CGFloat iconFrameY = CGRectGetMaxY(_timeFrame);
//    CGFloat iconFrameW = iconW;
//    CGFloat iconFrameH = iconH;
    _iconFrame = CGRectMake(iconFrameX, iconFrameY, 0, 0);
    
    //3.内容的Frame
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    CGSize textSize = CGSizeMake(0, 0);
    if ([NSObject nulldata :message.content]) {
        textSize = [message.content sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:textMaxSize];
    }
    CGSize textRealSize = CGSizeMake(textSize.width + textPadding * 2, textSize.height + textPadding * 2);
    CGFloat textFrameY = iconFrameY;
    
    CGFloat textFrameX = 2 * padding;
    
    if ([message.type isEqualToString:@"user_reply"]) {
        textFrameX = (frame.size.width - (padding * 2  + textRealSize.width));
    }

    _textFrame = (CGRect){textFrameX, textFrameY, textRealSize};
    
    //4.cell的高度
    _cellHeght = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame)) + padding;
}

@end
