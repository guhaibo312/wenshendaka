//
//  ShopUserView.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/9.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ShopUserView.h"
#import "UIImageView+WebCache.h"
#import "ShopUser.h"
#import "Configurations.h"
#import "ShopCompany.h"

@interface ShopUserView()

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *admin;
@end

@implementation ShopUserView

+ (instancetype)shopUserView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ShopUserView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.headerIcon.layer.cornerRadius = 25;
    self.headerIcon.layer.masksToBounds = YES;
    
    [super awakeFromNib];
}

- (void)setUser:(ShopUser *)user
{
    _user = user;
    
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:[UIImage imageNamed:@"icon-60@2x.png"]];
    self.name.text = self.user.nickname;
}

- (void)setCompany:(ShopCompany *)company
{
    _company = company;
    
    if ([NSObject nulldata:self.user.userId ] && [NSObject nulldata:self.company.ownerId]) {
        if ([self.user.userId isEqualToString:self.company.ownerId]) {//店主
            self.admin.text = @"主理人";
            self.admin.hidden = NO;
        }else
        {
            for (NSString *adminId in self.company.adminIdList) {
                if ([StringFormat(self.user.userId) isEqualToString:StringFormat(adminId)]) {
                    self.admin.text = @"管理员";
                    self.admin.hidden = NO;
                }else
                {
                    self.admin.hidden = YES;
                }
            }
        }
    }
}


- (IBAction)headerClick:(id)sender {
    NSDictionary *userInfo = @{@"userId":self.user.userId};
    
    [HBNotificationCenter postNotificationName:ShopUserNocificationKey object:nil userInfo:userInfo];
}

@end
