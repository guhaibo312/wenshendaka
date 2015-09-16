//
//  SpecialCell.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SpecialCell.h"

@interface SpecialCell()

@property (weak, nonatomic) IBOutlet UIView *bjImage;


@end

@implementation SpecialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bjImage.layer.cornerRadius = 8;
    self.bjImage.layer.masksToBounds = YES;
}

+ (instancetype)specialCellWithTableView : (UITableView *)tableView
{
    static NSString *ID = @"special";
    SpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [SpecialCell specialCellWithTableView];
    }
    return cell;
}

+ (instancetype)specialCellWithTableView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SpecialCell" owner:nil options:nil] lastObject];
}

@end
