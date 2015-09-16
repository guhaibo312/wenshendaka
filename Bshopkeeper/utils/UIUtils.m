

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSDataAdditions.h"
#import "NSString+URLEncoding.h"
#import "SFHFKeychainUtils.h"
#import "Utility.h"
#import "Configurations.h"

@implementation UIUtils

//@synthesize userPushToken;
//@synthesize uniqueDeviceToken;

+ (UIUtils *)defaultUIUtils
{
    static UIUtils *uiutils = nil;
    if (uiutils == nil) {
        uiutils = [[UIUtils alloc]init];
       }
    return uiutils;
}
+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    //两种获取document路径的方式
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

NSString* NIPathForBundleResource(NSBundle* bundle, NSString* relativePath) {
    NSString* resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle) resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}

- (NSString*) uniqueDeviceToken {
    
    @synchronized(self) {
        NSString* uniqueDeviceToken = [self __uniqueDeviceToken];
        
        //        NIDPRINT(@"UniqueDeviceToken: ====> %@ <====", uniqueDeviceToken);
        return uniqueDeviceToken;
    }
}

- (NSString*) __uniqueDeviceToken {
    static NSString* kDeviceToken = @"BH_DV_TOKEN";
    static NSString* kServiceName = @"BG_SERVICE";
    
    // 1. 首先读取新的Token
    NSString* tokenV2 = [SFHFKeychainUtils getPasswordForUsernameV2: kDeviceToken
                                                     andServiceName: kServiceName
                                                              error: nil];
    
    // 2.1. 如果读取成功，则返回:
    if ([tokenV2 isNonEmpty]) {
        return tokenV2;
    }
    
    
    // 如果处于Active状态
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        // 生成一个UUID(不是设备相关的)
        NSString* uuid = [Utility getUUID];
        uuid =  [[uuid lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [SFHFKeychainUtils storeUsername: kDeviceToken
                             andPassword: uuid
                          forServiceName: kServiceName
                          updateExisting: YES error: nil];
        
        return uuid;
    } else {
        return @"";
    }
}


- (NSString*) userPushToken {
    if (![self.userPushToken isNonEmpty]) {
        self.userPushToken = [Utility userDefaultObjectForKey: @"user_push_token"];
    }
    
    return self.userPushToken;
}

- (void) setUserPushToken:(NSString *)userPushToken {
    if (![self.userPushToken isEqualToString: userPushToken]) {
        self.userPushToken= userPushToken;
        [Utility setUserDefaultObjects: @{@"user_push_token" :self.userPushToken?self.userPushToken:@""}];
    }
}

//过滤所有NSNull,更改为空字符串
+ (NSMutableDictionary *)filtrationEmptyString:(NSDictionary *)result
{
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSMutableDictionary *resumeDictionary =[[NSMutableDictionary alloc]initWithDictionary:result];
    for (NSString * resumekey in result.allKeys) {
        id resumeStr =[resumeDictionary objectForKey:resumekey];
        
        if ([resumeStr isEqual:[NSNull null]] || [resumeStr isKindOfClass:[NSNull class]] ||resumeStr == nil) {
            [resumeDictionary removeObjectForKey:resumekey];
        }
        if ([resumeStr isKindOfClass:[NSNumber class]]) {
//            resumeStr = [NSString stringWithFormat:@"%@",resumeStr];
            
        }
        
    }
    return resumeDictionary;
}

//+ (NSString *)findNSStringFromName:(NSString *)name
//{
//    NSString *sectionName;
//    if (!name) {
//        return [[NSString stringWithFormat:@"%c",'#'] uppercaseString];
//    }
//    char first=pinyinFirstLetter([name characterAtIndex:0]);
//
//    if ((first>='a'&&first<='z')||(first>='A'&&first<='Z')) {
//        if([self searchResult:name searchText:@"曾"])
//            sectionName = @"Z";
//        else if([self searchResult:name searchText:@"解"])
//            sectionName = @"X";
//        else if([self searchResult:name searchText:@"仇"])
//            sectionName = @"Q";
//        else if([self searchResult:name searchText:@"朴"])
//            sectionName = @"P";
//        else if([self searchResult:name searchText:@"查"])
//            sectionName = @"Z";
//        else if([self searchResult:name searchText:@"能"])
//            sectionName = @"N";
//        else if([self searchResult:name searchText:@"乐"])
//            sectionName = @"Y";
//        else if([self searchResult:name searchText:@"单"])
//            sectionName = @"S";
//        else
//            sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([name characterAtIndex:0])] uppercaseString];
//    }
//    else {
//        sectionName=[[NSString stringWithFormat:@"%c",'#'] uppercaseString];
//    }
//    return sectionName;
//}

/*
 * 时间戳转换成年月日
 **/

+ (NSString *)findKeyFromTimestamp:(double)times
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *result = [formatter stringFromDate:date];
    return result;
}
/*
 *时间戳转换成 2015-04-25 类型的数据
 */
+ (NSString *)timeIntoFomart:(double )times
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *result = [formatter stringFromDate:date];
    return result;
}
/*
 *stinrg  转化为时间戳
 */

+ (NSTimeInterval)timeFromString:(NSString *)timeStr
{
    if (timeStr == nil) {
        return 0;
    }
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateFormat:@"YYYY年MM月dd日"];
    NSDate *date = [format dateFromString:timeStr];
    return [date timeIntervalSince1970];
}
/*
 * 时间戳转换成 小时：分钟
 **/

