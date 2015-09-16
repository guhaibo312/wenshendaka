//
//  CompanyInfoItem.m
//  Bshopkeeper
//
//  Created by jinwei on 15/9/6.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CompanyInfoItem.h"
#import "Configurations.h"

@implementation CompanyInfoItem

- (instancetype)initWithParm:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict) {
            NSDictionary *temp = [NSDictionary dictionaryWithDictionary:[UIUtils filtrationEmptyString:dict]];
            [self setValuesForKeysWithDictionary:temp];
            
            self.startJoin = [dict[@"switch"] boolValue];
        }else{
            self.startJoin = NO;
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}


@end
