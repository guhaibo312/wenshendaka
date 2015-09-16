//
//  CommodityTagInfoView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CommodityTagInfoView.h"
#import "Configurations.h"

@implementation CommodityTagInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame withSelectdArray:(NSArray *)selectedArray
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createdSubViewsFromeArray:selectedArray];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
    }
    return self;
}

- (void)createdSubViewsFromeArray:(NSArray *)array
{
    for (UIView *sView in self.subviews) {
        if (sView) {
            [sView removeFromSuperview];
        }
    }
    if (array.count < 1){
        self.contentSize = CGSizeMake(0, self.height);
        return;
    }
    NSMutableArray * tags  = [NSMutableArray array];
    for (int i = 0 ; i< array.count; i++) {
        NSString *title = [array objectAtIndex:i];
        float width = [UIUtils getSizeWithString:title withfont:14];
        UILabel *label = [tags lastObject];
        if (label) {
            UILabel *oneLabel = [UILabel labelWithFrame:CGRectMake(label.right +10, self.size.height/2-10, width, 20) fontSize:14 fontColor:[UIColor blackColor] text:title];
            oneLabel.layer.cornerRadius = 5;
            oneLabel.layer.borderColor = TAGSCOLORTHREE.CGColor;
            oneLabel.layer.borderWidth = 0.5;
            oneLabel.textAlignment = NSTextAlignmentCenter;
            oneLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
            [self addSubview:oneLabel];
            [tags addObject:oneLabel];
            
        }else{
            UILabel *oneLabel = [UILabel labelWithFrame:CGRectMake(10, self.size.height/2-10, width, 20) fontSize:14 fontColor:[UIColor blackColor] text:title];
            oneLabel.layer.cornerRadius = 5;
            oneLabel.textAlignment = NSTextAlignmentCenter;
            oneLabel.layer.borderColor = TAGSCOLORTHREE.CGColor;
            oneLabel.layer.borderWidth = 0.5;
            oneLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
            [self addSubview:oneLabel];
            [tags addObject:oneLabel];
        }
    }


    UILabel *label = [tags lastObject];
    if (label) {
    self.contentSize = CGSizeMake(label.right +10, self.height);
    }
}

@end