+ (NSString *)intoMinuteFromTimestamp:(double)times
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *result = [formatter stringFromDate:date];
    return result;
    
}
/**时间戳转化成 月日 时分
 *
 */
+ (NSString*)intoMMDDHHmmFrom:(double)times
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *result = [formatter stringFromDate:date];
    return result;
}

/**时间戳转化成 年－月－日 时：分
 *
 */
+ (NSString*)intoYYYYMMDDHHmmFrom:(double)times
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *result = [formatter stringFromDate:date];
    return result;

}

/*
 *传进来一个字典 return 一个生日的字符串 没有反回空
 **/
+ (NSString *)initWithBirthDayFrom:(NSDictionary *)dict
{
    NSString *birthY =  [NSString stringWithFormat:@"%@",dict[@"birthYear"]];
    NSString *birthM = [NSString stringWithFormat:@"%@",dict[@"birthMonth"]];
    NSString *birthD = [NSString stringWithFormat:@"%@",dict[@"birthDay"]];
    
    if (birthY != nil &&  birthM!= nil && birthD != nil) {
        if (birthM.length < 2) {
            birthM = [NSString stringWithFormat:@"0%@",birthM];
        }
        if (birthD .length <2) {
            birthD = [NSString stringWithFormat:@"0%@",birthD];
        }
        birthY = [NSString stringWithFormat:@"%@",birthY];
        if (birthY.length < 4 || birthM.length <2 || birthD.length <2) {
            return nil;
        }
        NSString *result = [NSString stringWithFormat:@"%@-%@-%@",birthY,birthM,birthD];
        
        return result;
    }
    return nil;
    
}
/*
 * 根据行业的id 反回哪个行业   
 10=>"美甲",
 20=>"美发",
 30=>"纹身",
 40=>"摄影",
 50=>"美容",
 0 =>爱好者

 **/
+ (NSString *)findTypeFrom:(NSDictionary *)dict
{
    
    NSString *typeS = dict[@"sector"];
    if (typeS) {
//        if ([typeS integerValue] == 10) {
//            return @"美甲师";
//        }else if ([typeS integerValue] == 20){
//            return @"美发师";
//        }else if ([typeS integerValue] == 40){
//            return @"摄影师";
//        }else
        if ([typeS integerValue] == 30){
            return @"纹身师";
        }else if ([typeS integerValue] == 0){
            return @"爱好者";
        }else {
            return @"爱好者";
        }
    }
    return @"爱好者";
}
/*根据订单的编号返回状态
 //1:用户点取消;2:商家点取消;4:等用户确认;7:等用商家确认;10:已确认11:商家强行确认;20:已完成
 */
+ (NSString *)findOrderStatusFromCode:(int)code withTime:(NSString *)orderTime
{
    NSString *timeOut= @"";
    NSTimeInterval currentTime = [[NSDate date]timeIntervalSince1970];
    
    if (orderTime) {
        NSTimeInterval orderNumber = [orderTime doubleValue]/1000;
        if (orderNumber < currentTime && (code == 4 || code== 7 || code == 10 || code ==11)) {
            timeOut = @"已过期";
            return timeOut;
        }
    }
    if (code == 1) {
        return @"已取消";
    }else if (code == 2){
        return @"已取消";
    }else if (code == 4){
        return @"待接受";
    }else if (code == 7){
        return @"待接受";
    }else if (code == 10){
        return @"待消费";
    }else if (code == 11){
        return @"待消费";
    }else if (code == 14){
        return @"已拒绝";
    }else {
        return @"已完成";
    }

}

+ (BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}

/*
 *根据文字获取 所占大小
 */
+ (float)getSizeWithString:(NSString *)contentString withfont:(float)sizeFont
{
    float sizeOfWhide = 0 ;
    if (!contentString) {
        return 0;
    }
    if (IS_IOS7) {
        sizeOfWhide = [contentString boundingRectWithSize:CGSizeMake(200, 40) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:sizeFont]} context:nil].size.width;
    }else{
        sizeOfWhide = [contentString sizeWithFont:[UIFont systemFontOfSize:sizeFont] constrainedToSize:CGSizeMake(200, 40) lineBreakMode:NSLineBreakByWordWrapping].width;
        
    }
    return sizeOfWhide +30;
    
}

/**获取价格的单位 0:'元',1:'元/套',2:'元/天',3:'元/次',4:'元/张'
 
 **/
+ (NSString *)getQuitFrom:(int)quit
{
    if (quit == 0) {
        return @"元";
    }else if (quit == 1){
        return @"元/套";
    }else if (quit == 2){
        return @"元/天";
    }else if (quit == 3){
        return @"元/次";
    }else if (quit == 4){
        return @"元/张";
    }else{
        return @"元";
    }
}

/*获取文字的高度宽度 根据固定的宽高 返回 size
 *
 **/
+ (CGSize)getSizeFromString:(NSString *)contentString font:(float)sizeFont conttentSize:(CGSize)maxSize
{
    CGSize resultSize;
    if (IS_IOS7) {
        resultSize = [contentString boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:sizeFont]} context:nil].size;
    }else{
        resultSize = [contentString sizeWithFont:[UIFont systemFontOfSize:sizeFont] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];

    }
    return resultSize;
}


- (void)shakeAnimation:(UIView *)sender
{
    if (!sender) return;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath  = @"position.x";
    animation.values   = @[ @0, @15, @-15, @15, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.3;
    animation.additive = YES;
    animation.repeatCount = 2;
    [sender.layer addAnimation:animation forKey:@"shake"];
}



@end
@implementation UIImage(tint)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
@end