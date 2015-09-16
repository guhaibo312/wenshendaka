//
//  UIImage+JWNetImageSize.h
//  Bshopkeeper
//
//  Created by jinwei on 15/5/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
// 获取网络图片的大小

#import <UIKit/UIKit.h>

@interface UIImage (JWNetImageSize)

/*下载网络图片的大小 如果本地缓存有会从本地获取
 **/
+(CGSize)downloadImageSizeWithURL:(id)imageURL;

@end
