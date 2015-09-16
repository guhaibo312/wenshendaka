//
//  NSString+URLEncoding.h
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>


@interface NSNull (SymptomChecker)
@end

@interface NSString (SymptomChecker)



// URL编码和解码
- (NSString*) URLEncodedString;
- (NSString*) URLDecodedString;

// 空白字符的处理
- (BOOL)isNonEmpty;
- (NSString*) trimSpace;
- (NSString*) trimCharacters;
- (NSString*) trimEnglishLetters;


- (id) mutableObjectFromJSONString;
- (id) objectFromJSONString;

// JSON的处理


+ (NSString*) formatDistance:(CGFloat) distance;
+ (NSString*) formatPhoneNum: (NSString*) phoneNum;
+ (NSString*) formatEmail: (NSString*) email;

/**提取图片的大小 参数默认大小 有返回实际大小 没有返回默认大小
 */
- (CGSize)imageUrlSizeWithTheOriginalSize:(CGSize)originalSize;


- (BOOL) isVailidEmailAddress;

- (NSString *) stringByEscape: (BOOL) escape
                  escapeMinus: (BOOL) escapeMinus
          isTTStyledTextLabel: (BOOL) isTTStyledTextLabel;

///////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
@property (nonatomic, readonly) NSString* md5Hash;

/**
 * Calculate the SHA1 hash of this string using CommonCrypto CC_SHA1.
 *
 * @return NSString with SHA1 hash of this string
 */
@property (nonatomic, readonly) NSString* sha1Hash;

@end
