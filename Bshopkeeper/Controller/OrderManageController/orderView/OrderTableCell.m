//
//  OrderTableCell.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/23.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderTableCell.h"
#import "CommodityModel.h"

@interface OrderTableCell ()
{
    UIImageView *orederNameImg;
    UIImageView *orderTimeImg;
}

@end


@implementation OrderTableCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        //预约项目 图片
        headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 44-26, 52, 52)];
        [headImageView setImage:[UIImage imageNamed:@"icon_order_message.png"]];
        headImageView.autoresizingMask = UIViewAutoresizingNone;
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.clipsToBounds = YES;
        [self.contentView addSubview:headImageView];
        
        //姓名
        orederNameImg = [[UIImageView alloc]initWithFrame:CGRectMake(headImageView.right+10, 19, 20, 20)];
        orederNameImg.image = [UIImage imageNamed:@"icon_order_name.png"];
        [self.contentView addSubview:orederNameImg];
        
        nameLabel = [UILabel labelWithFrame:CGRectMake(headImageView.right+35, 19, 70, 20 ) fontSize:16 fontColor:GRAYTEXTCOLOR text:@""];
        [self.contentView addSubview:nameLabel];

        //预约时间
        orderTimeImg = [[UIImageView alloc]initWithFrame:CGRectMake(headImageView.right+10, 49, 20, 20)];
        orderTimeImg.image = [UIImage imageNamed:@"icon_order_time.png"];
        [self.contentView addSubview:orderTimeImg];
        
        orderTimeLabel = [UILabel labelWithFrame:CGRectMake(headImageView.right+35, 49, SCREENWIDTH-headImageView.right-35-10, 20 ) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        [self.contentView addSubview:orderTimeLabel];
    
        statusLabel = [UILabel labelWithFrame:CGRectMake(SCREENWIDTH - 130, 88/2-10, 95, 20) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        statusLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:statusLabel];
        
        point1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-30,88/2-5, 6, 10)];
        point1.image = [UIImage imageNamed:@"icon_right_img.png"];
        [self.contentView addSubview:point1];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 87.5, SCREENWIDTH, 0.5)];
        lineView.backgroundColor = LINECOLOR;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)changContentFrom:(OrderModel *)orderModel
{
   
    
    if (orderTimeLabel) {
        if (orderModel.resultname) {
            nameLabel.text = orderModel.resultname;
        }
        

        if (orderModel.orderTime) {
            NSTimeInterval time = [orderModel.orderTime doubleValue];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
            NSString *result = [formatter stringFromDate:date];
            orderTimeLabel.text = [NSString stringWithFormat:@"%@",result];
        
        }
        
        int statusCode = [orderModel.orderStatus intValue];
        statusLabel.text = [UIUtils findOrderStatusFromCode:statusCode withTime:orderModel.orderTime];
        statusLabel.textColor = GRAYTEXTCOLOR;

        if (statusCode == 10 || statusCode == 11 ||statusCode == 4 || statusCode == 7) {
            if (![statusLabel.text isEqualToString:@"已过期"]) {
                statusLabel.textColor = [UIColor redColor];
            }
        }
    }
}

- (void)prepareForReuse
{
    nameLabel.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
