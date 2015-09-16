//
//  CommodityListCell.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CommodityListCell.h"
#import "UIImageView+WebCache.h"
#import "AddOrEditCommodityViewController.h"
#import "H5PreviewManageViewController.h"
#import "MobClick.h"
#import "UMSocialQQHandler.h"

@interface CommodityListCell ()<UIActionSheetDelegate>
{
    CommodityModel *dataModel;
}
@property (nonatomic, assign) BasViewController<JWSharedManagerDelegate> *ownerController;

@end


@implementation CommodityListCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withcontroller:(BasViewController<JWSharedManagerDelegate> *)controller
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREENWIDTH, 137);
        _ownerController = controller;
        
        //图片
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 66, 66)];
        _headImageView.backgroundColor = [UIColor whiteColor];
        _headImageView.clipsToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.borderWidth = 0.5;
        _headImageView.layer.borderColor = LINECOLOR.CGColor;
        [self.contentView addSubview:_headImageView];
        
        //名称
        nameLabel = [UILabel labelWithFrame:CGRectMake(_headImageView.right+10, 10, SCREENWIDTH-110, 18) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        [self.contentView addSubview:nameLabel];
        
        //时间
        creatTimeLabel = [UILabel labelWithFrame:CGRectMake(SCREENWIDTH - 150, self.height/2-9-22, 115, 18) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
        creatTimeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:creatTimeLabel];
        
        //商品价格
        moneyLabel = [UILabel labelWithFrame:CGRectMake(_headImageView.right +10, nameLabel.bottom+5, 120, 20) fontSize:16 fontColor:[UIColor blackColor] text:@""];
        [self.contentView addSubview:moneyLabel];
        
        
        //预约量
        saleCountLabel = [UILabel labelWithFrame:CGRectMake(_headImageView.right+10, moneyLabel.bottom+10, 160, 15) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
        [self.contentView addSubview:saleCountLabel];
        
        
        //推荐
//        topLabel = [UILabel labelWithFrame:CGRectMake(7, 7, 20, 20) fontSize:12 fontColor:[UIColor blackColor] text:@"荐"];
//        topLabel.layer.borderColor = [UIColor whiteColor].CGColor;
//        topLabel.layer.borderWidth = 1;
//        topLabel.textAlignment = NSTextAlignmentCenter;
//        topLabel.layer.cornerRadius = 10;
//        topLabel.layer.backgroundColor = TABSELECTEDCOLOR.CGColor;
//        [self.contentView addSubview:topLabel];
//        
        //
        UIImageView *point = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-30, self.height/2-6-22, 8, 12)];
        point.image = [UIImage imageNamed:@"icon_right_img.png"];
        [self.contentView addSubview:point];
        
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 87.5, SCREENWIDTH, 0.5)];
        lineView.backgroundColor = LINECOLOR;
        [self.contentView addSubview:lineView];
        
        
       // 预览
        previewBtn = [UserHomeBtn buttonWithFrame:CGRectMake(0, 88, SCREENWIDTH/3, 44) text:@"预览" imageName:@"icon_Gray_Preview.png"];
        [previewBtn addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
        previewBtn.backgroundColor = [UIColor whiteColor];
        previewBtn.desIamgeView.frame = CGRectMake(previewBtn.width/2-22.5, (previewBtn.height-20)/2, 20, 20);
        previewBtn.nameLabel.textAlignment = NSTextAlignmentLeft;
        previewBtn.nameLabel.left = previewBtn.desIamgeView.right+5;
        previewBtn.tag = 100;
        previewBtn.nameLabel.font = [UIFont systemFontOfSize:12];
        previewBtn.nameLabel.textColor = GRAYTEXTCOLOR;
        [self.contentView addSubview:previewBtn];
        
        //复制链接
        editBtn = [UserHomeBtn buttonWithFrame:CGRectMake(SCREENWIDTH/3, 88, SCREENWIDTH/3, 44) text:@"复制链接" imageName:@"icon_Gray_CopyLinks.png"];
        editBtn.nameLabel.textAlignment = NSTextAlignmentLeft;
        editBtn.desIamgeView.frame = CGRectMake(editBtn.width/2-32.5, (editBtn.height-18)/2, 18, 18);
        editBtn.nameLabel.frame = CGRectMake(editBtn.desIamgeView.right+5, 0, 60, 44);
        editBtn.backgroundColor = [UIColor whiteColor];
        editBtn.nameLabel.textAlignment = NSTextAlignmentLeft;
        editBtn.nameLabel.textColor = GRAYTEXTCOLOR;
        editBtn.nameLabel.font = [UIFont systemFontOfSize:12];
        [editBtn addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
        editBtn.tag = 200;
        [self.contentView addSubview:editBtn];
        
        
        //分享
        sharedBtn = [UserHomeBtn buttonWithFrame:CGRectMake(SCREENWIDTH-SCREENWIDTH/3, 88, SCREENWIDTH/3, 44) text:@"分享" imageName:@"icon_Gray_Share.png"];
        sharedBtn.tag = 300;
        sharedBtn.backgroundColor = [UIColor whiteColor];
        sharedBtn.nameLabel.textColor = GRAYTEXTCOLOR;
        sharedBtn.nameLabel.textAlignment = NSTextAlignmentLeft;
        sharedBtn.desIamgeView.frame = CGRectMake(sharedBtn.width/2-22.5, (sharedBtn.height-20)/2, 20, 20);
        sharedBtn.nameLabel.frame = CGRectMake(sharedBtn.desIamgeView.right+5, 0, 60, 44);
        [sharedBtn addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
        sharedBtn.nameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:sharedBtn];
        
        
//        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-5.5, SCREENWIDTH, 0.5)];
//        lineView2.backgroundColor = LINECOLOR;
//        [self.contentView addSubview:lineView2];
        
        bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-5, SCREENWIDTH, 5)];
        bottomView.tag = 101;
        bottomView.backgroundColor =  VIEWBACKGROUNDCOLOR;
        [self.contentView addSubview:bottomView];
        
