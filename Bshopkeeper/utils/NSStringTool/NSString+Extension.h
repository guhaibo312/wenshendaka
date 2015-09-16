//
//  诸葛浩楠
//
//  Created by Tian(tjw)-ios on 14-9-15.
//  Copyright (c) 2014年 田氏集团. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString*)getMD5WithData:(NSData *)data;

+ (NSString *)md5HashFrom:(NSString *)key;


+ (NSString *) stringWithDate: (NSDate*)date;

+ (NSAttributedString *) dateTommdd:(NSString *)date;

+ (NSString *)judgeDataWithmmdd:(NSString *)date;

+(BOOL)isIncludeSpecialCharact:(NSString *)str;

@end
