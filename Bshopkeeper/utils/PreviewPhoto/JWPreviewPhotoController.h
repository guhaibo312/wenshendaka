//
//  JWPreviewPhotoController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/30.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWScrollPhotoView.h"

typedef NS_ENUM(NSUInteger, GGOrientation) {
    GGOrientationPortrait = 0,
    GGOrientationLandscapeLeft = 1,
    GGOrientationPortraitUpsideDown = 2,
    GGOrientationLandscapeRight = 3
};

@interface JWPreviewPhotoController : UIViewController
{
    NSMutableArray* scrollImageArr;
    int currentNum;
    UIInterfaceOrientation original;
}
@property(nonatomic,retain) NSMutableArray* thumbArray;
@property(nonatomic,retain) NSMutableArray* imageUrlArr;
@property (nonatomic, retain)  UIImageView *liftedImageView;
@property (nonatomic, assign)  UIInterfaceOrientationMask supportedOrientations;

@end
