//
//  ShopDetailHeaderView.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/8.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ShopDetailHeaderView.h"
#import "UIImageView+WebCache.h"
#import "CompanyInfoItem.h"
#import "Configurations.h"
#import "ShopInfoModel.h"
#import "ShopProductModelObject.h"
#import "UIImageView+WebCache.h"
#import "ShopUserView.h"
#import "ShopUser.h"

@interface ShopDetailHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *hot;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIView *bjImageView;
@property (weak, nonatomic) IBOutlet UIImageView *image0;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIView *personBj;
@property (nonatomic,strong) NSMutableArray *users;
@property (weak, nonatomic) IBOutlet UILabel *userCount;
@property (weak, nonatomic) IBOutlet UIButton *bjImageButton;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UIView *addUserView;
@property (nonatomic,assign) bool editable;
@property (nonatomic,assign) bool userEditable;

@end

@implementation ShopDetailHeaderView

+ (instancetype)shopDetailHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailHeaderView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headerIcon.layer.cornerRadius = 30;
    self.headerIcon.layer.masksToBounds = YES;
    self.headerIcon.layer.borderWidth = 2;
    self.headerIcon.layer.borderColor = TAGSCOLORFORE.CGColor;
    
    self.addView.layer.borderWidth = 1;
    self.addView.layer.borderColor = LINECOLOR.CGColor;
                                         
    [self setRadius:self.bjImageView];
    [self setRadius:self.image0];
    [self setRadius:self.image1];
    [self setRadius:self.image2];
    [self setRadius:self.personBj];
    [self setRadius:self.addView];
    
    self.topBanner.showsHorizontalScrollIndicator = NO;
    self.topBanner.showsVerticalScrollIndicator = NO;
    self.topBanner.pagingEnabled = YES;
    [self.topBanner addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBanner : )]];
}

- (void)changeBanner : (UITapGestureRecognizer *)recognizer
{
    if (self.editable) {
        if ([self.delegate respondsToSelector:@selector(shopDetailHeaderViewDidClickBanner:bannerScrollView:)]) {
            [self.delegate shopDetailHeaderViewDidClickBanner:self bannerScrollView:recognizer.view];
        }
    }
}

- (void)setRadius : (UIView *)view
{
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
}

- (void)setCompanyInfo:(CompanyInfoItem *)companyInfo
{
    _companyInfo = companyInfo;
    
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:self.companyInfo.logo] placeholderImage:[UIImage imageNamed:@"icon-60@2x.png"]];
    
    self.shopName.text = self.companyInfo.name;
    self.hot.text = [self.companyInfo.hot stringValue];
    self.address.text = self.companyInfo.address;
}

- (void)setShopInfo:(ShopInfoModel *)shopInfo
{
    _shopInfo = shopInfo;
    
    [self setUpProduct];
    
    [self setupUser];
    
    [self setUpTopBanner];
}

- (void)setUpProduct
{
    NSArray *productList = self.shopInfo.productList;
    int count = (int)productList.count;
    for (int i = 0 ; i < count; i ++) {
        if (i == 0) {
            [self setImage:productList[i] imageView:self.image0];
        }else if (i == 1)
        {
            [self setImage:productList[i] imageView:self.image1];
        }else if (i == 2)
        {
            [self setImage:productList[i] imageView:self.image2];
        }
    }
    
    if (count == 0) {
        if ([StringFormat([User defaultUser].item.userId) isEqualToString:StringFormat(self.companyInfo.ownerId)]) {
            self.addView.hidden = NO;
        }else
        {
            self.addView.hidden = YES;
        }
    }
}

