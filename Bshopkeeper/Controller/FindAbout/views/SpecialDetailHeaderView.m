//
//  SpecialDetailHeaderView.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SpecialDetailHeaderView.h"
#import "Configurations.h"
#import "CWStarRateView.h"
#import "SquareInfoDetailHead.h"

@interface SpecialDetailHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIScrollView *bannerView;
@property (nonatomic,strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet CWStarRateView *startView;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *fromView;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation SpecialDetailHeaderView

+ (instancetype)specialDetailHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SpecialDetailHeaderView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headerView.layer.cornerRadius = 25;
    self.headerView.layer.masksToBounds = YES;
    
    self.orderButton.layer.cornerRadius = 8;
    self.orderButton.layer.masksToBounds = YES;
    
    self.bannerView.contentSize = CGSizeMake(self.imageView.width, 0);
    
    self.bannerView.showsHorizontalScrollIndicator = NO;
    self.bannerView.showsVerticalScrollIndicator = NO;
}

- (void)setIsUp:(bool)isUp
{
    _isUp  = isUp;
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preview:)]];
    self.imageView.tag = 0;
    self.imageView.image = [UIImage imageNamed:@"UserHome_default1_img.png"];
    self.imageView.frame = CGRectMake(0, 0, self.bannerView.width, self.bannerView.height);
    [self.bannerView addSubview:self.imageView];
    
    //标签
//    NSString *tags = @"胸部#胸部#胸部#胸部#胸部#胸部#胸部";
    NSString *tags = @"";
    
    if (tags.length > 0) {
        SquareInfoDetailTag *tag = [[SquareInfoDetailTag alloc]initWithFrame:CGRectMake(0, 0, self.width + 10, self.height) withTag:nil];
        tag.x = -10;
        [tag setTagStr:tags];
        [self.tagView addSubview:tag];
        self.height = 460;
    }else
    {
        NSArray* constrains = self.tagView.constraints;
        for (NSLayoutConstraint* constraint in constrains) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = 0;
            }
        }
        
        self.height = 430;
    }
}

- (void)preview : (UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *selectImageView = (UIImageView*)gestureRecognizer.view;
    if ([self.delegate respondsToSelector:@selector(specialDetailHeaderViewDidClick:index:)]) {
        [self.delegate specialDetailHeaderViewDidClick:self index:selectImageView.tag];
    }
}

@end
