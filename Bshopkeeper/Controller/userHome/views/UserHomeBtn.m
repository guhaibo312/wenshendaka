//
//  UserHomeBtn.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/12.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "UserHomeBtn.h"
#import "Configurations.h"

@implementation UserHomeBtn

- (id)initWithFrame:(CGRect)frame text:(NSString *)text imageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        _desIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-54, frame.size.height/2-46, 108, 72)];
        if (imageName) {
            _desIamgeView.image = [UIImage imageNamed:imageName];
        }
        _desIamgeView.backgroundColor = [UIColor clearColor];
        _desIamgeView.userInteractionEnabled = NO;
        [self addSubview:_desIamgeView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height/2+10, frame.size.width, 30)];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        _nameLabel.text = text;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.userInteractionEnabled = NO;
        [self addSubview:_nameLabel];
        [self setBackgroundImage:[UIUtils imageFromColor:[UIColor colorWithWhite:0.8 alpha:0.9]] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIUtils imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        _noticeImg = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 37, 10, 21, 27)];
        _noticeImg.hidden = YES;
        [self addSubview:_noticeImg];
        
    }
    return self;
}

+ (instancetype)buttonWithFrame:(CGRect)frame text:(NSString *)text imageName:(NSString *)imageName
{
    UserHomeBtn *btn = [UserHomeBtn buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.desIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-30, (frame.size.height-30)/2, 34, 30)];
    btn.desIamgeView.image = [UIImage imageNamed:imageName];
    btn.desIamgeView.backgroundColor = [UIColor clearColor];
    btn.desIamgeView.userInteractionEnabled = NO;
    [btn addSubview:btn.desIamgeView];
    
    btn.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-5,0, 40, frame.size.height)];
    btn.nameLabel.font = [UIFont systemFontOfSize:14];
    btn.nameLabel.text = text;
    btn.nameLabel.textAlignment = NSTextAlignmentCenter;
    btn.nameLabel.textColor = [UIColor blackColor];
    btn.nameLabel.userInteractionEnabled = NO;
    [btn addSubview:btn.nameLabel];
    [btn setBackgroundImage:[UIUtils imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIUtils imageFromColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    return btn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
