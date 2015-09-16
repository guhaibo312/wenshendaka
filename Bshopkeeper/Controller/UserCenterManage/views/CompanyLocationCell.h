//
//  CompanyLocationCell.h
//  Bshopkeeper
//
//  Created by jinwei on 15/5/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface CompanyLocationCell : UITableViewCell
{
    UILabel *nameLable;
    UILabel *desLabel;
    UILabel *kilLabel;
}

- (void)changeDataFrom:(BMKPoiInfo *)info withCenter:(CLLocationCoordinate2D)center;


@end
