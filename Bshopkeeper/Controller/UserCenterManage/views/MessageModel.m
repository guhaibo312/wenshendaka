//
//  MessageModel.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/9.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

+ (id)messageModelWithDict:(NSDictionary *)dict
{
    MessageModel *message = [[self alloc] init];
    [message setValuesForKeysWithDictionary:dict];
    
    return message;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
