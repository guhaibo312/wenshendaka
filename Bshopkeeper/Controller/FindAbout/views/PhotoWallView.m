//
//  PhotoWallView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/2.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "PhotoWallView.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import "Configurations.h"
#import "JWPreviewPhotoController.h"
#import "JWSquarePhotoViewController.h"
#import "NSString+Extension.h"
#import "JWChatMessageFrameModel.h"

#define spacing 8

@interface PhotoWallView ()
{
    float morePhotosize;
    float bigImgsize;
    NSMutableArray *photoImgViews;
    UIImageView *bigImagView;
    NSArray *urlArrays;
}


@end

@implementation PhotoWallView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        morePhotosize = (frame.size.width-spacing*3)/3;
        bigImgsize = SCREENWIDTH/2;
        
        bigImagView = [[UIImageView alloc]initWithFrame:CGRectMake(spacing, 0, bigImgsize, bigImgsize)];
        bigImagView.tag = 10;
        bigImagView.contentMode = UIViewContentModeScaleAspectFill;
        bigImagView.clipsToBounds = YES;
        UITapGestureRecognizer *tap1  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhotoAction:)];
        bigImagView.userInteractionEnabled = YES;
        [bigImagView addGestureRecognizer:tap1];
        [self addSubview:bigImagView];
        
        photoImgViews = [NSMutableArray arrayWithCapacity:9];
        for (int i = 0 ; i< 9; i++) {
            float top_y = 0;
            if (i== 3 || i== 4 || i==5 ) {
                top_y = morePhotosize+spacing/2;
            }else if (i== 6 || i== 7 || i==8 ){
                top_y = morePhotosize *2 + spacing;
            }
            UIImageView *oneImg = [[UIImageView alloc]initWithFrame:CGRectMake(spacing+morePhotosize*(i%3)+spacing/2*(i%3), top_y, morePhotosize, morePhotosize)];
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
        if (imageArray.count == 1) {
            for (UIView *oneView in photoImgViews) {
                if (oneView) {
                    oneView.hidden = YES;
                }
            }
            bigImagView.hidden = NO;
            [self bringSubviewToFront:bigImagView];
            
             bigImagView.frame = CGRectMake(spacing, 0, bigImgsize,bigImgsize);
            
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
                                        bigImagView.frame = CGRectMake(spacing, 0, bigImgsize, m_height/(m_width/bigImgsize));
                                        
                                    }else if (m_height == m_width){
                                        bigImagView.frame = CGRectMake(spacing, 0, bigImgsize,bigImgsize);
                                        
                                    }else{
                                        bigImagView.frame = CGRectMake(spacing, 0, m_width/(m_height/bigImgsize),bigImgsize);
                                    }
                                }
                        }

                        
                    }
                }
                
                [bigImagView sd_setImageWithURL:[NSURL URLWithString:firstimg] placeholderImage:[UIImage imageNamed:@"icon_image_default.png"]];
            }
            self.height = bigImagView.bottom;
            return;
        }else {
            
            NSInteger totalCount = imageArray.count;
            
            for (int i = 0 ; i< 9; i++) {
                UIImageView *oneImgView = [photoImgViews objectAtIndex:i];
                if (i < totalCount) {

                    if (totalCount == 4 && (i== 2 || i==3 )) {
                        if (i!=2 ) {
                            
                            NSString *imgUrl = [imageArray objectAtIndex:i-1];
                            [oneImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"icon_image_default.png"]];
                            oneImgView.hidden = NO;
                            oneImgView.height = morePhotosize;
                        }else{
                            oneImgView.height = 0;
                            oneImgView.hidden = YES;
                        }
                        
                    }else{
                        NSString *imgUrl = [imageArray objectAtIndex:i];
                        [oneImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"icon_image_default.png"]];
                        oneImgView.hidden = NO;
                        oneImgView.height = morePhotosize;

                    }
                    
                }else{
                    
                    if (totalCount == 4 && i == 4) {
                        NSString *imgUrl = [imageArray objectAtIndex:i-1];
                        [oneImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl ] placeholderImage:[UIImage imageNamed:@"icon_image_default.png"]];
                        oneImgView.hidden = NO;
                        oneImgView.height = morePhotosize;
                    }else{
                        oneImgView.height = 0;
                        oneImgView.hidden = YES;
                    }
                   
                }
            }
            
            
            bigImagView.hidden = YES;
            bigImagView.height=  0;
            
            UIImageView *oneImg = [photoImgViews objectAtIndex:totalCount-1];
            self.height = oneImg.bottom;
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

- (void)chatResetImage:(JWChatMessageFrameModel *)model isMySend:(BOOL)mySend
{
    if (!model) return;
    if (!model.message) return;
    if (!model.message.images) return;
   
    bigImgsize = SCREENWIDTH/2;
    morePhotosize = (180-spacing*3)/3;

    self.width = model.photoWidth;
    self.height = model.photoHeight;
    
    urlArrays = model.message.images;
    
    if (urlArrays.count == 1) {
        for (UIView *oneView in photoImgViews) {
            if (oneView) {
                oneView.hidden = YES;
            }
        }
        bigImagView.hidden = NO;
        [self bringSubviewToFront:bigImagView];
        bigImagView.frame = CGRectMake(mySend?5:15, 5, model.photoWidth-10,model.photoHeight-10);
        
        NSString *nameString = urlArrays[0];
        
        if (model.message.sendImages) {
            bigImagView.image = [model.message.sendImages  firstObject];
        }else{
            [bigImagView sd_setImageWithURL:[NSURL URLWithString:nameString] placeholderImage:[UIImage imageNamed:@"icon_image_default.png"]];
        }
    
        return;
    }else {
            
        NSInteger totalCount = urlArrays.count;
        
        for (int i = 0 ; i< 9; i++) {
            UIImageView *oneImgView = [photoImgViews objectAtIndex:i];
            
            if (i < totalCount) {
                
                if (totalCount == 4 && (i== 2 || i==3 )) {
                    
                    if (i!=2 ) {
                        
                        NSString *imgUrl = [urlArrays objectAtIndex:i-1];
                        [oneImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"icon_image_default.png"]];
                        oneImgView.hidden = NO;
                        oneImgView.height = morePhotosize;
                    }else{
                        oneImgView.height = 0;
                        oneImgView.hidden = YES;
                    }
                    
                }else{
                    NSString *imgUrl = [urlArrays objectAtIndex:i];
                    [oneImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"icon_image_default.png"]];
                    oneImgView.hidden = NO;
                    oneImgView.height = morePhotosize;
                    
                }
                
            }else{
                
                if (totalCount == 4 && i == 4) {
                    NSString *imgUrl = [urlArrays objectAtIndex:i-1];
                    [oneImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl ] placeholderImage:[UIImage imageNamed:@"icon_image_default.png"]];
                    oneImgView.hidden = NO;
                    oneImgView.height = morePhotosize;
                }else{
                    oneImgView.height = 0;
                    oneImgView.hidden = YES;
                }
            }
            
        }
        
        bigImagView.hidden = YES;
        bigImagView.height=  0;
       
    }
  

}



- (void)setBigImageCenter
{
    bigImagView.center = self.center;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
