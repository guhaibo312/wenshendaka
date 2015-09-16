//
//  ShopCardController.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/8.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ShopCardController.h"
#import "Configurations.h"
#import "BaseNavigationViewController.h"
#import "ShopModel.h"
#import "ShopFinishController.h"

@interface ShopCardController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIImageView *addView;
@property (weak, nonatomic) IBOutlet UILabel *cardView;
@property (nonatomic,strong) UIImage *headImage;

@end

@implementation ShopCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建店铺";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
 
    self.bjView.layer.cornerRadius = 8;
    self.bjView.layer.masksToBounds = YES;
    self.bjView.layer.borderWidth = 0.5;
    self.bjView.layer.borderColor = LINECOLOR.CGColor;
}

- (void)finish
{
    
    if (self.headImage) {
        [UploadManager uploadImageList: [NSArray arrayWithObject:self.headImage] hasLoggedIn: YES success:^(NSArray *resultList) {
            [self uploadData:[resultList firstObject]];
        } failure:^(NSError *error) {
            [LoadingView dismiss];
            [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
        }];
    }else{
        [self uploadData:nil];
    }
}

- (void)uploadData : (NSString *)businessLicense
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = self.shopModel.citycode;
    params[@"province"] = self.shopModel.province;
    params[@"area"] = self.shopModel.area;
    params[@"name"] = self.shopModel.name;
    params[@"address"] = self.shopModel.address;
    if (businessLicense) {
        params[@"businessLicense"] = self.shopModel.businessLicense;
    }
    params[@"location"] = self.shopModel.location;
    
    [[JWNetClient defaultJWNetClient] putNetClient:@"CompanyApplication/info" requestParm:params result:^(id responObject, NSString *errmsg) {
        if (!errmsg) {
            ShopFinishController *shopVc = [[ShopFinishController alloc] init];
            shopVc.myShop = NO;
            [self.navigationController pushViewController:shopVc animated:YES];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }
    }];
}

- (IBAction)uploadImage:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 拍照
        UIImagePickerController* controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        // 拍照
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
        // 媒体库
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if([controller.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            [controller.navigationBar setBackgroundImage:[UIUtils imageFromColor:NAVIGATIONCOLOR] forBarMetrics:UIBarMetricsDefault];
            controller.navigationBar.tintColor = [UIColor whiteColor];
        }
        [self.navigationController presentViewController: controller
                                                animated: YES
                                              completion: NULL];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    self.headImage = image;
    self.headerImage.image = image;
    [picker dismissViewControllerAnimated: YES completion: NULL];
    self.addView.hidden = YES;
    self.cardView.hidden = YES;
}

@end
