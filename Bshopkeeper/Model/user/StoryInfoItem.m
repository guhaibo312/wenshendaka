//
//  StoryInfoItem.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/12.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "StoryInfoItem.h"
#import "Configurations.h"

@implementation StoryInfoItem


- (void)setValuesForSlef:(NSDictionary *)dict;
{
    if (dict) {
        NSDictionary *temp = [NSDictionary dictionaryWithDictionary:[UIUtils filtrationEmptyString:dict]];
        [self setValuesForKeysWithDictionary:temp];
        self.cdescription = temp[@"description"];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}


@end
