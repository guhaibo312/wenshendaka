//
//  JWScrollPhotoView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/30.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWCircleProgressView.h"

@interface JWScrollPhotoView : UIScrollView<UIScrollViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>

{
    NSURLConnection* connect;
    NSMutableData* httpData;
    JWCircleProgressView *  progressView;
    float dataLenth;
}
@property(nonatomic,retain)UIImageView* imageView;
@property(nonatomic,retain)NSURL* imageUrl;

/*
 *设置图片的url
 **/
-(void)setimageWith:(NSURL*)imageUrl;

/*
 *开始加载图片
 */
-(void)startLoadImage;


@end
