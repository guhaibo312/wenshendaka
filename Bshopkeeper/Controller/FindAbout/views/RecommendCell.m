//
//  RecommendCell.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "RecommendCell.h"

@interface RecommendCell()

@property (weak, nonatomic) IBOutlet UIImageView *bjImage;


@end

@implementation RecommendCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.bjImage.layer.cornerRadius = 8;
    self.bjImage.layer.masksToBounds = YES;
}

+ (instancetype)recommendCellWithTableView : (UITableView *)tableView
{
    static NSString *ID = @"recommend";
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [RecommendCell recommendCell];
    }
    return cell;
}

+ (instancetype)recommendCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"RecommendCell" owner:nil options:nil] lastObject];
}

@end
