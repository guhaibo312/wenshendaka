//
//  DataDBManage.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "DataDBManage.h"

static DataDBManage *dataManage = nil;

@implementation DataDBManage

+ (id)initWithDataBaseName:(NSString *)name
{
    if (dataManage == nil) {
        dataManage = [[DataDBManage alloc]init];
    }
    if (dataManage) {
        if (name) {
            NSString *docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *dbPath = [docp stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",name]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:dbPath]) {
            }else{
                NSLog(@"不存在数据库");
            }
            if (dataManage.dataBase == nil) {
                dataManage.dataBase = [[FMDatabase alloc] initWithPath:dbPath];
            }
            if (![dataManage.dataBase open]) {
                NSLog(@"不能打开数据库");
            }

        }
    }
    return dataManage;
    
}



@end
