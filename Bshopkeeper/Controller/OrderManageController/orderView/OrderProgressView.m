//
//  OrderProgressView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderProgressView.h"
#import "Configurations.h"

@implementation OrderProgressView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        
        progressImg = [[UIImageView alloc]initWithFrame:CGRectMake(44, 0, frame.size.width-88, 15.5)];
        progressImg.backgroundColor = [UIColor clearColor];
        [self addSubview:progressImg];
        
        UILabel *label2 = [UILabel labelWithFrame:CGRectMake(44-20, 18, 40, 18) fontSize:12 fontColor:GRAYTEXTCOLOR text:@"待处理"];
        [self addSubview:label2];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-30, 18, 60, 18)];
        label.text = @"待消费";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = GRAYTEXTCOLOR;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-30-44, 18, 60, 18)];
        label1.text = @"已完成";
        label1.font = [UIFont systemFontOfSize:12];
        label1.textColor = GRAYTEXTCOLOR;
        label1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label1];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setCurrentProgress:(int)progress
{
    if (progress == 2) {
        progressImg.image = [ UIImage imageNamed:@"icon_status_2img.png"];

    }else if (progress == 3){
        progressImg.image = [ UIImage imageNamed:@"icon_status_3img.png"];

    }else if (progress == 4){
        progressImg.image = [ UIImage imageNamed:@"icon_status_4img.png"];
        
    }else if (progress == 5){
        progressImg.image = [ UIImage imageNamed:@"icon_status_5img.png"];
        
    }else{
        progressImg.image = [ UIImage imageNamed:@"icon_status_1img.png"];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
