//
//  JWSocketManage.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/21.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWSocketManage.h"
#import "Configurations.h"
#import "SBJson.h"
#import "JWSocketCpu.h"


@interface JWSocketManage ()<AsyncSocketDelegate>
{
    BOOL firstlogin;
    NSTimer *timer;
}

@end



@implementation JWSocketManage


+ (instancetype)shareManage
{
    static JWSocketManage *sockerManage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sockerManage = [[JWSocketManage alloc]init];
    });
    return sockerManage;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _clientSocket = [[AsyncSocket alloc] initWithDelegate:self];
        [_clientSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        _messageArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -- 断开连接
- (void)disConnect
{
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
        }
    }
    if ([_clientSocket isConnected]) {
        _isConnect = NO;
        [_clientSocket disconnect];
    }
}

#pragma mark -- 开始链接
- (void)startConnect
{
    [_clientSocket setDelegate:self];
    if (![_clientSocket isConnected])
    {
        NSError *error = nil;
       BOOL connectStatus =  [_clientSocket connectToHost:Socket_Host onPort:Socket_Port withTimeout:100 error:&error];
        if (error || !connectStatus)
        {
            NSLog(@"链接服务器失败 %@",error);
            [_clientSocket disconnect];
        }
    }
}

#pragma mark socketDelegate

#pragma mark Delegate

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"客户端即将断开连接错误：%@",err);
    NSLog(@"%@",sock.description);

    _isConnect = NO;
    if (timer) {
        [timer invalidate];
    }
    firstlogin = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatSytemConnectFailNotice object:@(NO)];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    _isConnect = NO;
    NSLog(@"客户端已经断开连接");
    firstlogin = NO;
    
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatSytemConnectFailNotice object:@(YES)];

    NSLog(@"客户端连接服务器成功");
    _isConnect = YES;
    
    if (!firstlogin){
        
        NSString *sessionId ;
        
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:@API_HOST]];
        
        for (NSHTTPCookie *cookie in cookies)
        {
            sessionId = cookie.value;
        }
        
        NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithCapacity:1];
        
        [parm setObject:sessionId forKey:@"sessionId"];
        [parm setObject:@"login" forKey:@"checkCode"];
        
        
        [[JWSocketCpu sharedInstance]writeActionWithcommand:CS_checkIn UserParm:parm ];
        
        firstlogin = YES;
    }

    if (timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(keepConnectionNormal:) userInfo:nil repeats:YES];
    
    [sock readDataWithTimeout:-1 tag:0];

}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"收到包了");
    
    [[JWSocketCpu sharedInstance]readDataFrom:data];
    
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:tag];
    NSLog(@"读取中。。。");
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"客户端完成写入数据 %ld",tag);
    
}

- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"写入失败");
    
}


#pragma mark -- 保持连接

- (void)keepConnectionNormal:(id)sender
{
    if (![User defaultUser].isLogIn) return;
    
    NSLog(@"心跳包发送");
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:@"heart" forKey:@"checkCode"];

    [[JWSocketCpu sharedInstance]writeActionWithcommand:CS_heartBeat UserParm:dict];
    
}







@end
