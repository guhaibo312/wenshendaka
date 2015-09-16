//
//  PhotoWallView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/2.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JWChatMessageFrameModel;

@interface PhotoWallView : UIView

- (void)setAllImageWithArray:(NSArray *)imageArray;

- (void)setBigImageCenter;

- (void)chatResetImage:(JWChatMessageFrameModel *)model isMySend:(BOOL)mySend;

@end
