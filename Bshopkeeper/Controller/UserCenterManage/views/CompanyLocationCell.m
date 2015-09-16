//
//  CompanyLocationCell.m
//  Bshopkeeper
//
//  Created by jinwei on 15/5/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CompanyLocationCell.h"
#import "Configurations.h"

@implementation CompanyLocationCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        nameLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-90, 20)];
        nameLable.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:nameLable];
        
        desLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, nameLable.bottom, SCREENWIDTH-20, 60)];
        desLabel.numberOfLines = 0;
        desLabel.font = [UIFont systemFontOfSize:14];
        desLabel.textColor = GRAYTEXTCOLOR;
        [self.contentView addSubview:desLabel];
        
        kilLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-110,10, 100, 20)];
        kilLabel.font = [UIFont systemFontOfSize:14];
        kilLabel.textAlignment = NSTextAlignmentRight;
        kilLabel.textColor = GRAYTEXTCOLOR;
        kilLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:kilLabel];        
        
        
    }
    return self;
}

- (void)changeDataFrom:(BMKPoiInfo *)info withCenter:(CLLocationCoordinate2D)center
{
 
    nameLable.text = info.name;
    desLabel.text = info.address;
    double kile = 0;
    if (center.latitude) {
        kile =  BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(center),BMKMapPointForCoordinate(info.pt));
    }
    kilLabel.text = [NSString stringWithFormat:@"%.2f KM",kile/1000];
    [desLabel sizeToFit];
    desLabel.top = nameLable.bottom;
    desLabel.width = SCREENWIDTH-20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
