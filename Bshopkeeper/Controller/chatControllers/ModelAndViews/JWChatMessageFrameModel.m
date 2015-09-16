//
//  JWChatMessageFrameModel.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWChatMessageFrameModel.h"
#import "Configurations.h"
#import "NSString+Extension.h"


#define timeH 20
#define padding 10
#define iconW 44
#define iconH 44
#define TextMaxW 180

@implementation JWChatMessageFrameModel

- (void)setMessage:(JWChatMessageModel *)message
{
    
    _messagestatus = chatmessageStatusNormal;
    
    _message = message;
    CGRect frame = [UIScreen mainScreen].bounds;
    
    //1.时间的Frame
    if (message.time) {
        CGFloat timeFrameX = 0;
        CGFloat timeFrameY = 0;
        CGFloat timeFrameW = frame.size.width;
        CGFloat timeFrameH = timeH;
        _timeFrame = CGRectMake(timeFrameX, timeFrameY, timeFrameW, timeFrameH);
    }
    
    //2.头像的Frame
    NSString *sendId = [NSString stringWithFormat:@"%@",message.fromId];
    NSString *userID = [NSString stringWithFormat:@"%@",[User defaultUser].item.userId];
    
    _mySend = NO;
    if ([sendId isEqualToString:userID]) {
        _mySend = YES;
    }
    CGFloat iconFrameX = _mySend? (frame.size.width - padding - iconW):padding;
    CGFloat iconFrameY = CGRectGetMaxY(_timeFrame);
    CGFloat iconFrameW = iconW;
    CGFloat iconFrameH = iconH;
    _iconFrame = CGRectMake(iconFrameX, iconFrameY, iconFrameW, iconFrameH);
    
    
    //3.内容的Frame
    if ([NSObject nulldata:message.text]) {
        CGSize textMaxSize = CGSizeMake(TextMaxW, MAXFLOAT);
        CGSize textSize = [message.text sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:textMaxSize];
        CGSize textRealSize = CGSizeMake(textSize.width + 15 * 2, textSize.height + 15 * 2);
        CGFloat textFrameY = iconFrameY;
        CGFloat textFrameX = _mySend? (frame.size.width - (padding * 2 + iconFrameW + textRealSize.width)):(2 * padding + iconFrameW);
        _textFrame = (CGRect){textFrameX, textFrameY, textRealSize};
    }
    
    //4. 风火轮的位置
    CGFloat activitViewFrameX = _mySend?(_textFrame.origin.x-30):(_textFrame.origin.x+_textFrame.origin.x+_textFrame.size.width+10);
    
    _activitViewFrame = CGRectMake(activitViewFrameX, _iconFrame.origin.y+5, 30, 30);
    
    
    _titleFrame = CGRectMake(0, 0, 0, 0);
    
    //5. 图文中 文字的高度
    if ([NSObject nulldata:message.title]) {
        
        CGSize textMaxSize = CGSizeMake(TextMaxW, MAXFLOAT);
        float textSizeHeigth = [message.title sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:textMaxSize].height;
        
        if (textSizeHeigth >=16) {
            textSizeHeigth = 16+10;
        }else{
            textSizeHeigth = 20;
        }
        _titleFrame =  CGRectMake(_mySend?5:15, 0, TextMaxW, textSizeHeigth);
    }
    
    
    //6.图片的高度
     _photoHeight =  TextMaxW;
     _photoWidth  =  TextMaxW;
    if (message.images) {
        NSArray *imageArray = message.images;
        if (imageArray) {
            if (imageArray.count>0) {
                if (imageArray.count == 1) {
                    
                    NSString *firstimg = [imageArray firstObject];
                    if (firstimg) {
                        NSString *imgSize = [[firstimg componentsSeparatedByString:@"_"]lastObject];
                        if ([imgSize rangeOfString:@"X"].location != NSNotFound) {
                            
                            NSArray *temp = [imgSize componentsSeparatedByString:@"X"];
                            
                            NSString *first = [temp firstObject];
                            NSString *second = [temp lastObject];
                            
                            if ([NSObject nulldata:first] && [NSObject nulldata:second]) {
                                
                                
                                if ([[JudgeMethods defaultJudgeMethods]passWordIsPurelyDigital:first] && [[JudgeMethods defaultJudgeMethods]passWordIsPurelyDigital:second]) {
                                    CGSize asize;
                                    asize.width= [first floatValue];
                                    asize.height= [second floatValue];
                                    if (asize.width != 0 && asize.height != 0) {
                                        float m_width = [ first floatValue];
                                        float m_height = [second floatValue];
                                        
                                        if (m_width > m_height) {
                                            _photoHeight = m_height/(m_width/TextMaxW);
                                        }else if (m_height == m_width){
                                            _photoWidth = _photoHeight = TextMaxW;
                                        }else{
                                            _photoWidth = m_width/(m_height/TextMaxW);
                                        }

                                    }
                                }
                            }
                        }
                    }
                    
                }else{
                    int count = imageArray.count;
                    if (count<=3) {
                        _photoHeight = (TextMaxW-24)/3;
                    }else if (count>3 && count<= 6){
                        _photoHeight = (TextMaxW-24)/3*2+8;
                    }else {
                        _photoHeight = (TextMaxW-24)+16;
                    }
                    if (count == 2 || count == 4) {
                        _photoWidth = (TextMaxW-24)/3*2+8;
                    }else{
                        _photoWidth = (TextMaxW-24)+16;

                    }
                }
            }
        }
    }
    
       //7 cell的高度
    
    int type = message.type;
    if (type == 1) {
        _cellHeght = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame)) + padding;

    }else if (type == 2|| type == 5){
                
        CGSize textMaxSize = CGSizeMake(_photoWidth+10, _photoHeight+5);
        
        CGFloat textFrameY = iconFrameY;
        CGFloat textFrameX = _mySend? _iconFrame.origin.x - 20 - textMaxSize.width :_iconFrame.origin.x+10+_iconFrame.size.width;
        _photoImageFrame = (CGRect){textFrameX, textFrameY, textMaxSize};
        
        _cellHeght = timeH + textMaxSize.height +20  +padding+10;
        
    }else if (type == 3 || type == 6){
        
        _cellHeght = timeH + _photoHeight + 10 + padding + _timeFrame.size.height;
        
    }else if (type == 4 ){
        _cellHeght = timeH + padding + 64 +_timeFrame.size.height;
        
    }else{
        _cellHeght = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame)) + padding;
    }
    
}


@end
