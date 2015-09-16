//
//  JWhttpRequestSerializer.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWhttpRequestSerializer.h"
#import "NSString+BG.h"

@implementation JWhttpRequestSerializer


- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error
{
    
    NSString *newURLString = [URLString urlPathWithCommonStat];
    
    return [super requestWithMethod: method
                          URLString: newURLString
                         parameters: parameters
                              error: error];
}

@end
