//
//  WXInvitationView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "WXInvitationView.h"
#import "Configurations.h"
#import "TTTAttributedLabel.h"

@interface WXInvitationView ()
{
    UIScrollView *backScrollView;
}
@end

@implementation WXInvitationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
        backScrollView.backgroundColor = [UIColor whiteColor];
        backScrollView.showsHorizontalScrollIndicator = NO;
        backScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:backScrollView];
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
        topView.backgroundColor = RGBCOLOR(183, 0, 20);
        [self addSubview:topView];
        
        UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(20, 20, SCREENWIDTH-40, 44) fontSize:16 fontColor:[UIColor whiteColor] text:@"微信邀约图解说明"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:titleLabel];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(SCREENWIDTH-50, 20, 50, 44);
        [closeBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [closeBtn addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:closeBtn];
        
        int imgHeight = (int) 320/(720/SCREENWIDTH);
        for (int i = 0 ; i<4; i++) {
            UIImageView *operationImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, i*imgHeight, SCREENWIDTH, imgHeight)];
            operationImg.backgroundColor = VIEWBACKGROUNDCOLOR;
            NSString *imgName = [NSString stringWithFormat:@"icon_order_wx%d.png",i+1];
            operationImg.image = [UIImage imageNamed:imgName];
            [backScrollView addSubview:operationImg];
            if (i==3) {
                backScrollView.contentSize = CGSizeMake(SCREENWIDTH, operationImg.bottom+20);
            }
        }
        TTTAttributedLabel *firstLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+20, imgHeight/2-20, SCREENWIDTH/2-20, 20)];
        NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
        [mutableLinkAttributes setValue:(id)[[UIColor redColor] CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
        [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        firstLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes];
        firstLabel.text = @"1.选择微信邀约";
        firstLabel.font = [UIFont systemFontOfSize:14];
        [firstLabel addLinkToPhoneNumber:@"微信邀约" withRange:[firstLabel.text rangeOfString:@"微信邀约"]];
        [backScrollView addSubview:firstLabel];
        
        TTTAttributedLabel *secondLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+20, imgHeight+imgHeight/2-20, SCREENWIDTH/2-20, 50)];
       NSMutableDictionary *mutableLinkAttributes2 = [NSMutableDictionary dictionary];
        [mutableLinkAttributes2 setValue:(id)[[UIColor redColor] CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
        [mutableLinkAttributes2 setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        secondLabel.numberOfLines = 0;
        secondLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes2];
        secondLabel.text = @"2.创建收取\n\t定金额度";
        secondLabel.font = [UIFont systemFontOfSize:14];
        [secondLabel addLinkToPhoneNumber:@"定金额度" withRange:[secondLabel.text rangeOfString:@"定金额度"]];
        [backScrollView addSubview:secondLabel];
        
        TTTAttributedLabel *threeLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+20, imgHeight*2+imgHeight/2-20, SCREENWIDTH/2-20, 50)];
        NSMutableDictionary *mutableLinkAttributes3 = [NSMutableDictionary dictionary];
        [mutableLinkAttributes3 setValue:(id)[[UIColor redColor] CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
        [mutableLinkAttributes3 setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        threeLabel.numberOfLines = 0;
        threeLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes3];
        threeLabel.text = @"3.发送邀约单\n\t给顾客";
        threeLabel.font = [UIFont systemFontOfSize:14];
        [threeLabel addLinkToPhoneNumber:@"邀约单" withRange:[threeLabel.text rangeOfString:@"邀约单"]];
        [backScrollView addSubview:threeLabel];
        
        TTTAttributedLabel *fourLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+20,imgHeight*3+10, SCREENWIDTH/2-20, 100)];
        fourLabel.numberOfLines = 0;
        NSMutableDictionary *mutableLinkAttributes4 = [NSMutableDictionary dictionary];
        [mutableLinkAttributes4 setValue:(id)[[UIColor redColor] CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
        [mutableLinkAttributes4 setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        fourLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes4];
        fourLabel.text = @"4.顾客提交\n 邀约单后，在\n 预约待确认\n 中查看";
        fourLabel.font = [UIFont systemFontOfSize:14];
        [fourLabel addLinkToPhoneNumber:@"预约待确认" withRange:[fourLabel.text rangeOfString:@"预约待确认"]];
        [backScrollView addSubview:fourLabel];
        
        self.tag = 199;
    }
    return self;
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *haveView = [keyWindow viewWithTag:199];
    if (haveView) {
        return;
    }
    [keyWindow addSubview:self];
    
    self.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        }
    }];
}


- (void)dissMiss
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *haveView = [keyWindow viewWithTag:199];
    if (haveView) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"closeWXYY" object:nil];
                [self removeFromSuperview];
            }
        }];
        
    }
    
}


@end