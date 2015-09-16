//
//  Utility.m
//  BeautifulGirls
//
//  Created by suning on 14-10-5.
//  Copyright (c) 2014年 BestBoys. All rights reserved.
//

#import "Utility.h"


static NSMutableDictionary* urlSpecialChars = nil;

@implementation Utility

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)getLabelHeightWithWidth:(CGFloat)width
						   andText:(NSString *)text
					   andFontSize:(CGFloat)fontSize {
	static UILabel * label = nil;
	if ( label==nil ) {
		label = [[UILabel alloc] initWithFrame:CGRectZero];
	}
    
    
    label.font = [UIFont systemFontOfSize: fontSize];
    label.frame = CGRectMake(0, 0, width, 0);
    label.numberOfLines = 0;
    
    label.text = text;
    [label sizeToFit];
    
    return label.height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat) getLabelHeightWithWidth:(CGFloat)width andText:(NSString *)text andFont:(UIFont*)font{
    static UILabel* label = nil;
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    
    label.font = font;
    label.frame = CGRectMake(0, 0, width, 0);
    label.numberOfLines = 0;
    
    label.text = text;
    [label sizeToFit];
    
    return label.height;
}

+ (CGFloat) getLabelWidthText:(NSString *)text andFont:(UIFont*)font{
    static UILabel* label = nil;
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    
    label.font = font;
    label.frame = CGRectMake(0, 0, 0, 0);
    label.numberOfLines = 1;
    
    label.text = text;
    [label sizeToFit];
    
    return label.width;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getDocumentPath {
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getFilePath:(NSString *)fileName {
	NSString * documentPath = [self getDocumentPath];
	return [documentPath stringByAppendingPathComponent:fileName];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)escapeURL:(NSString *)url {
	// Construct HashMap
	if (urlSpecialChars == nil ) {
        // TODO: 静态变量是否会出现内存泄露？
        urlSpecialChars = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           @"%22", @"\"",
                           @"%3C", @"<",
                           @"%3E", @">",
                           @"%5C", @"\\",
                           @"%5E", @"^",
                           @"%5B", @"[",
                           @"%5D", @"]",
                           @"%60", @"`",
                           @"%2B", @"+",
                           @"%24", @"$",
                           @"%2C", @",",
                           @"%40", @"@",
                           @"%3A", @":",
                           @"%3B", @";",
                           @"%2F", @"/",
                           @"%21", @"!",
                           @"%23", @"#",
                           @"%3F", @"?",
                           @"%3D", @"=",
                           @"%26", @"&",
                           nil
                           ];
	}
    
	NSMutableString * str1 = [NSMutableString stringWithCapacity:0];
	[str1 appendString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableString * str2 = [NSMutableString stringWithCapacity:0];
    
	// 遍历str1中的每一个字符，并且进行可能的替换
	NSInteger str1Len = [str1 length];
	NSRange range;
	range.length = 1;
    
    // NSLog(@"Utility#escapeURL, Before Escape: %@", str1);
	for (int i = 0; i < str1Len; ++i) {
		range.location = i;
        NSString* key = [str1 substringWithRange:range];
        
        // NSLog(@"Utility#escapeURL, Key: %@", key);
        
        //"@"比较特殊
        // Use objectForKey instead of valueForKey to avoid KeyValueConversion, in which case "@" is for special use
		NSString* subStr = [urlSpecialChars objectForKey:key];
        // NSLog(@"Utility#escapeURL, Value: %@", subStr);
        
		if (subStr != nil)
			[str2 appendString:subStr];
		else
			[str2 appendString:key];
	}
    // NSLog(@"Utility#escapeURL, After Escape: %@", str2);
	return str2;
}

+ (NSDate*) dateWithFormatter:(NSString*) formatter time:(NSString*) time {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter dateFromString: time];
}

// 例如: @"yyyy-MM-dd"
//
+ (NSString*) stringWithFormatter:(NSString*) formatter time:(NSDate*) date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate: date];
}

+ (id)userDefaultObjectForKey:(NSString *)key {
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    return [info objectForKey:key];
}

+ (void)setUserDefaultObjects:(NSDictionary *)dict {
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [info setObject:obj forKey:key];
    }];
    [info synchronize];
}

//
// 不是设备Id, 每次都成圣一个全球唯一的字符串
//
+ (NSString*) getUUID {
    
    static NSString *UUIDString = nil;
    if (UUIDString) {
        return UUIDString;
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        UUIDString = [[NSUUID UUID] UUIDString];
    } else {
        CFUUIDRef UUID = CFUUIDCreate(NULL);
        UUIDString = CFBridgingRelease(CFUUIDCreateString(NULL, UUID));
    }
    
    UUIDString = [UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (!UUIDString) {
        return @"";
    } else {
        return UUIDString;
    }
}
//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end
