//
//  NSString+URLEncoding.m
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "NSString+URLEncoding.h"
#import "NSDataAdditions.h"

@implementation NSNull (SymptomChecker)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isNonEmpty {
    return NO;
}

@end

@implementation NSString (SymptomChecker)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)URLEncodedString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
	return result;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)URLDecodedString {
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8));
	return result;
}

static NSMutableCharacterSet* emptyStringSet = nil;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isNonEmpty {
    if (emptyStringSet == nil) {
        emptyStringSet = [[NSMutableCharacterSet alloc] init];
        [emptyStringSet formUnionWithCharacterSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [emptyStringSet formUnionWithCharacterSet: [NSCharacterSet characterSetWithCharactersInString: @"　"]];
    }

    if ([self length] == 0) {
        return NO;
    }

    NSString* str = [self stringByTrimmingCharactersInSet:emptyStringSet];
    return [str length] > 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*) trimSpace {

    if (emptyStringSet == nil) {
        emptyStringSet = [[NSMutableCharacterSet alloc] init];
        [emptyStringSet formUnionWithCharacterSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [emptyStringSet formUnionWithCharacterSet: [NSCharacterSet characterSetWithCharactersInString: @"　"]];
    }

    return [self stringByTrimmingCharactersInSet: emptyStringSet];
}

- (NSString*) trimCharacters {
    NSCharacterSet *charactersSet = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    return [self stringByTrimmingCharactersInSet: charactersSet];
}

- (NSString*) trimEnglishLetters {
    NSCharacterSet *charactersSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"];
    return [self stringByTrimmingCharactersInSet: charactersSet];
}

//
// 将当前字符串解析成为JSON对象(至少容器，即最外层对象为Mutable。最外层对象可能是NSMutableDictionary, 或NSMutableArray)
//
- (id) mutableObjectFromJSONString {
    return [NSJSONSerialization JSONObjectWithData: [self dataUsingEncoding: NSUTF8StringEncoding]
                                           options: NSJSONReadingMutableContainers
                                             error: nil];
}
- (id) objectFromJSONString {
    return [NSJSONSerialization JSONObjectWithData: [self dataUsingEncoding: NSUTF8StringEncoding]
                                           options: 0
                                             error: nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*) formatDistance:(CGFloat) distance {
    if (distance < 1000) {
        NSInteger range = (NSInteger)(distance / 100 + 0.5) * 100;
        if (range == 0) {
            range = 100;
        }
        return [NSString stringWithFormat:@"%d米内", range];

    } else {
        return [NSString stringWithFormat:@"%.1f千米", distance / 1000.0];
    }
}


-(BOOL)isNothing
{
    
    if (!self) {
        return NO;
    }
    
    if (self == nil || self == NULL || self == Nil) {
        return NO;
    }
   
    if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    NSString *result = self;
    if (![self isKindOfClass:[NSString class]]) {
        result = [NSString stringWithFormat:@"%@",self];
    }
    if (!result.length) {
        return NO;
    }
    if (result.length <1) {
        return NO;
    }
    if ([self isEqual:[NSNull null]]) {
        return NO;
    }

    if ([self isEqualToString:@"<null>"]) {
        return NO;
    }
    
    if ([[result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return NO;
    }
   
    return YES;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*) formatPhoneNum: (NSString*) phoneNum {
    NSString* model = [UIDevice currentDevice].model;
    if ([model rangeOfString:@"iPhone"].length > 0) {
        return [NSString stringWithFormat:@"<a href=\"tel:%@\">%@</a>", phoneNum, phoneNum];

    } else {
        return phoneNum;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*) formatEmail: (NSString*) email {
    return [NSString stringWithFormat:@"<a href=\"mailto:%@\">%@</a>", email, email];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isVailidEmailAddress {
    
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject: self];
    
}

- (NSString *) stringByEscape: (BOOL) escape
                  escapeMinus: (BOOL) escapeMinus
          isTTStyledTextLabel: (BOOL) isTTStyledTextLabel
{
    NSString * str = self;
    
    if (isTTStyledTextLabel) {
        
        if (escape) {
            str = [str stringByReplacingOccurrencesOfString: @"&lt;" withString: @"<"];
            str = [str stringByReplacingOccurrencesOfString: @"&amp;" withString: @"&"];
        } else {
            str = [str stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;"];
            if (escapeMinus) {
                str = [str stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
            }
        }
    }
    
    if (escape) {
        str = [str stringByReplacingOccurrencesOfString: @"\\" withString: @"\\\\"];
        str = [str stringByReplacingOccurrencesOfString: @"\r" withString: @"."];
        str = [str stringByReplacingOccurrencesOfString: @"\n" withString: @"."];
        str = [str stringByReplacingOccurrencesOfString: @"\f" withString: @" "];
        str = [str stringByReplacingOccurrencesOfString: @"\t" withString: @" "];
        str = [str stringByReplacingOccurrencesOfString: @"\"" withString: @"\\\""];
        str = [str stringByReplacingOccurrencesOfString: @"\x08" withString: @" "];
        
        // Construct HashMap
        NSDictionary * urlSpecialChars = [[NSDictionary alloc] initWithObjectsAndKeys:
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
        
        
        for (NSString * key in urlSpecialChars) {
            str = [str stringByReplacingOccurrencesOfString: key withString: [urlSpecialChars objectForKey: key]];
        }
    } else {
        for (int i = 0; i < 32; ++i) {
            str = [str stringByReplacingOccurrencesOfString: [NSString stringWithFormat: @"%c", i]
                                                 withString: @" "];
        }
        str = [str stringByReplacingOccurrencesOfString: [NSString stringWithFormat: @"%c", 127]
                                             withString: @" "];
    }
	return str;
}

/**提取图片的大小 参数默认大小 有返回实际大小 没有返回默认大小
 */
- (CGSize)imageUrlSizeWithTheOriginalSize:(CGSize)originalSize
{
    if (![self isNothing]) {
        return originalSize;
    }
    
    
    NSString *sizeStr = [[self componentsSeparatedByString:@"_"]lastObject];
    if ([sizeStr rangeOfString:@"X"].location != NSNotFound) {
        NSString *regex = @"[0-9]{2,}X[0-9]{2,}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL result = [pred evaluateWithObject:sizeStr];
        if (result) {
            NSArray *tempAr = [sizeStr componentsSeparatedByString:@"X"];
            float imgWidth = [[tempAr firstObject ]floatValue];
            float imgHeight = [[tempAr lastObject ]floatValue];
            if (imgWidth != 0 && imgHeight!= 0) {
                return CGSizeMake(originalSize.width,imgHeight/(imgWidth/originalSize.width));
            }else{
                return originalSize;
            }
        }else{
            return originalSize;
        }

    }else{
        return originalSize;
    }

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)sha1Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
}

@end
