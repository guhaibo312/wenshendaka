//
//  ShopAppointmentCell.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ShopAppointmentCell.h"
#import "UIImageView+WebCache.h"
#import "ShopAppointment.h"
#import "Configurations.h"
#import "NSString+Extension.h"
#import "ShopAppointment.h"
#import "ShopProductModelObject.h"
#import "ShopInfoModel.h"
#import "CompanyInfoItem.h"

@interface ShopAppointmentCell()

@property (weak, nonatomic) IBOutlet UIView *bjImage;

@property (weak, nonatomic) IBOutlet UIImageView *haderIcon;
@property (weak, nonatomic) IBOutlet UILabel *identity;
@property (weak, nonatomic) IBOutlet UILabel *hot;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *threadImage;
@property (weak, nonatomic) IBOutlet UIImageView *moreView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (nonatomic,copy) NSString *selectUserId;

@end

@implementation ShopAppointmentCell

+ (instancetype)shopAppointmentCellWithTableView: (UITableView *)tableView
{
    static NSString *ID = @"appointment";
    ShopAppointmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [ShopAppointmentCell shopAppointmentCell];
    }
    return cell;
}

+ (instancetype)shopAppointmentCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ShopAppointmentCell" owner:nil options:nil] firstObject];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bjImage.layer.cornerRadius = 8;
    self.bjImage.layer.masksToBounds = YES;
    
    [self setRadius:self.firstImage];
    [self setRadius:self.secondImage];
    [self setRadius:self.threadImage];
    
    self.haderIcon.layer.cornerRadius = 25;
    self.haderIcon.layer.masksToBounds = YES;
    self.haderIcon.layer.borderWidth = 2;
    self.haderIcon.layer.borderColor = HBRGB(253, 144, 0).CGColor;
    
    self.identity.layer.cornerRadius = 15;
    self.identity.layer.masksToBounds = YES;
    
    [self.moreButton addTarget:self action:@selector(moreButtonClick :) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)moreButtonClick : (UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(shopAppointmentCellDidClick:button:userId:)]) {
        [self.delegate shopAppointmentCellDidClick:self button:button userId:self.selectUserId];
    }
}

 -(void)setShopInfo:(ShopInfoModel *)shopInfo
{
    _shopInfo = shopInfo;
    
    [self setHeaderAndIdentity];
    
    [self setMoreButton];
    
}

- (void)setMoreButton
{
//    [User defaultUser].item.userId = @"100626"; //普通人
//    [User defaultUser].item.userId = @"100081"; //受理人
//    [User defaultUser].item.userId = @"100610";//管理员
//    [User defaultUser].item.userId = @"100699";//陌生人
    
    if ([StringFormat([User defaultUser].item.userId) isEqualToString:StringFormat(self.shopInfo.company.ownerId)]) { //店主身份进来的
        
        if ([StringFormat(self.shop.userId) isEqualToString:StringFormat(self.shopInfo.company.ownerId)]) {//当前cell是店主
            self.moreView.hidden = YES;
            self.moreButton.enabled = NO;
        }else
        {
            self.moreView.hidden = NO;
            self.moreButton.enabled = YES;
            
            for (NSString *adminId in self.shopInfo.company.adminIdList) {
                
                if ([StringFormat(self.shop.userId) isEqualToString:StringFormat(adminId)]) {//当前cell是管理员
                    self.moreButton.tag = MoreButtontTypeOwnerManager;
                    self.selectUserId = self.shop.userId;
                }else
                {//当前身份是普通人
                    self.moreButton.tag = MoreButtontTypeOwnerOrdinary;
                    self.selectUserId = self.shop.userId;
                }
            }
        }
    }else
    {
        self.moreView.hidden = YES;
         self.moreButton.enabled = NO;
        for (NSString *adminId in self.shopInfo.company.adminIdList) {
            
            if ([StringFormat([User defaultUser].item.userId) isEqualToString:StringFormat(adminId)]) {//管理员身份进来的
                if ([StringFormat(self.shop.userId) isEqualToString:StringFormat(adminId)]) {
                    //当前cell是管理员
                    
                    if ([StringFormat(self.shop.userId) isEqualToString:StringFormat(StringFormat([User defaultUser].item.userId))]) {
                        //当前是自己
                        self.moreView.hidden = NO;
                         self.moreButton.enabled = YES;
                        self.moreButton.tag = MoreButtontTypeManagerMine;
                        self.selectUserId = self.shop.userId;
                    }else
                    {//别的管理员
                        self.moreView.hidden = YES;
                        self.moreButton.enabled = NO;
                    }
                }else
                {
                    if ([StringFormat(self.shop.userId) isEqualToString:StringFormat(self.shopInfo.company.ownerId)]) {//当前cell受理人
                        self.moreView.hidden = YES;
                        self.moreButton.enabled = NO;
                    }else
                    {//当前cell是普通人
                        self.moreView.hidden = NO;
                        self.moreButton.enabled = YES;
                        self.moreButton.tag = MoreButtontTypeOrdinary;
                        self.selectUserId = self.shop.userId;
                    }
                }
            }else
            {
                //普通人身份进来的
                if ([StringFormat(self.shop.userId) isEqualToString:StringFormat(StringFormat([User defaultUser].item.userId))]) {
                    //当前是我自己
                    self.moreView.hidden = NO;
                    self.moreButton.enabled = YES;
                    self.moreButton.tag = MoreButtontTypeOrdinary;
                    self.selectUserId = self.shop.userId;
                }else
                {
                    self.moreView.hidden = YES;
                    self.moreButton.enabled = NO;
                }
            }
        }
        
        
    }
}


