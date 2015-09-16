//
//  JWSocketCpu.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWSocketCpu.h"
#import "SBJson.h"
#import "JWSocketManage.h"
#import "Configurations.h"
#import "MKAnnotationView+WebCache.h"
#import "JWChatMessageModel.h"
#import "JWChatDataManager.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger , packetReadStatus) {
    readStatusStart =  1,
    readStatusReading ,
    readStatusEnd
};

@interface JWSocketCpu ()

@property (nonatomic, strong) NSMutableData *tempData;  //收到的临时包

@property (nonatomic, assign)int tempDataLength;        //收到到的临时包长度

@property (nonatomic, assign) int responderCode;        //收到包的命令

@property (nonatomic, assign) packetReadStatus readCompleteStatus; //包是否读完

@property (nonatomic, strong) NSMutableArray *messageModelArray;




@end

@implementation JWSocketCpu

+ (instancetype)sharedInstance
{
    static JWSocketCpu *cpu;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cpu = [[JWSocketCpu alloc]init];
        cpu.tempData = [[NSMutableData alloc]init];
        cpu.tempDataLength = 0;
        cpu.readCompleteStatus = readStatusStart;
        cpu.messageModelArray = [[NSMutableArray alloc]init];
        
    });
    return cpu;
    
    
}
- (void)writeActionWithcommand:(NSInteger)commendCode UserParm:(NSMutableDictionary *)parm
{
    NSMutableData *sendData = [[NSMutableData alloc]init];
    
    int checkIn = commendCode;
    
    Byte commends[2];
    
    [self intToBytes:checkIn byte:commends length:2];
    
    [sendData appendBytes:commends length:2];
    
    if (parm) {
        
        NSString *jsonParm = [parm JSONRepresentation];
        NSLog(@"我发送的数据：%@",jsonParm);
        
        Byte parmLengthBytes[4];
        
        NSData *jsonStrData = [jsonParm dataUsingEncoding:NSUTF8StringEncoding];
        
        [self intToBytes:(int)jsonStrData.length byte:parmLengthBytes length:4];
        
        [sendData appendBytes:parmLengthBytes length:4];
        
        [sendData appendData:jsonStrData];
        
    }
    
    if ([JWSocketManage shareManage].isConnect == NO) return;
    
    [[JWSocketManage shareManage].clientSocket writeData:sendData withTimeout:-1 tag:0];
}


- (void)writeActionWithcommand:(NSInteger)commendCode UserParm:(NSMutableDictionary *)parm withModel:(JWChatMessageModel *)model
{
    if (model) {
        [self.messageModelArray addObject:model];
    }
    [self writeActionWithcommand:commendCode UserParm:parm];
    
}


- (void)readDataFrom:(NSData *)data
{
    if (!data) return;
    
    
    
    if (_readCompleteStatus == readStatusStart) {

        int commentCode;
        
        Byte result[2], lengthBytes[4];
        
        [data getBytes:result length:2];
        
        commentCode = [self bytesToInt:result length:2];
        
        [data getBytes:lengthBytes range:NSMakeRange(2, 4)];
        
        int dataLength = [self bytesToInt:lengthBytes length:4];
        
        NSLog(@"命令：%d---数据包总长度：%d \n",commentCode, dataLength);
        
        if (dataLength <= data.length-6) {
            
            self.responderCode = commentCode;
            if (_responderCode == CS_heartBeatRes ) {//发送心跳包成功
                NSLog(@"接收心跳包");
                return;
            }
            
            Byte dataResponderBytes [dataLength];
            
            [data getBytes:dataResponderBytes range:NSMakeRange(6,dataLength)];
            
            [_tempData  appendBytes:dataResponderBytes length:dataLength];
            
            _readCompleteStatus = readStatusEnd;
            
        }else{
            _responderCode = commentCode;
            
            int recivedLength = data.length-6;
            
            Byte dataResponderBytes [recivedLength];
            
            [_tempData getBytes:dataResponderBytes length:recivedLength];
            
            _tempDataLength = dataLength - recivedLength;
            
            _readCompleteStatus = readStatusReading;

        }
    }else{
        
        int recivedLength = data.length;
        
        Byte dataResponderBytes [recivedLength];
        
        [_tempData getBytes:dataResponderBytes length:recivedLength];
        
        _tempDataLength = _tempDataLength - recivedLength;

        if (_tempDataLength <= 0) {
            
            _readCompleteStatus = readStatusEnd;
        }
    }
    
    if (_readCompleteStatus == readStatusEnd) {
        
        NSString *dataResult = [[NSString alloc]initWithData:_tempData encoding:NSUTF8StringEncoding];

        NSLog(@"收到数据结果：%@",dataResult);

        [self unpackingAnalysis:dataResult];
        
        _readCompleteStatus = readStatusStart;
        
        _tempDataLength = 0;
        
        _tempData  = [[NSMutableData alloc]init];
        
        _responderCode = 0;

    }
    

}


