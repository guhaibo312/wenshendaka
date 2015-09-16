//
//  UserPageViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/21.
//  Copyright (c) 2015年 jinwei. All rights reserved.
// 微名片

#import "UserPageViewController.h"
#import "StoreInfoSettingsViewController.h"
#import "UserHomeHeadView.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "PECropViewController.h"
#import "ProductCollectionObject.h"
#import "SquareLikeButton.h"
#import "JWShareView.h"
#import "MobClick.h"


@interface UserPageViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PECropViewControllerDelegate>
{
    UserHomeHeadView *headView;
    
    UIImage *currentImg;
    ProductCollectionObject *productManage;

}

@end

@implementation UserPageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
//     初始化
    [self initViewSubViews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeActionFromHead) name:kEDITUSERINFOSUCESS object:nil];
}

#pragma mark ----------------------------------  初始化
- (void)initViewSubViews
{
    
    headView = [[UserHomeHeadView alloc]initWithOwnerViewController:self];
    [headView changeAction];
    [headView setHeadViewClickAction:@selector(clickHeadViewAction:) withTarget:self];
    
    UITapGestureRecognizer *tapBackImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickUserHeadChangeBackGround:)];
    [headView.backImgView addGestureRecognizer:tapBackImg];
    headView.backImgView.userInteractionEnabled = YES;
    
    productManage = [[ProductCollectionObject alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-49) ownerController:self];
    productManage.headView = headView;
    productManage.productCollection.backgroundColor = TAGBODLECOLOR;
    [self.view addSubview:productManage.productCollection];
    [productManage setupRefreshProduct];

    UIButton * shareButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 24, 40, 40)];
    [shareButton setImage:[UIImage imageNamed:@"icon_mypage_share.png"] forState:UIControlStateNormal];
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [shareButton addTarget:self action:@selector(shareButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];

}
#pragma mark --分享
- (void)shareButtonFunction:(UIButton *)sender
{
    
    [MobClick event:@"30_click_micro_card_share"];
    SharedItem *shareItem = [[SharedItem alloc] init];
    shareItem.title = [NSString stringWithFormat:@"%@的微名片",[User defaultUser].item.nickname];
    shareItem.content = @"我的作品都在里面，进来看看吧！";
    NSString *urlStr =  API_SHAREURL_STORE([User defaultUser].storeItem.storeId);
    shareItem.sharedURL = urlStr;
    shareItem.shareImg = [headView getUserHeadImg];
    JWShareView *shareView = [[JWShareView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) withShareTypes:nil dataItem:shareItem UIViewController:self];
    [shareView show];
    
    
}

#pragma mark ---------------------- 点击更换背景

- (void)clickUserHeadChangeBackGround:(UITapGestureRecognizer *)tap
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    actionSheet.tag =5;
    [actionSheet showFromToolbar:self.navigationController.toolbar];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //背景
    if (actionSheet.tag == 5) {
        if (buttonIndex == 0) {
            // 拍照
            UIImagePickerController* controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] ) {
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                controller.showsCameraControls = YES;
            } else {
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [self.navigationController presentViewController: controller
                                                    animated: YES
                                                  completion: NULL];
        } else if(buttonIndex == 1) {
            
            // 选取照片
            UIImagePickerController* controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            if([controller.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                [controller.navigationBar setBackgroundImage:[UIUtils imageFromColor:NAVIGATIONCOLOR] forBarMetrics:UIBarMetricsDefault];
                controller.navigationBar.tintColor = [UIColor whiteColor];
            }
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.navigationController presentViewController: controller
                                                    animated: YES
                                                  completion: NULL];
        }
        return;
        
    }
}
#pragma mark ----------------------------- UIImagePickerViewControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = image;
    [picker pushViewController:controller animated:YES];
    
    
}

#pragma mark -

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{

//    CGSize imagesize = CGSizeMake(1080, 432);
//    UIImage *changedimg = [UIImage imageWithImage:croppedImage scaledToSize:imagesize];
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    if (croppedImage) {
        currentImg = croppedImage;
        headView.backImgView.image = currentImg;
        self.view.userInteractionEnabled = YES;
        [UploadManager uploadImageList: [NSArray arrayWithObject:currentImg] hasLoggedIn: YES success:^(NSArray *resultList) {
            if (self == NULL) return ;
            if (resultList.count >0) {

                [LoadingView show:@"请稍候..."];
                [[JWNetClient defaultJWNetClient]postNetClient:@"Store/info" requestParm:@{@"topBanner":[resultList firstObject]} result:^(id responObject, NSString *errmsg) {
                    [LoadingView dismiss];
                    if (self == NULL) return ;
                    self.view.userInteractionEnabled = YES;
                    if (errmsg) {
                        [SVProgressHUD showErrorWithStatus:errmsg];
                    }else{
                        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                        NSDictionary *dict = [[responObject objectForKey:@"data"]objectForKey:@"changedData"];
                        if (dict[@"topBanner"]) {
                            [[User defaultUser] changeUserInfo:nil storeInf:@{@"topBanner":dict[@"topBanner"]}];
                        }
                        headView.backImgView.image = currentImg;
                    }
                }];

            }else{
                [LoadingView dismiss];
                self.view.userInteractionEnabled = YES;
                [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
            }
        } failure:^(NSError *error) {
            [LoadingView dismiss];
            self.view.userInteractionEnabled = YES;
            [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
        }];

    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller.navigationController popViewControllerAnimated:YES];
}


#pragma mark ----------------------- 点击头像区域进去微名片设置

- (void)clickHeadViewAction:(id)sender
{
    StoreInfoSettingsViewController *storeInfo = [[StoreInfoSettingsViewController alloc]init];
    [self.navigationController pushViewController:storeInfo animated:YES];
    
}

#pragma mark ------------------------ 分享回调
- (void)sharedResultCallBack:(BOOL)isSucess info:(NSString *)result
{
    if (isSucess) {
        [SVProgressHUD showSuccessWithStatus:result];
    }else{
        [SVProgressHUD showErrorWithStatus:result];
    }
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    productManage.supController = nil;
    productManage = nil;
    headView = nil;
}


- (void)backAction
{
    if (productManage) {
        productManage.supController = nil;
    }
   
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [LoadingView dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)changeActionFromHead
{
    if (headView) {
        [headView changeAction];
        [productManage.productCollection reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

