//
//  JWChatMessageFrameModel.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

#import "JWChatMessageModel.h"

typedef NS_ENUM(NSInteger, chatmessagestatus)
{
    chatmessageStatusNormal = 1,
    chatmessageStatusLoading,
    chatmessageStatusFail
};

typedef void(^completechatmessageBlock)(chatmessagestatus status);

@interface JWChatMessageFrameModel : NSObject

@property (nonatomic, strong) JWChatMessageModel *message;

@property (nonatomic, assign) BOOL mySend;

@property (nonatomic, assign) CGRect timeFrame;

@property (nonatomic, assign) CGRect iconFrame;

@property (nonatomic, assign) CGRect textFrame;

@property (nonatomic, assign) CGRect photoImageFrame;

@property (nonatomic, assign) float photoHeight;

@property (nonatomic, assign) float photoWidth;


@property (nonatomic, assign) CGRect titleFrame;

@property (nonatomic, assign) CGRect activitViewFrame;

@property (nonatomic, assign) CGFloat cellHeght;

@property (nonatomic, assign) chatmessagestatus messagestatus;

@property (nonatomic, copy) completechatmessageBlock completeBlock;

@end
