//
//  JWPhotoWallView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/9/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWPhotoWallView.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import "Configurations.h"
#import "JWPreviewPhotoController.h"
#import "JWSquarePhotoViewController.h"
#import "NSString+Extension.h"


#define spacing 8


@interface JWPhotoWallView ()
{
    float morePhotosize;
    float bigImgsize;
    NSMutableArray *photoImgViews;
    NSArray *urlArrays;
}


@end

@implementation JWPhotoWallView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        morePhotosize = (frame.size.width-spacing*3)/3;
        bigImgsize = SCREENWIDTH/2;

        
        photoImgViews = [NSMutableArray arrayWithCapacity:9];
        for (int i = 0 ; i< 9; i++) {
          
            
            UIImageView *oneImg = [[UIImageView alloc]initWithFrame:CGRectZero];
            oneImg.contentMode = UIViewContentModeScaleAspectFill;
            oneImg.clipsToBounds = YES;
            oneImg.tag= i;
            UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhotoAction:)];
            oneImg.userInteractionEnabled = YES;
            [oneImg addGestureRecognizer:tap];
            [photoImgViews addObject:oneImg];
            [self addSubview:oneImg];
        }
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)setAllImageWithArray:(NSArray *)imageArray
{
    
    if (!imageArray || imageArray.count <1) {
        self.height = 0;
        self.hidden = YES;
        return;
    }else{
        bigImgsize = SCREENWIDTH/2;
        self.hidden = NO;
        urlArrays = imageArray;
        for (UIView *oneView in photoImgViews) {
            if (oneView) {
                oneView.hidden = YES;
            }
        }

        if (imageArray.count == 1) {
            
            UIImageView *firstImageView = (UIImageView *)[photoImgViews firstObject];
            firstImageView.frame = CGRectMake(spacing, 0, bigImgsize, bigImgsize);
            firstImageView.contentMode = UIViewContentModeScaleAspectFill;
            firstImageView.clipsToBounds = YES;
            
            NSString *firstimg = [imageArray firstObject];
            if (firstimg) {
                NSString *imgSize = [[firstimg componentsSeparatedByString:@"_"]lastObject];
                if ([imgSize rangeOfString:@"X"].location != NSNotFound) {
                    
                    NSArray *temp = [imgSize componentsSeparatedByString:@"X"];
                    
                    NSString *first = [temp firstObject];
                    NSString *second = [temp lastObject];
                    if ([NSObject nulldata:first] && [NSObject nulldata:second]) {
                        
                        if ([[JudgeMethods defaultJudgeMethods]passWordIsPurelyDigital:first] && [[JudgeMethods defaultJudgeMethods]passWordIsPurelyDigital:second]) {
                            CGSize asize;
                            asize.width= [first floatValue];
                            asize.height= [second floatValue];
                            if (asize.width != 0 && asize.height != 0) {
                                float m_width = [ first floatValue];
                                float m_height = [second floatValue];
                                
                                if (m_width > m_height) {
                                    firstImageView.frame = CGRectMake(spacing, 0, bigImgsize, m_height/(m_width/bigImgsize));
                                    
                                }else if (m_height == m_width){
                                    firstImageView.frame = CGRectMake(spacing, 0, bigImgsize,bigImgsize);
                                    
                                }else{
                                    firstImageView.frame = CGRectMake(spacing, 0, m_width/(m_height/bigImgsize),bigImgsize);
                                }
                            }
                        }
                        
                        
                    }
                }
                
                [firstImageView sd_setImageWithURL:[NSURL URLWithString:firstimg] placeholderImage:[UIImage imageNamed:@"icon_image_default.png"]];
            }
            self.height = firstImageView.height;
            firstImageView.hidden = NO;
            return;
        }else if(imageArray.count == 4){
            
            
            for (int i = 0 ; i < 4 ; i++ ){
                UIImageView *tempImageView = [photoImgViews objectAtIndex:i];
                tempImageView.hidden = NO;
                NSString *imgUrl = [imageArray objectAtIndex:i];
                [tempImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"icon_image_default.png"]];
                
                if (i== 0) {
                    tempImageView.frame = CGRectMake(spacing, 0, morePhotosize, morePhotosize);

                }else if (i == 1){
                    tempImageView.frame = CGRectMake(spacing+ 4 + morePhotosize, 0, morePhotosize, morePhotosize);
                    
                }else if (i == 2){
                    tempImageView.frame = CGRectMake(spacing, morePhotosize +spacing/2, morePhotosize, morePhotosize);

                }else{
                    tempImageView.frame = CGRectMake(spacing + 4 + morePhotosize, morePhotosize + spacing/2, morePhotosize, morePhotosize);
                }
            }
            self.height = morePhotosize *2 + spacing;
            return;
            
        }else{
            
            for (int i = 0 ; i < imageArray.count ; i++ ){
                float top_y = 0;
                if (i== 3 || i== 4 || i==5 ) {
                    top_y = morePhotosize+spacing/2;
                }else if (i== 6 || i== 7 || i==8 ){
                    top_y = morePhotosize *2 + spacing;
                }
                UIImageView *tempImageView = [photoImgViews objectAtIndex:i];
                tempImageView.hidden = NO;
                NSString *imgUrl = [imageArray objectAtIndex:i];
                [tempImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"icon_image_default.png"]];
                tempImageView.frame =  CGRectMake(spacing+morePhotosize*(i%3)+spacing/2*(i%3), top_y, morePhotosize, morePhotosize);
                if (i == imageArray.count-1) {
                    self.height = tempImageView.bottom;
                }
            }
            
            return;
        }
    
    }
}

-(void)tapPhotoAction:(UITapGestureRecognizer*)tap
{
    
    if (!urlArrays || urlArrays.count < 1) {
        return;
    }
    int tag = 1;
    UIImageView *oneImg = (UIImageView *)tap.view;
    if (oneImg) {
        if (oneImg.tag == 10) {
            oneImg.tag = 1;
        }else{
            tag = oneImg.tag+1;
        }
    }
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    JWSquarePhotoViewController *previewPhoto = [[JWSquarePhotoViewController alloc]initWithImgs:urlArrays withCurrentIndex:tag];
    [topVC presentViewController:previewPhoto animated:YES completion:nil];
    
}




@end
