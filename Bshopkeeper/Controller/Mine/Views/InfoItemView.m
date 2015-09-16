//
//  InfoItemView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "InfoItemView.h"
#import "Configurations.h"

@implementation InfoItemView


- (instancetype)initWithFrame:(CGRect)frame Img:(UIImage *)img titleString:(NSString *)title detailInfo:(NSString *)detailStr
{
    self = [super initWithFrame:frame];
    if (self) {
        leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.height/2-13, 26, 26)];
        leftImg.image = img;
        [self addSubview:leftImg];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 0, 200, 44)];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = title;
        titleLabel.textColor = GRAYTEXTCOLOR;
        [titleLabel sizeToFit];
        titleLabel.top = 22-titleLabel.height/2;
        [self addSubview:titleLabel];
        
        
        _detailLabel = [UILabel labelWithFrame:CGRectMake(SCREENWIDTH-200, 2, 165, 40) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.text = detailStr;
        _detailLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_detailLabel];
        
        messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 12, 20, 20)];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.backgroundColor = MessageBackColor;
        messageLabel.clipsToBounds = YES;
        messageLabel.layer.cornerRadius = 10;
        messageLabel.font = [UIFont systemFontOfSize:12];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.hidden = YES;
        [self addSubview:messageLabel];
        
        UIImageView *point1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-25,self.height/2-5, 6, 10)];
        point1.image = [UIImage imageNamed:@"icon_right_img.png"];
        [self addSubview:point1];
        
        self.backgroundColor = [UIColor whiteColor];

        actionBtn = [[UIButton alloc]initWithFrame:self.bounds];
        actionBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:actionBtn];
    }
    return self;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    actionBtn.tag = tag;
}

- (void)setAction:(SEL)action target:(id)sender
{
    [actionBtn addTarget:sender action:action forControlEvents:UIControlEventTouchUpInside];
}


- (void)setMessageCount:(int)count
{
    if (count == 0) {
        messageLabel.hidden = NO;
        messageLabel.left = titleLabel.right+10;
        messageLabel.frame = CGRectMake(titleLabel.right+10, 10, 6, 6);
        messageLabel.layer.cornerRadius = 3;
    } else if (count < 0){
        messageLabel.hidden = YES;
    }else{
        messageLabel.text = [NSString stringWithFormat:@"%d",count];
        messageLabel.hidden = NO;
        messageLabel.frame = CGRectMake(titleLabel.right+10, 12, 20, 20);
        messageLabel.layer.cornerRadius = 10;
    }
}

@end

@implementation InfoItemViewItem

@end

@implementation InfoItemViewItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setInfoValue:(InfoItemViewItem *)item
{
    
    if (item) {
        if (self.infoView) {
            [self.infoView removeFromSuperview];
        }
        self.infoView = nil;
        self.infoView = [[InfoItemView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, 44) Img:item.iconImg titleString:item.itemTitle detailInfo: item.detailTitle?item.detailTitle:@""];
        self.infoView.controlDes = item.DesController;
        [self.contentView addSubview:self.infoView];
        self.infoView.userInteractionEnabled = NO;

    }
}

@end