- (void)setHeaderAndIdentity
{
    if ([StringFormat(self.shop.userId) isEqualToString:StringFormat(self.shopInfo.company.ownerId)]) {
        self.identity.text = @"主理";
        self.identity.hidden = NO;
        self.identity.backgroundColor = HBRGB(253, 144, 0);
        self.haderIcon.layer.borderColor = HBRGB(253, 144, 0).CGColor;
    }else
    {
        self.identity.hidden = YES;
        self.haderIcon.layer.borderColor = HBRGB(111, 95, 92).CGColor;
        for (NSString *adminId in self.shopInfo.company.adminIdList) {
            
            if ([StringFormat(self.shop.userId) isEqualToString:StringFormat(adminId)]) {
                self.identity.text = @"管";
                self.identity.backgroundColor = HBRGB(111, 95, 92);
                self.identity.hidden = NO;
            }else
            {
                self.identity.hidden = YES;
            }
        }
    }
}

- (void)setRadius : (UIView *)view
{
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 2;
    view.layer.borderColor = TAGSCOLORFORE.CGColor;
}

- (void)setShop:(ShopAppointment *)shop
{
    _shop = shop;
    
    [self.haderIcon sd_setImageWithURL:[NSURL URLWithString:self.shop.avatar] placeholderImage:[UIImage imageNamed:@"icon-60@2x.png"]];
    self.nickname.text = self.shop.nickname;
    
    NSString *hot = self.shop.hot;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",hot] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:SEGMENTSELECT}];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"人气" attributes:dict]];
    self.hot.attributedText = attributedText;
    
    
    NSArray* constrains = self.nickname.constraints;
    for (NSLayoutConstraint* constraint in constrains) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth) {
            if ([NSObject nulldata:self.shop.nickname]) {
                CGFloat nicknameW = [self.shop.nickname sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(self.width, MAXFLOAT)].width;
                constraint.constant = nicknameW + 10;
            }
        }
    }
    
    
    NSArray *productList = self.shop.products;
    int count = (int)productList.count;

    switch (count) {
        case 0:
            self.firstImage.image = nil;
            self.secondImage.image = nil;
            self.threadImage.image = nil;
            break;
            
        case 1:
            [self setImage:productList[0] imageView:self.firstImage];
            self.secondImage.image = nil;
            self.threadImage.image = nil;
            break;
        case 2:
            [self setImage:productList[0] imageView:self.firstImage];
            [self setImage:productList[1] imageView:self.secondImage];
            self.threadImage.image = nil;
            break;
        case 3:
            [self setImage:productList[0] imageView:self.firstImage];
            [self setImage:productList[1] imageView:self.secondImage];
            [self setImage:productList[2] imageView:self.threadImage];
            break;
    }
}

- (void)setImage : (ShopProductModelObject *)product  imageView : (UIImageView *)imageView
{
    if ([NSObject nulldata:product]) {
        [imageView sd_setImageWithURL:[product.images firstObject] placeholderImage:[UIImage imageNamed:@"icon-60@2x.png"]];
    }
}

@end