- (void)setupUser
{
    int count = (int)self.shopInfo.userList.count;
    if (count > 4) {
        count = 4;
    }
    
    self.userCount.text = [NSString stringWithFormat:@"旗下纹身师(%i)",count];
    
    self.users = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        ShopUserView *userView = [ShopUserView shopUserView];
        ShopUser *user = self.shopInfo.userList[i];
        userView.user = user;
        userView.company = self.shopInfo.company;
        [self.users addObject:userView];
        [self.personBj addSubview:userView];
    }
    [self calculateUser];
    
    if ([StringFormat([User defaultUser].item.userId) isEqualToString:StringFormat(self.companyInfo.ownerId)]) {
        self.editable = YES;
        
        if (count == 0) {
            self.addUserView.hidden = NO;
        }else
        {
            self.addUserView.hidden = YES;
        }
    }else
    {
        self.editable = NO;
        for (NSString *adminId in self.shopInfo.company.adminIdList) {
            
            if ([StringFormat([User defaultUser].item.userId) isEqualToString:StringFormat(adminId)]) {
                self.editable = YES;
            }else
            {
                self.editable = NO;
            }
        }
        
    }
    
    [self.bjImageButton addTarget:self action:@selector(bjImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpTopBanner
{
    int count = (int)self.shopInfo.company.topBanner.count;
    self.pageCtroller.numberOfPages = count;
    if ( count > 0 ) {
        self.topBanner.hidden = NO;
        self.pageCtroller.hidden = NO;
        for (int i = 0 ; i < count; i ++) {
            UIImageView *banner =[[UIImageView alloc] init];
            banner.contentMode = UIViewContentModeScaleAspectFill;
            [banner sd_setImageWithURL:[NSURL URLWithString:self.shopInfo.company.topBanner[i]] placeholderImage:[UIImage imageNamed:@"icon-60@2x.png"]];
            self.topBanner.contentSize = CGSizeMake(self.width * count, 0);
            banner.width = self.topBanner.width;
            banner.height = self.topBanner.height;
            banner.x = banner.width * i;
            banner.y = 0;
            [self.topBanner addSubview:banner];
        }
    }else
    {
        self.topBanner.hidden = YES;
        self.pageCtroller.hidden = YES;
    }
}

- (IBAction)addViewClick:(id)sender {
    [self bjImageButtonClick];
}

- (void)bjImageButtonClick
{
    if ([self.delegate respondsToSelector:@selector(shopDetailHeaderViewDidClick:companyId:editable:)]) {
        [self.delegate shopDetailHeaderViewDidClick:self companyId:StringFormat(self.companyInfo.companyId) editable:self.editable];
    }
}

- (void)setImage : (ShopProductModelObject *)product  imageView : (UIImageView *)imageView
{
    if ([NSObject nulldata:product]) {
        [imageView sd_setImageWithURL:[product.images firstObject] placeholderImage:[UIImage imageNamed:@"icon-60@2x.png"]];
    }
}

- (void)calculateUser
{
    int count = (int)self.users.count;
    CGFloat userW = self.personBj.width / 4;
    for (int i = 0 ; i < count ; i ++) {
        ShopUserView *userView = self.users[i];
        userView.width = userW;
        userView.height = self.height;
        userView.x = userW * i ;
        userView.y = 0 ;
    }
    [self setNeedsLayout];
}

- (IBAction)orderUser:(id)sender {
    
    self.userEditable = NO;
    
    if ([StringFormat([User defaultUser].item.userId) isEqualToString:StringFormat(self.companyInfo.ownerId)]) {
        self.userEditable = YES;
    }else
    {
        for (NSString *adminId in self.shopInfo.company.adminIdList) {
            
            if ([StringFormat([User defaultUser].item.userId) isEqualToString:StringFormat(adminId)]) {
                self.userEditable = YES;
            }else
            {
                self.userEditable = NO;
            }
        }
        
    }
    
    
    if ([self.delegate respondsToSelector:@selector(shopDetailHeaderViewDidAppointment:companyInfo:userEditable:)]) {
        [self.delegate shopDetailHeaderViewDidAppointment:self companyInfo:self.companyInfo userEditable:self.userEditable];
    }
}

- (IBAction)changeHeader:(id)sender {
    if (self.editable) {
        if ([self.delegate respondsToSelector:@selector(shopDetailHeaderViewDidClickHeader:headerIcon:)]) {
            [self.delegate shopDetailHeaderViewDidClickHeader:self headerIcon:self.headerIcon];
        }
    }
}


@end
