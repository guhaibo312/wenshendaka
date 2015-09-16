

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIUtils;

@interface UIUtils : NSObject

#define RGBCOLOR_HEX(hexColor) [UIColor colorWithRed: (((hexColor >> 16) & 0xFF))/255.0f         \
green: (((hexColor >> 8) & 0xFF))/255.0f          \
blue: ((hexColor & 0xFF))/255.0f                 \
alpha: 1]



+ (UIUtils *)defaultUIUtils ;

/**
 *获取documents下的文件路径
 */
+ (NSString *)getDocumentsPath:(NSString *)fileName;

/*
 *根据颜色返回图片
 **/
+ (UIImage *)imageFromColor:(UIColor *)color;

NSString* NIPathForBundleResource(NSBundle* bundle, NSString* relativePath);

@property (nonatomic, strong) NSString *uniqueDeviceToken;
@property (nonatomic, strong) NSString *userPushToken;

// 过滤字符串
+ (NSMutableDictionary *)filtrationEmptyString:(NSDictionary *)result;


///*
// *寻找字符串的第一个字母排序
// **/
//+ (NSString *)findNSStringFromName:(NSString *)name;

/*
 * 时间戳转换成年月日
 **/

+ (NSString *)findKeyFromTimestamp:(double)times;

/*
 *时间戳转换成 2015-04-25 类型的数据
 */
+ (NSString *)timeIntoFomart:(double )times;

/*
 *stinrg  转化为时间戳
 */

+ (NSTimeInterval)timeFromString:(NSString *)timeStr;

/** 时间戳转换成 小时：分钟
 **/

+ (NSString *)intoMinuteFromTimestamp:(double)times;

/*
 *时间戳转化成 月日 时分
 **/
+ (NSString*)intoMMDDHHmmFrom:(double)times;

/**时间戳转化成 年－月－日 时：分
 *
 */
+ (NSString*)intoYYYYMMDDHHmmFrom:(double)times;

/*
 *传进来一个字典 return 一个生日的字符串 没有反回空
 **/
+ (NSString *)initWithBirthDayFrom:(NSDictionary *)dict;

/*
 * 根据行业的id 反回哪个行业
 **/
+ (NSString *)findTypeFrom:(NSDictionary *)dict;


/*根据订单的状态的编号 和时间 返回状态
 */
+ (NSString *)findOrderStatusFromCode:(int)code withTime:(NSString *)orderTime;

/*
 *获取文字的宽度
 */
+ (float)getSizeWithString:(NSString *)contentString withfont:(float)sizeFont;

/*获取文字的高度宽度 根据固定的宽高 返回 size
 *
 **/
+ (CGSize)getSizeFromString:(NSString *)contentString font:(float)sizeFont conttentSize:(CGSize)maxSize;

/**获取价格的单位 0:'元',1:'元/套',2:'元/天',3:'元/次',4:'元/张'

 **/
+ (NSString *)getQuitFrom:(int)quit;


- (void)shakeAnimation:(UIView *)sender;


@end


@interface UIImage (tint)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

@end
