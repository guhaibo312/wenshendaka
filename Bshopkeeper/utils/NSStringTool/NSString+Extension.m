//
//  诸葛浩楠
//
//  Created by Tian(tjw)-ios on 14-9-15.
//  Copyright (c) 2014年 田氏集团. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonCrypto.h>
#import "NSString+URLEncoding.h"

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    if (!self|| self == NULL ||self == nil ) {
        return CGSizeMake(0, 0);
    }
    return [self boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading   attributes:attrs context:nil].size;
}

+(BOOL)isIncludeSpecialCharact:(NSString *)str
{
    
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    
    if (urgentRange.location == NSNotFound)
        
    {
        
        return NO;
        
    }
    
    return YES;
    
}


+ (NSString*)getMD5WithData:(NSData *)data{
    
       // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(data.bytes, data.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return [output lowercaseString];
    
    
    
}

+ (NSString *)md5HashFrom:(NSString *)key
{
    if (!key) {
        return nil;
    }
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return filename;
}

+ (NSString *) stringWithDate: (NSDate*)date
{
    NSInteger time = 0 - [date timeIntervalSinceNow];
    
    if (time <= 120) {
        //2 分钟以内
        return @"刚刚";
    } else if (time <= 60*60) {
        
        // 1小时以内
        return [NSString stringWithFormat: @"%d分钟前", time/60];
    } else if (time/(60*60)<24) {
        
        // 当天以内
        return [NSString stringWithFormat: @"%d小时前", time/3600];
    } else if (time/(60*60)<24*2) {
        
        // 昨天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        return [NSString stringWithFormat: @"昨天 %@", [formatter stringFromDate: date]];
    } else {
        
        // 几月几日
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd";
        return [formatter stringFromDate: date];
    }
}

+ (NSAttributedString *) dateTommdd:(NSString *)date
{
    NSString *result = [NSString judgeDataWithmmdd:date];
    if (!result) return nil;
    NSDateFormatter *todayFormatter = [[NSDateFormatter alloc]init];
    [todayFormatter setDateFormat:@"dd-MM"];
    NSString *todayResult = [todayFormatter stringFromDate:[NSDate date]];
    if ([todayResult isEqualToString:result]) {
        return [[NSMutableAttributedString alloc]initWithString:@"今天" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    }
    
    NSArray *compareArr = [result componentsSeparatedByString:@"-"];
    if (compareArr.count<1)return nil;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:compareArr[0] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [attributeStr appendAttributedString:[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@月",[compareArr lastObject]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
    return attributeStr;    
}

+ (NSString *)judgeDataWithmmdd:(NSString *)date
{
    if (!date) return  nil;
    double createtime = [date doubleValue];
    
    if (createtime >9999999999) {
        createtime = createtime/1000;
    }
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:createtime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MM";
    [formatter stringFromDate:date1];
    NSString *result = [formatter stringFromDate:date1];
    return result;
}


@end
