//
//  NSString+BG.m
//  BeautifulGirls
//
//  Created by suning on 14-10-5.
//  Copyright (c) 2014年 BestBoys. All rights reserved.
//

#import "NSString+BG.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "Configurations.h"

@implementation NSString (BG)

//
// 返回带有统计数据的URL
//
- (NSString*) urlPathWithCommonStat {
    
    // 如果是空字符串，则返回空字符串本身
    if (!self) {
        return self;
    }
    
    NSString* commonStat = [[self class] commonStatString];
    
    // 已经带有统计信息了
    if ([self rangeOfString:commonStat].length > 0) {
        return self;
    }
    
    // 添加统计信息
    if ([self rangeOfString:@"?"].length > 0) {
        return [self stringByAppendingFormat:@"&%@", commonStat];
    } else {
        return [self stringByAppendingFormat:@"?%@", commonStat];
    }
}


//
// 统计信息
//
+ (NSString *) commonStatString {
    
    NSString *ver = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    // platform: 和发布的app的platform的定义一致: iPad, iPhone, android, 如果需要统计真实的platform, 可以考虑添加其他的参数
    return [NSString stringWithFormat: @"platform=%@&systemVer=%@&version=%@&vendor=%@&machineType=%@&device_id=%@",
            @"1",
            [Utility escapeURL: [[UIDevice currentDevice] systemVersion]],
            ver,
            [AppDelegate appDelegate].vendor,
            [Utility escapeURL: [[UIDevice currentDevice] model]],
            [[UIUtils defaultUIUtils] uniqueDeviceToken]]; // 用于数据的统计
//            [[BGDeviceInfo sharedInstance] userPushToken]];
}

- (NSString*) getQiNiuThunbImage {
    
    NSString *originPath = self;
    NSRange queryRange = [self rangeOfString: @"?imageView2"];
    if (queryRange.length > 0) {
        originPath = [originPath substringToIndex: queryRange.location];
    }
    
    return [originPath stringByAppendingFormat: @"?imageView2/0/w/%d", (int)(SCREENWIDTH/2-12)*2];
}

- (NSString*) getQiNiuMiddleImage {
    
    NSString *originPath = self;
    NSRange queryRange = [self rangeOfString: @"?imageView2"];
    if (queryRange.length > 0) {
        originPath = [originPath substringToIndex: queryRange.location];
    }
    
    return [originPath stringByAppendingFormat: @"?imageView2/0/w/%d", (int)SCREENWIDTH];
}

- (NSString*) getQiNiuLargeImage {
    NSString *originPath = self;
    NSRange queryRange = [self rangeOfString: @"?imageView2"];
    if (queryRange.length > 0) {
        originPath = [originPath substringToIndex: queryRange.location];
    }
    
    return [originPath stringByAppendingFormat: @"?imageView2/0/w/%d", (int)(SCREENWIDTH*2)];
}

- (NSString*) getQiNiuImgWithWidth:(float)awidth
{
    NSString *originPath = self;
    NSRange queryRange = [self rangeOfString: @"?imageView2"];
    if (queryRange.length > 0) {
        originPath = [originPath substringToIndex: queryRange.location];
    }
    return [originPath stringByAppendingFormat: @"?imageView2/0/w/%d", (int)awidth*2];

}

- (NSString*)getQiNiuLargeImageSizeToFit
{
    NSString *originPath = self;
    NSRange queryRange = [self rangeOfString: @"?imageView2"];
    if (queryRange.length > 0) {
        originPath = [originPath substringToIndex: queryRange.location];
    }
    
    return [originPath stringByAppendingFormat: @"?imageView2/0/w/%d/h/%d", (int)(SCREENWIDTH*2),(int)((SCREENWIDTH*305/SCREENWIDTH)*2)];
    
}
- (NSString*)getQiNiuLargeImageFromWidth:(float)awidth heigth:(float)aHeigth
{
    NSString *originPath = self;
    NSRange queryRange = [self rangeOfString: @"?imageView2"];
    if (queryRange.length > 0) {
        originPath = [originPath substringToIndex: queryRange.location];
    }
    
    return [originPath stringByAppendingFormat: @"?imageView2/0/w/%d/h/%d", (int)awidth,(int)aHeigth];
}


@end
