//
//  DataBaseObject.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "DataBaseObject.h"

@implementation DataBaseObject

- (NSMutableDictionary *)dataInitialization
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    return dict;
}

- (NSString *)upDataObjectInfo
{
    NSMutableString *string = [NSMutableString string];
    return string;
}

- (id)initWithFMResult:(FMResultSet *)rt
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