//int 转字节数组
- (void) intToBytes:(int)inputValut byte:(Byte *)src length:(int)length;
{
    for (int i = length-1; i>=0 ; i--) {
        
        src[i] = (Byte)(inputValut&0xFF);
        
        inputValut = inputValut>>8;
    }
}

//字节数组转int
- (int)bytesToInt:(Byte[])b length:(int)length
{
    int result = 0;
    
    for (int i = length-1; i>=0; i--) {
        
            result = result| b[i]<<(length-1-i)*8;
    }
    
    return result;
}

//拆包
- (void)unpackingAnalysis:(id)respond
{
    if (!respond) return;
    NSDictionary *result = [respond JSONValue];
    if (!result) return;
    
     if (_responderCode == CS_taklRes){//发送消息成功
        
        dispatch_main_async_safe(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ChatMessageSendSucessNotice object:result];
        });

        NSString *errorCode = [result objectForKey:@"errorCode"];
        BOOL deleteModel = NO;
        if ([errorCode integerValue] != 0){
            deleteModel = YES;
        }
        
        TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",[User defaultUser].item]];
        
        NSString *checkCode = [result objectForKey:@"checkCode"];
        
        if ([NSObject nulldata:checkCode]) {
            int count = self.messageModelArray.count;
            for (int i = 0 ; i< count; i++) {
                if (i>=0 && i< self.messageModelArray.count ) {
                    JWChatMessageModel *model = _messageModelArray[i];
                    if ([checkCode isEqual:model.time]) {
                     
                        if (!deleteModel) {
                            //判断数据库有数据就更新 没有就添加
                            if ([operationDB theTableIsHavetheData:model._id fromeTable:[NSString stringWithFormat:@"%@%@",ChatDataTableName,[User defaultUser].item.userId]]) {
                                [operationDB upDataObjectInfo:model fromTable:[NSString stringWithFormat:@"%@%@",ChatDataTableName,[User defaultUser].item.userId]];
                            }else{
                                
                                [operationDB insertObjectObject:model fromeTable:[NSString stringWithFormat:@"%@%@",ChatDataTableName,[User defaultUser].item.userId]];
                            }
                        }
                        if ([_messageModelArray containsObject:model]) {
                            [_messageModelArray removeObject:model];
                        }
                        return;
                    }
                }
            }
        }
        return;
    }else if (_responderCode == CS_checkInRes){//登录成功
        
        return;
        
    }else if (_responderCode == CS_messageArrive){//接受消息成功
        

        [self messagesAreReceivedBackToThePackageCommand:CS_messageArriveRes checkCode:result[@"checkCode"]];
        
        TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",[User defaultUser].item]];
        
        JWChatMessageModel *item = [[JWChatMessageModel alloc]initWithDictionary:result];
    
        //保存 信息记录
        [[JWChatDataManager sharedManager]updataUserMessage:item.otherId clean:NO];
        
        //判断数据库有数据就更新 没有就添加
        if ([operationDB theTableIsHavetheData:item._id fromeTable:[NSString stringWithFormat:@"%@%@",ChatDataTableName,[User defaultUser].item.userId]]) {
            [operationDB upDataObjectInfo:item fromTable:[NSString stringWithFormat:@"%@%@",ChatDataTableName,[User defaultUser].item.userId]];
        }else{
            [operationDB insertObjectObject:item fromeTable:[NSString stringWithFormat:@"%@%@",ChatDataTableName,[User defaultUser].item.userId]];
        }
        
        dispatch_main_async_safe(^{
            AudioServicesPlaySystemSound(1307);
            [[NSNotificationCenter defaultCenter]postNotificationName:ChatMessageReceiveNotive object:item];
        });
        return;
        
    }else if (_responderCode == CS_getOldMessageRes){//获取消息记录返回
        if (result) {
            [self saveToSqliteWithDict:result needSave:NO];
            dispatch_main_async_safe(^{
                [[NSNotificationCenter defaultCenter]postNotificationName:ChatMessageHistoreRecordChangedNotice object:nil];
            });
        }
        return;
    }else if (_responderCode == CS_getTalkUsersRes){//获取聊天列表返回
        if (result) {
            NSString *checkCode = [result objectForKey:@"checkCode"];
            if ([NSObject nulldata:checkCode]) {
                if ([checkCode isEqual:ChatReceivedMessageListNotice]) {
                    dispatch_main_async_safe(^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:ChatReceivedMessageListNotice object:result];
                    });
                }
            }
        }
        return;
    }else if (_responderCode == CS_offlineMessage){//收到离线消息回包
       
        AudioServicesPlaySystemSound(1307);

        //回包
        [self messagesAreReceivedBackToThePackageCommand:CS_offlineMessageRes checkCode:result[@"checkCode"]];
        
        //保存至本地数据库
        [self saveToSqliteWithDict:result needSave:YES];
        
        return;
    }
}

