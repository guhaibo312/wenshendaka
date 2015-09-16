

#import "JudgeMethods.h"
#import <UIKit/UIKit.h>
#import "Configurations.h"


@implementation JudgeMethods

static JudgeMethods *judgeMethods = nil;

//初始化方法
+ (JudgeMethods *)defaultJudgeMethods
{
    if (judgeMethods == nil) {
        judgeMethods = [[JudgeMethods alloc]init];
//        judgeMethods.glArray = [NSMutableArray array];
//        judgeMethods.nlArray = [NSMutableArray array];
//        
//        NSArray *currentWeek = [NSArray arrayWithArray:[judgeMethods getCurrentWeekDay]];
//        for (int i = 0 ; i< currentWeek.count; i++) {
//            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//            [formater setDateFormat:@"MM-dd"];
//            [judgeMethods.glArray addObject:[formater stringFromDate:currentWeek[i]]];
//            [judgeMethods.nlArray addObject:[judgeMethods LunarForSolar:currentWeek[i]]];
        //     NSString *file = [[NSBundle mainBundle] pathForResource:@"category" ofType:@"json"];
        NSString *file = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
        NSError *error = nil;
        NSDictionary * AdataTemp = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:file ] options:kNilOptions error:&error];
        if (AdataTemp) {
            judgeMethods.cityListDict = [NSMutableDictionary dictionaryWithDictionary:AdataTemp];
        }
        file = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"txt"];
        AdataTemp = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:file] options:kNilOptions error:&error];
        if (AdataTemp) {
            judgeMethods.areaListDict = [NSMutableDictionary dictionaryWithDictionary:AdataTemp];
        }
        
    }
    return judgeMethods;
}

- (NSString *)getCurrentCityName
{
    NSString *cityKey =[NSString stringWithFormat:@"%@",[User defaultUser].item.city];
    NSString *areaKey = [NSString stringWithFormat:@"%@",[User defaultUser].item.area];
    
    if ( !self.areaListDict || ![NSObject nulldata:cityKey] || ![NSObject nulldata:areaKey]) return nil;
    
    id areaList = [self.areaListDict objectForKey:cityKey];
    if (areaList) {
        return [areaList objectForKey:areaKey];
    }
    return nil;
}

- (NSString *)getOtherCityName:(NSString *)city province:(NSString *)province
{
    city = [NSString stringWithFormat:@"%@",city];
    province = [NSString stringWithFormat:@"%@",province];
    if (![NSObject nulldata:city] && ![NSObject nulldata:province ]) return nil;
        
    id cityList = [self.cityListDict objectForKey:province];
    if (cityList) {
        return [cityList objectForKey:city];
    }
    return nil;

}

- (void)getNotice:(NSDictionary *)dict
{
    if (dict) {
        NSString *position = dict[@"position"];
        if (position) {
            position = [position lowercaseString];
            if ([position isEqualToString:@"order"]) {
                self.showOrderNotice = YES;
            }else if ([position isEqualToString:@"notice"]){
                self.showSystemNotice = YES;
            }else if ([position isEqualToString:@"message"]){
                self.showSquareNotice = YES;
            }
        }
    }
    
}


//判断是不是纯数字
- (BOOL)passWordIsPurelyDigital:(NSString *)str
{
    NSString *passWordStr = str;
    for (int i = 0; i< passWordStr.length; i++) {
        char letter = [passWordStr characterAtIndex:i];
        if (letter < '0' || letter >'9') {
            return NO;
        }
    }
    return YES;
}


//判断是否是纯字母
- (BOOL)passWordIsPureLetter:(NSString *)str
{
    NSString *passWordStr = str;
    for (int i = 0 ; i< passWordStr.length; i++) {
        char letter = [passWordStr characterAtIndex:i];
        if ((letter >= 'A' && letter <= 'Z') || (letter >= 'a' && letter <= 'z')) {
            continue;
        }else{
            return NO;
        }
    }
    return YES;
}


//判断是不是大陆手机号
- (BOOL)contentTextIsPhoneNumber:(NSString *)str
{
    if (str == nil) {
        return NO;
    }
//    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
//    NSString *regex = @"[0-9]+X+[0-9]]";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL result = [pred evaluateWithObject:str];
    
    if (str.length != 11 || [str characterAtIndex:0]!= '1') {
        return NO;
    }
    return YES;
}


//判断是不是邮箱
- (BOOL)contentTextIsEmail:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isEmail = [pre evaluateWithObject:string];
    return isEmail;
}

//判断是不是雅虎邮箱
- (BOOL)theEmailIsYahooEmail:(NSString *)string
{
    if ([string rangeOfString:@"@yahoo"].location != NSNotFound) {
        return NO;
    }
    return YES;
}

/*
 *判断密码 没有问题返回yes
 *@password 输入密码
 */
- (BOOL)thePasswordIsNotAvailable:(NSString *)password
{
    if (password == nil) {
        [self showAlertView:@"密码不能为空"];
        return NO;
    }
    
    if (password.length < 1) {
        [self showAlertView:@"密码不能为空"];
        return NO;
    }
    if (password.length < 6) {
        [self showAlertView:@"密码长度不能少于6位"];
        return NO;
    }
    if([self passWordIsPureLetter:password]){
        [self showAlertView:@"密码不能为纯字母"];
        return NO;
    }
    if ([self passWordIsPurelyDigital:password]) {
        [self showAlertView:@"密码不能为纯数字"];
        return NO;
    }
    return YES;
}
/*
 *html标签处理
 */
