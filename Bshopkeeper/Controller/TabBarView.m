//
//  TabBarView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "TabBarView.h"
#import "Configurations.h"

#define hobbyTabBarCount 4

@implementation TabBarView

- (instancetype)initWithFrame:(CGRect)frame withType:(int)type
{
    self = [super initWithFrame:frame];
    if (self) {
        if (type == 1) {
            self.firstItem = [[JWTabItem alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/4, 49) withNorImg:[UIImage imageNamed:@"icon_tab_w1_normal.png"] selectedImg:[UIImage imageNamed:@"icon_tab_w1_selected.png"] title:@"微名片"];
            self.firstItem.tag = 10;
            [self addSubview:self.firstItem];
            
            
            self.secondItem = [[JWTabItem alloc]initWithFrame:CGRectMake(SCREENWIDTH/4, 0, SCREENWIDTH/4, 49) withNorImg:[UIImage imageNamed:@"icon_tab_w2_normal.png"] selectedImg:[UIImage imageNamed:@"icon_tab_w2_selected.png"] title:@"订单"];
            self.secondItem.tag = 11;
            [self addSubview:self.secondItem];
            
            
            self.threeItem = [[JWTabItem alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/4, 49) withNorImg:[UIImage imageNamed:@"icon_tab_w3_normal.png"] selectedImg:[UIImage imageNamed:@"icon_tab_w3_selected.png"] title:@"发现"];
            self.threeItem.tag = 12;
            [self addSubview:self.threeItem];
            
            
            self.fourthItem = [[JWTabItem alloc]initWithFrame:CGRectMake(SCREENWIDTH/4*3, 0, SCREENWIDTH/4, 49) withNorImg:[UIImage imageNamed:@"icon_tab_w4_normal.png"] selectedImg:[UIImage imageNamed:@"icon_tab_w4_selected.png"] title:@"我的"];
            [self addSubview:self.fourthItem];
            self.fourthItem.tag = 13;

        }else{
            
            self.firstItem = [[JWTabItem alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/hobbyTabBarCount, 49) withNorImg:[UIImage imageNamed:@"icon_tab_a2_normal.png"] selectedImg:[UIImage imageNamed:@"icon_tab_a2_selected.png"] title:@"图库"];
            self.firstItem.tag = 10;
            [self addSubview:self.firstItem];
            
            self.secondItem = [[JWTabItem alloc]initWithFrame:CGRectMake(SCREENWIDTH/hobbyTabBarCount, 0, SCREENWIDTH/hobbyTabBarCount, 49) withNorImg:[UIImage imageNamed:@"icon_tab_a1_normal.png"] selectedImg:[UIImage imageNamed:@"icon_tab_a1_selected.png"] title:@"圈子"];
            _secondItem.tag = 11;
            [self addSubview:self.secondItem];
            
            
            self.threeItem = [[JWTabItem alloc]initWithFrame:CGRectMake(SCREENWIDTH/hobbyTabBarCount * 2, 0, SCREENWIDTH/hobbyTabBarCount, 49) withNorImg:[UIImage imageNamed:@"icon_tab_a3_normal.png"] selectedImg:[UIImage imageNamed:@"icon_tab_a3_selected.png"] title:@"附近"];
            self.threeItem.tag = 12;
            [self addSubview:self.threeItem];
            
            
            self.fourthItem = [[JWTabItem alloc]initWithFrame:CGRectMake(SCREENWIDTH/hobbyTabBarCount * 3, 0, SCREENWIDTH/hobbyTabBarCount, 49) withNorImg:[UIImage imageNamed:@"icon_tab_w4_normal.png"] selectedImg:[UIImage imageNamed:@"icon_tab_w4_selected.png"] title:@"我的"];
            self.fourthItem.tag = 13;
            [self addSubview:self.fourthItem];
            
        }
        
        
    }
    return self;
}

- (void)setNothingSelected
{
    if (_firstItem) {
        [_firstItem setSelected:NO];
    }
    if (_secondItem) {
        [_secondItem setSelected:NO];
    }
    if (_threeItem) {
        [_threeItem setSelected:NO];
    }
    if (_fourthItem) {
        [_fourthItem setSelected:NO];
    }
}

@end

@interface JWTabItem ()
@property (nonatomic, strong) UIButton *promptBtn;
@property (nonatomic, strong) UILabel *bottomTitleLabel;

@end

@implementation JWTabItem

- (instancetype)initWithFrame:(CGRect)frame withNorImg:(UIImage *)nimg selectedImg:(UIImage *)simg title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _promptBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width/2-15, 5, 29, 29)];
        _promptBtn.backgroundColor = [UIColor clearColor];
        _promptBtn.userInteractionEnabled = NO;
        [_promptBtn setImage:nimg forState:UIControlStateNormal];
        [_promptBtn setImage:simg forState:UIControlStateSelected];
        _promptBtn.selected = NO;
        [_promptBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self addSubview:_promptBtn];
        
        _bottomTitleLabel = [UILabel labelWithFrame:CGRectMake(0, self.height-14, self.width, 14) fontSize:10 fontColor:[UIColor whiteColor] text:title];
        _bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bottomTitleLabel];
            
        
        _messageLabel = [UILabel labelWithFrame:CGRectMake(self.width-30, 5, 16, 16) fontSize:10 fontColor:[UIColor whiteColor] text:@""];
        _messageLabel.clipsToBounds = YES;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.hidden = YES;
        _messageLabel.layer.cornerRadius = 8;
        _messageLabel.backgroundColor = MessageBackColor;
        [self addSubview:_messageLabel];
        
        _messageView = [[UIView alloc]initWithFrame:CGRectMake(self.width-22, 5, 6, 6)];
        _messageView.backgroundColor = MessageBackColor;
        _messageView.clipsToBounds = YES;
        _messageView.layer.cornerRadius = 3;
        _messageView.hidden = YES;
        [self addSubview:_messageView];
        
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _promptBtn.selected = selected;
}

@end