//        UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-0.5, SCREENWIDTH, 0.5)];
//        lineView3.backgroundColor = LINECOLOR;
//        [self.contentView addSubview:lineView3];
    }
    return self;
}

- (void)changeContentFrom:(CommodityModel *)comModel
{
    
    dataModel = comModel;
    if (comModel) {
        nameLabel.text = comModel.title;
        moneyLabel.text =[NSString stringWithFormat:@"¥ %@",comModel.price];
        creatTimeLabel.text = [UIUtils timeIntoFomart:[comModel.createdTime doubleValue]/1000];
        if (comModel.images) {
            NSArray *tempArray  = (NSArray *)comModel.images;
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:tempArray[0]]];
            [_headImageView sizeThatFits:_headImageView.size];
        }
        if(comModel.saleCount) {
            saleCountLabel.text = [NSString stringWithFormat:@"预约量：%@",comModel.saleCount];
        }else{
            saleCountLabel.text = @"预约量：0";
        }
//        if ([comModel.top integerValue] == 1) {
//            topLabel.hidden = NO;
//        }else{
//            topLabel.hidden = YES;
//        }
    }
}

#pragma mark ---------------------------- 点击预览 编辑 分享的功能
- (void)allAction:(UIButton *)sender
{
    if (sender.tag == 100 ) {//预览
        
        H5PreviewManageViewController *h5manageVC = [[H5PreviewManageViewController alloc]initWithQuery:@{@"urlStr":API_SHAREURL_COMMODICTY([User defaultUser].storeItem.storeId,dataModel._id),@"title":dataModel.title}];
        [self.ownerController.navigationController pushViewController:h5manageVC animated:YES];
        
    }else if (sender.tag == 200){//复制链接
        
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:API_SHAREURL_COMMODICTY([User defaultUser].storeItem.storeId,dataModel._id)];
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        
    }else{
        
        //价目表分享
        SharedItem *shareItem = [[SharedItem alloc] init];
        shareItem.title = @"真的很适合你哦，快点约吧！";
        
        NSString *content = dataModel.title;
        if (dataModel.price) {
            content = [NSString stringWithFormat:@"%@  ¥%@",content,dataModel.price];
        }
        shareItem.content = content;
        NSString *urlStr =  API_SHAREURL_COMMODICTY([User defaultUser].storeItem.storeId,dataModel._id);
        shareItem.sharedURL = urlStr;
        UIImage *shareImg = [UIImage imageNamed:@"icon-60@2x.png"];
        if (_headImageView.image) {
            shareImg = _headImageView.image;
        }
        shareItem.shareImg = shareImg;
        JWShareView *shareView = [[JWShareView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) withShareTypes:nil dataItem:shareItem UIViewController:_ownerController];
        [shareView show];

    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
