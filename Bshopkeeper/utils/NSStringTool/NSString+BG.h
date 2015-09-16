//
//  NSString+BG.h
//  BeautifulGirls
//
//  Created by suning on 14-10-5.
//  Copyright (c) 2014年 BestBoys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BG)

//
// 返回带有统计数据的URL
//
- (NSString*) urlPathWithCommonStat;
//
// 带有统计信息的字符串
//
+ (NSString *) commonStatString;

- (NSString*) getQiNiuThunbImage;
- (NSString*) getQiNiuMiddleImage;
- (NSString*) getQiNiuLargeImage;

- (NSString*) getQiNiuImgWithWidth:(float)awidth;


- (NSString*)getQiNiuLargeImageSizeToFit;
- (NSString*)getQiNiuLargeImageFromWidth:(float)awidth heigth:(float)aHeigth;


@end
