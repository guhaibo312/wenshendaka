//
//  QrCodeViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/9.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "QrCodeViewController.h"
#import "UIImageView+WebCache.h"
#import "QRCodeGenerator.h"
#import "MobClick.h"
#import "UMSocialQQHandler.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+ResizeImage.h"

@interface QrCodeViewController ()<JWSharedManagerDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>

{
    UIImage *qrImg;
    
}
@end

@implementation QrCodeViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([NSObject nulldata:[User defaultUser].item.nickname]) {
        self.title = [User defaultUser].item.nickname;
    }

    
    UIImageView *topImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 160)];
    topImg.backgroundColor = [UIColor whiteColor];
    topImg.contentMode = UIViewContentModeScaleAspectFill;
    topImg.clipsToBounds = YES;
    topImg.image = [UIImage imageNamed:@"icon_userHead_default.png"];
    if ([User defaultUser].item.avatar) {
        [topImg sd_setImageWithURL:[NSURL URLWithString:[User defaultUser].item.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                topImg.image = [image drn_boxblurImageWithBlur:0.7];
            }
            
        }];
    }
    [self.view addSubview:topImg];
    
    ArcView *oneArcView = [[ArcView alloc]initWithFrame:CGRectMake(0, 104, SCREENWIDTH, 80) withColor:nil];
    [self.view addSubview:oneArcView];
    
    UIImageView *shopImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-40, 84, 80, 80)];
    shopImg.image = [UIImage imageNamed:@"icon_userHead_default.png"];
    if ([User defaultUser].item.avatar) {
        [shopImg sd_setImageWithURL:[NSURL URLWithString:[User defaultUser].item.avatar] placeholderImage:[UIImage imageNamed:@"icon_userHead_default.png"]];
    }
    shopImg.layer.borderWidth = 2;
    shopImg.layer.borderColor = [UIColor whiteColor].CGColor;
    shopImg.layer.cornerRadius = 40;
    shopImg.contentMode = UIViewContentModeScaleAspectFill;
    shopImg.clipsToBounds = YES;
    [self.view addSubview:shopImg];
    
    
    UIImageView *codeImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-90, shopImg.bottom+30, 180, 180)];
    codeImg.image = [UIImage imageNamed:@"icon_image_default.png"];
    NSString *urlStr =  API_SHAREURL_STORE([User defaultUser].storeItem.storeId);
    if (urlStr) {
        
        qrImg = [QRCodeGenerator qrImageForString:urlStr imageSize: codeImg.bounds.size.width];
         codeImg.image = qrImg ;
        
    }
    UITapGestureRecognizer *tapCodeImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCodeImgAction:)];
    tapCodeImg.delegate = self;
    codeImg.userInteractionEnabled = YES;
    [codeImg addGestureRecognizer:tapCodeImg];
    [self.view addSubview:codeImg];
    
    UILabel *promptLabel = [UILabel labelWithFrame:CGRectMake(20, codeImg.bottom + 10, SCREENWIDTH - 40, 20) fontSize:16 fontColor:[UIColor blackColor] text:@"二维码保存到相册后，"];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:promptLabel];
    
    UILabel *promptLabel1 = [UILabel labelWithFrame:CGRectMake(20, promptLabel.bottom, SCREENWIDTH - 40, 20) fontSize:16 fontColor:[UIColor blackColor] text:@"可印在名片上或张贴在门店里。"];
    promptLabel1.textAlignment =  NSTextAlignmentCenter;
    [self.view addSubview:promptLabel1];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 24, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"back_img_white.png"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *backToBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backToBtn.frame = CGRectMake(SCREENWIDTH-50, 20 , 45, 45);
    [backToBtn setImage:[UIImage imageNamed:@"icon_moreList_white.png"] forState:UIControlStateNormal];
    backToBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 0);
    [backToBtn addTarget:self action:@selector(rightNavigationBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToBtn];

}



- (void)rightNavigationBarAction:(UIButton *)sender
{
    [self tapCodeImgAction:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机",@"分享" ,nil];
    [action showInView:self.view];
    return NO;
}

- (void)tapCodeImgAction:(UITapGestureRecognizer *)sender
{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机",@"分享" ,nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
        [assetsLibrary writeImageToSavedPhotosAlbum:[qrImg CGImage] orientation:(ALAssetOrientation)qrImg.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"保存失败"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            }
        }];
    }else if (buttonIndex == 1){
        [self shareQrcodeFunction];
    }
}

#pragma mark --  分享二维码
- (void)shareQrcodeFunction
{
    SharedItem *shareItem = [[SharedItem alloc] init];
    
    NSMutableString *title =  [NSMutableString stringWithFormat:@"%@",[MobClick getConfigParams: @"share_qrcode_title"]];
    if (title) {
        while ([title rangeOfString:@"%@"].location != NSNotFound) {
            [title replaceOccurrencesOfString:@"%@" withString:[User defaultUser].item.nickname options:NSCaseInsensitiveSearch range:[title rangeOfString:@"%@"]];
        }
        
    }else{
        title = (NSMutableString *)[User defaultUser].item.nickname;
    }
    shareItem.title = title;
    NSString *content = [MobClick getConfigParams: @"share_qrcode_content"];
    if (!content) {
        content = @"这个掌柜的手机很不错，快来看看吧";
    }
    shareItem.content = content;
    NSString *urlStr =  API_SHAREURL_STORE([User defaultUser].storeItem.storeId);
    shareItem.sharedURL = urlStr;
    
    shareItem.shareImg = qrImg?qrImg:[UIImage imageNamed:@"icon-60@2x.png"];
    JWShareView *shareView = [[JWShareView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) withShareTypes:nil dataItem:shareItem UIViewController:self];
    [shareView show];
    
}

- (void)backAction
{
    [super backAction];
}
@end


@implementation ArcView

- (instancetype)initWithFrame:(CGRect)frame withColor:(UIColor *)aColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _bolderColor = aColor;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, _bolderColor?_bolderColor.CGColor:VIEWBACKGROUNDCOLOR.CGColor);
    CGContextMoveToPoint(context, 0, 40);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, SCREENWIDTH/2 , 0 , SCREENWIDTH, 40, SCREENWIDTH*2.9);
    CGContextAddLineToPoint(context, SCREENWIDTH, 80);
    CGContextAddLineToPoint(context, 0, 80);
    CGContextAddLineToPoint(context, 0, 40);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}
@end

