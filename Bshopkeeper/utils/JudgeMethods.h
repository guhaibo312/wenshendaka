

#import <Foundation/Foundation.h>

@interface JudgeMethods : NSObject

@property (nonatomic, assign) NSMutableArray *glArray;
@property (nonatomic, assign) NSMutableArray *nlArray;

@property (nonatomic, strong)NSMutableDictionary *cityListDict;

@property (nonatomic, strong) NSMutableDictionary *areaListDict;


@property (nonatomic, assign) BOOL showimageNotice;

@property (nonatomic, assign) BOOL showSquareNotice;

@property (nonatomic, assign) BOOL showSystemNotice;

@property (nonatomic, assign) BOOL showOrderNotice;

@property (nonatomic, assign) BOOL showKefuMessage;

@property (nonatomic, assign) int kefuMessageCount;


- (NSString *)getCurrentCityName;

- (NSString *)getOtherCityName:(NSString *)city province:(NSString *)province;


- (void)getNotice:(NSDictionary *)dict;


//初始化方
+ (JudgeMethods *)defaultJudgeMethods;

//判断是不是纯数字
- (BOOL)passWordIsPurelyDigital:(NSString *)str;


//判断是否是纯字母
- (BOOL)passWordIsPureLetter:(NSString *)str;


//判断是不是大陆手机号
- (BOOL)contentTextIsPhoneNumber:(NSString *)str;


//判断是不是邮箱
- (BOOL)contentTextIsEmail:(NSString *)string;

//判断是不是雅虎邮箱
- (BOOL)theEmailIsYahooEmail:(NSString *)string;

/*
 *判断密码 没有问题返回yes
 *@password 输入密码
 */
- (BOOL)thePasswordIsNotAvailable:(NSString *)password;

/*
 *html标签处理
 */
-(NSString *)filterHTML:(NSString *)html isTheNative:(BOOL)isNative;


/*判断在本周内是否过生日
 **/
- (BOOL)currentWeekIsBirthdayFromeBirthMonth:(NSInteger)month birthDay:(NSInteger)day islunar:(BOOL)lunar;

/*获取阴历的月份
 **/
+ (NSString *)getLunarMonth:(NSInteger)month;

/*获取阴历的日
 **/
+ (NSString *)getLunarDay:(NSInteger)day;

@end