#pragma mark ----- 收到包的时候回包

- (void)messagesAreReceivedBackToThePackageCommand:(PackageType)type checkCode:(id)checkCode
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@(0) forKey:@"errorCode"];
    if ([NSObject nulldata:checkCode]) {
        [dict setObject:checkCode forKey:@"checkCode"];
    }else {
        [dict setObject:@"" forKey:@"checkCode"];
    }
    [self writeActionWithcommand:type UserParm:dict];
}


#pragma mark ----- 保存历史纪录到本地数据库

- (void)saveToSqliteWithDict:(NSDictionary *)dict needSave:(BOOL)save
{
    NSString *checkCode = dict[@"checkCode"];
    if ([NSObject nulldata:checkCode]) {
        NSArray *tempArray = dict[@"list"];
        
        TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",[User defaultUser].item]];
        
        if (tempArray) {
            
            if (tempArray.count> 0) {
                
                for (int i = 0 ; i< tempArray.count; i++) {
                    JWChatMessageModel *model = [[JWChatMessageModel alloc]initWithDictionary:tempArray[i]];
                    
                    if (save) {
                        [[JWChatDataManager sharedManager]updataUserMessage:model.otherId clean:NO];
                    }
                    //判断数据库有数据就更新 没有就添加
                    if ([operationDB theTableIsHavetheData:model._id fromeTable:[NSString stringWithFormat:@"%@%@",ChatDataTableName,[User defaultUser].item.userId]]) {
                        [operationDB upDataObjectInfo:model fromTable:[NSString stringWithFormat:@"%@%@",ChatDataTableName,[User defaultUser].item.userId]];
                    }else{
                        
                        [operationDB insertObjectObject:model fromeTable:[NSString stringWithFormat:@"%@%@",ChatDataTableName,[User defaultUser].item.userId]];
                    }
                   
                }
            }
        }
    }
}

@end