-(NSString *)filterHTML:(NSString *)html isTheNative:(BOOL)isNative
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        if (isNative) {
            //找到标签的起始位置
            [scanner scanUpToString:@"<" intoString:nil];
            //找到标签的结束位置
            [scanner scanUpToString:@">" intoString:&text];
            //替换字符
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        }else{
            //找到标签的起始位置
            [scanner scanUpToString:@"&lt" intoString:nil];
            //找到标签的结束位置
            [scanner scanUpToString:@"&gt" intoString:&text];
            //替换字符
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",text] withString:@""];

        }
    }
    return html;
}

/*判断在本周内是否过生日
 **/
- (BOOL)currentWeekIsBirthdayFromeBirthMonth:(NSInteger)month birthDay:(NSInteger)day islunar:(BOOL)lunar
{
    if (lunar) {
        NSString *needJudgeBirthDay = [NSString stringWithFormat:@"%@%@",[JudgeMethods getLunarMonth:month],[JudgeMethods getLunarDay:day]];
        return [self.nlArray containsObject:needJudgeBirthDay];
    }else{
        
        NSString *monStr = [NSString stringWithFormat:@"%d",month];
        NSString *dayStr = [NSString stringWithFormat:@"%d",day];
        if (month < 10) {
            monStr = [NSString stringWithFormat:@"0%d",month];
        }
        if (day <10) {
            dayStr = [NSString stringWithFormat:@"0%d",day];
        }
        NSString *needJudgeBirthDay = [NSString stringWithFormat:@"%@-%@",monStr,dayStr];
        return [self.glArray containsObject:needJudgeBirthDay];
    }
    
    return NO;
}

//获取当前的周
- (NSMutableArray *)getCurrentWeekDay
{
    NSMutableArray *resultA = [[NSMutableArray alloc]init];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day1 = [comp day];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff=0;
    if (weekDay == 1) {
        firstDiff = 1;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
    }
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [firstDayComp setDay:day1 + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    [resultA addObject:firstDayOfWeek];
    
    for (int i = 1 ; i< 7; i++) {
        
        NSDateComponents *tempC = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
        [tempC setDay:day1 + firstDiff+ i];
        NSDate *tempD= [calendar dateFromComponents:tempC];
        [resultA addObject:tempD];
    }
    
//    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
//    [lastDayComp setDay:day1 + lastDiff];
//    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
//    
//    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
//    NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
    return resultA;
}

//农历转换函数

-(NSString *)LunarForSolar:(NSDate *)solarDate{
    
//    //天干名称
//    
//    NSArray *cTianGan = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸", nil];
//    
//    //地支名称
//    NSArray *cDiZhi = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
//
//    //属相名称
//    NSArray *cShuXiang = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
    
    //农历日期名
    NSArray *cDayName = [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                         
                         @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                         
                         @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName = [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    //公历每月前面的天数
    
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static int wCurYear,wCurMonth,wCurDay;
    
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //取当前公历年、月、日
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:solarDate];
    
    wCurYear = [components year];
    
    wCurMonth = [components month];
    
    wCurDay = [components day];
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    
    nIsEnd = 0;
    
    m = 0;
    
    while(nIsEnd != 1)
        
    {
        
        if(wNongliData[m] < 4095)
            
            k = 11;
        
        else
            
            k = 12;
        
        n = k;
        
        while(n>=0)
            
        {
            
            //获取wNongliData(m)的第n个二进制位的值
            
            nBit = wNongliData[m];
            
            for(i=1;i<n+1;i++)
                
                nBit = nBit/2;
            nBit = nBit % 2;
            if (nTheDate <= (29 + nBit))
                
            {
                
                nIsEnd = 1;
                
                break;
                
            }
            nTheDate = nTheDate - 29 - nBit;
            
            n = n - 1;
            
        }
        
        if(nIsEnd)
            
            break;
        
        m = m + 1;
        
    }
    
    wCurYear = 1921 + m;
    
    wCurMonth = k - n + 1;
    
    wCurDay = nTheDate;
    
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            
            wCurMonth = 1 - wCurMonth;
        
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            
            wCurMonth = wCurMonth - 1;
    }
    
    //生成农历天干、地支、属相
//    NSString *szShuXiang = (NSString *)[cShuXiang objectAtIndex:((wCurYear - 4) % 60) % 12];

//    NSString *szNongli = [NSString stringWithFormat:@"%@(%@%@)年",szShuXiang, (NSString *)[cTianGan objectAtIndex:((wCurYear - 4) % 60) % 10],(NSString *)[cDiZhi objectAtIndex:((wCurYear - 4) % 60) % 12]];
    
    //生成农历月、日
    NSString *szNongliDay;
    
    if (wCurMonth < 1){
        
        szNongliDay = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]]; 
    }else{
        szNongliDay = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
//    NSString *lunarDate = [NSString stringWithFormat:@"%@ %@月 %@",szNongli,szNongliDay,(NSString *)[cDayName objectAtIndex:wCurDay]];
    
    NSString *lunarDate = [NSString stringWithFormat:@"%@月%@",szNongliDay,[cDayName objectAtIndex:wCurDay]];
    return lunarDate;
    
}

/*获取阴历的月份
 **/
+ (NSString *)getLunarMonth:(NSInteger)month
{
    NSArray * dataLunarArrayMonth = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"腊月"];
    month-=1;
    if (month <0 || month>11) {
        return @"正月";
    }
    return dataLunarArrayMonth[month];
}

/*获取阴历的日
 **/
+ (NSString *)getLunarDay:(NSInteger)day
{
    NSArray * dataLunarArrayDay = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二十一",@"二十二",@"二十三",@"二十四",@"二十五",@"二十六",@"二十七",@"二十八",@"二十九",@"三十",@"三十一"];
    day-=1;
    if (day <0 || day> 30) {
        return dataLunarArrayDay[0];
    }
    return dataLunarArrayDay[day];
}


- (void)showAlertView:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end
