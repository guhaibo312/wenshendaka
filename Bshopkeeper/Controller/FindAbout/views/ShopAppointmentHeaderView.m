//
//  ShopAppointmentHeaderView.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ShopAppointmentHeaderView.h"
#import "Configurations.h"

@interface ShopAppointmentHeaderView()

@property (weak, nonatomic) IBOutlet UIView *bjView;

@end

@implementation ShopAppointmentHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bjView.layer.cornerRadius = 8;
    self.bjView.layer.masksToBounds = YES;
    self.bjView.layer.borderWidth = 1;
    self.bjView.layer.borderColor = LINECOLOR.CGColor;
    
}

+ (instancetype)shopAppointmentHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ShopAppointmentHeaderView" owner:nil options:nil] firstObject];
}

- (IBAction)appointClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shopAppointmentHeaderViewDidClick:)]) {
        [self.delegate shopAppointmentHeaderViewDidClick:self];
    }
}

@end
