//
//  NSObject+JWObjectNull.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/19.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "NSObject+JWObjectNull.h"

@implementation NSObject (JWObjectNull)

+(BOOL)nulldata:(id)object
{
    if ([object isEqual:[NSNull null]]) return NO;
    
    if (!object) return NO;
    
    if (object == nil || object == NULL || object == Nil) return NO;

    if ([object isKindOfClass:[NSNull class]])   return NO;
    
    if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]])return YES;
    if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) return YES;

    NSString *result = object;
    if (![object isKindOfClass:[NSString class]]) {
        result = [NSString stringWithFormat:@"%@",object];
    }
    
    if (!result.length) return NO;
    
    if (result.length <1)  return NO;
    
    if ([result isEqual:[NSNull null]]) return NO;
    
    if ([result isEqualToString:@"<null>"])  return NO;
    
    if ([[result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)         return NO;
    
    return YES;
}
@end
