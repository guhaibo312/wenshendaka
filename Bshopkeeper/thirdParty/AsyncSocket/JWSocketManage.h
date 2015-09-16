//
//  JWSocketManage.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/21.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"

//命令前缀
//CS：表示客户端主动向服务器发起
//SC：表示服务器主动向客户端发起
//
//命令后缀
//Res：表示相应命令的返回命令

/**message 结构
 {
 _id:字符串，唯一标识
 title:字符串，标题
 text:字符串，内容
 images:数组，url字符串，单张图则是长度为1的数组
 url:字符串，点击跳转链接
 type:message类型,若前端遇到陌生类型直接屏蔽忽略掉这一条(1:文字;2:图片;3:图文;4:分享链接及预览图;5:多图;6:多图及文字;)
 fromId:来源user的Id
 otherId:对话对象的Id
 time:时间戳，消息时间
 }
 (16bit 无符号int 命令类型)(32bit 无符号int JSON字符串长度)(JSON字符串)”

 */





typedef NS_ENUM(NSInteger , PackageType) {
    CS_checkIn                      = 100,
    CS_checkInRes                   = 101,
    CS_talk                         = 102,
    CS_taklRes                      = 103,
    CS_messageArrive                = 104,
    CS_messageArriveRes             = 105,
    CS_offlineMessage               = 106,
    CS_offlineMessageRes            = 107,
    CS_getOldMessage                = 108,
    CS_getOldMessageRes             = 109,
    CS_getTalkUsers                 = 110,
    CS_getTalkUsersRes              = 111,
    CS_delegateMessage              = 112,
    CS_delegateMessageRes           = 113,
    CS_heartBeat                    = 114,
    CS_heartBeatRes                 = 115
};


@interface JWSocketManage : NSObject



@property (nonatomic,  assign) BOOL isConnect;                 //链接状态

@property (nonatomic,  strong) NSMutableArray *messageArray;

@property (nonatomic , strong) AsyncSocket *clientSocket;

+(instancetype)shareManage;

- (void)startConnect;

- (void)disConnect;
@end

