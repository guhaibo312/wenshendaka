//
//  ShopDetailController.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/8.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ShopDetailController.h"
#import "ShopDetailHeaderView.h"
#import "Configurations.h"
#import "CompanyInfoItem.h"
#import "ShopInfoModel.h"
#import "MJExtension.h"
#import "ShopProductListViewController.h"
#import "SquareUserPageViewController.h"
#import "AppointmentController.h"
#import "TJWAssetPickerController.h"

@interface ShopDetailController ()<UITableViewDataSource,UITableViewDelegate,ShopDetailHeaderViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, TJWAssetPickerControllerDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) UIView *topNavigationView;

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) ShopDetailHeaderView *headerView;

@property (nonatomic,strong) ShopInfoModel *shopInfo;

@property (nonatomic,strong) UIImageView *headerIcon;

@property (nonatomic,strong) UIImage *headImage;

@property (nonatomic,strong) UIScrollView *bannerScrollView;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) int currentIndex;

@end

@implementation ShopDetailController

- (UIView *)topNavigationView
{
    if (!_topNavigationView) {
        UIView *topNavigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
        
        UILabel *atitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 24, SCREENWIDTH - 80, 40)];
        atitleLabel.text = @"店铺详情";
        [atitleLabel setTextAlignment:1];
        atitleLabel.textColor = [UIColor whiteColor];
        atitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        atitleLabel.backgroundColor = [UIColor clearColor];
        [topNavigationView addSubview:atitleLabel];
        
        [self.view insertSubview:topNavigationView aboveSubview:self.tableView];
        self.topNavigationView = topNavigationView;
    }
    return _topNavigationView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
    return _tableView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"tableView.contentOffset"]) {
        if (self.tableView.contentOffset.y >= 0 && self.tableView.contentOffset.y < 64) {
            
            self.topNavigationView.backgroundColor = RGBACOLOR(54., 50., 49.,self.tableView.contentOffset.y/64);
        }else if (self.tableView.contentOffset.y >= 64){
            self.topNavigationView.backgroundColor = RGBACOLOR(54., 50., 49., 1);
        }else{
            self.topNavigationView.backgroundColor = RGBACOLOR(54., 50., 49., 0);
        }
    }
}

- (ShopDetailHeaderView *)headerView
{
    if (!_headerView) {
        self.headerView = [ShopDetailHeaderView shopDetailHeaderView];
        self.headerView.topBanner.delegate = self;
        self.headerView.companyInfo = self.companyInfo;
        self.tableView.tableHeaderView = self.headerView;
        self.headerView.delegate = self;
    }
    return _headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.headerView.pageCtroller.currentPage = (int)(scrollView.contentOffset.x / self.view.width + 0.5);
}

- (void)shopDetailHeaderViewDidClick:(ShopDetailHeaderView *)shopDetailHeaderView companyId:(NSString *)companyId editable:(BOOL)editable
{
    ShopProductListViewController *shoplistVC = [[ShopProductListViewController alloc]initWithQuery:@{ @"companyId":companyId,@"editable" : @(editable)}];
    [self.navigationController pushViewController:shoplistVC animated:YES];
}

- (void)shopDetailHeaderViewDidAppointment:(ShopDetailHeaderView *)shopDetailHeaderView companyInfo:(CompanyInfoItem *)companyInfo userEditable:(BOOL)userEditable
{
    AppointmentController *appVc= [[AppointmentController alloc] init];
    appVc.shopInfo = self.shopInfo;
    appVc.userEditable = userEditable;
    appVc.companyInfo = self.companyInfo;
    [self.navigationController pushViewController:appVc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableView];

    self.navigationController.navigationBarHidden = YES;
    
    [self setUpShopData];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    [self setUpNav];
    
    [self addObserver:self forKeyPath:@"tableView.contentOffset" options:0x01 context:nil];
    
    [HBNotificationCenter addObserver:self selector:@selector(userClick:) name:ShopUserNocificationKey object:nil];
    
    UIView *footview = [[UIView alloc] init];
    self.tableView.tableFooterView = footview;
    
    if (self.headerView.pageCtroller.numberOfPages > 0) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
        self.timer = timer;
        [timer isValid];
    }

}

- (void)scrollTimer{
    self.currentIndex ++;
    if (self.currentIndex == self.headerView.pageCtroller.numberOfPages) {
        self.currentIndex = 0;
    }
    self.headerView.pageCtroller.currentPage = self.currentIndex;
    //  滚动scrollview
    CGFloat x = self.currentIndex * self.view.width;
    [UIView animateWithDuration:0.2 animations:^{
        self.headerView.topBanner.contentOffset = CGPointMake(x, 0);
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    开启定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
}


- (void)userClick:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    NSString *userId = userInfo[@"userId"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"userId"] = userId;
    SquareUserPageViewController *userVc = [[SquareUserPageViewController alloc] initWithQuery:dict];
    [self.navigationController pushViewController:userVc animated:YES];
}

- (void)setUpShopData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"companyId"] = self.companyInfo.companyId;
    params[@"clerks"] = @"";
    params[@"products"] = @"";
    
    [[JWNetClient defaultJWNetClient] getNetClient:@"Company/info" requestParm:params result:^(id responObject, NSString *errmsg) {
        if (!errmsg) {
            self.shopInfo = [ShopInfoModel objectWithKeyValues:responObject[@"data"]];
            
            self.headerView.shopInfo = self.shopInfo;
        }else
        {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }
    }];
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"tableView.contentOffset"];
    [HBNotificationCenter removeObserver:self name:ShopUserNocificationKey object:nil];
}

- (void)setUpNav
{

    self.topNavigationView.backgroundColor = [UIColor clearColor];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 24, 40, 40)];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    leftBtn.showsTouchWhenHighlighted = NO;
    [leftBtn setImage:[UIImage imageNamed:@"back_img_white.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topNavigationView addSubview:leftBtn];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCompanyInfo:(CompanyInfoItem *)companyInfo
{
    _companyInfo = companyInfo;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"shop";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"shop";
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)shopDetailHeaderViewDidClickHeader:(ShopDetailHeaderView *)shopDetailHeaderView headerIcon:(UIImageView *)headerIcon
{
    //头像
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"取消" destructiveButtonTitle: nil otherButtonTitles: @"拍照", @"从手机相册选择" , nil];
    self.headerIcon = headerIcon;
    [actSheet showInView: self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
        //头像
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
    self.headerIcon.image = image;
    self.headImage = image;
    [picker dismissViewControllerAnimated: YES completion: NULL];
    
    [self uploadHeader];
    
}

- (void)uploadHeader
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
    params[@"companyId"] = self.companyInfo.companyId;
    params[@"logo"] = businessLicense;
    
    [[JWNetClient defaultJWNetClient] postNetClient:@"Company/info" requestParm:params result:^(id responObject, NSString *errmsg) {
        if (!errmsg) {
            [SVProgressHUD showSuccessWithStatus:@"头像已修改"];
        }else
        {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }
    }];
}

- (void)shopDetailHeaderViewDidClickBanner:(ShopDetailHeaderView *)shopDetailHeaderView bannerScrollView:(UIView *)bannerScrollView
{
    self.bannerScrollView = (UIScrollView *)bannerScrollView;
    TJWAssetPickerController *zye = [[TJWAssetPickerController alloc]init];
    if([zye.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [zye.navigationBar setBackgroundImage:[UIUtils imageFromColor:NAVIGATIONCOLOR] forBarMetrics:UIBarMetricsDefault];
        zye.navigationBar.tintColor = [UIColor whiteColor];
    }
    zye.maximumNumberOfSelection = 6;
    zye.assetsFilter = [ALAssetsFilter allPhotos];
    zye.showEmptyGroups = YES;
    zye.TJWdelegate = self;
    zye.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
            return duration >= 5;
        }else{
            
            return  YES;
        }
    }];
    [self.navigationController presentViewController:zye animated:YES completion:nil];
}

#pragma mark --------------------------- tjwphonoDelegate
-(void)assetPickerController:(TJWAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (assets.count > 0) {
    
        for (UIView *view in self.bannerScrollView.subviews) {
            [view removeFromSuperview];
        }
        
        NSArray *tempArray = [NSArray arrayWithArray:assets];
        NSMutableArray *banners = [[NSMutableArray alloc] init];
        
        int count = (int)tempArray.count;
        for (int i = 0 ; i < count; i++) {
            self.headerView.pageCtroller.numberOfPages = count;
            ALAsset *oneAsset=tempArray[i];
            UIImage *tempImg=[UIImage imageWithCGImage:oneAsset.defaultRepresentation.fullScreenImage];
            if (tempImg) {
                [banners addObject:tempImg];
                
                UIImageView *bannerView = [[UIImageView alloc] init];
                bannerView.contentMode = UIViewContentModeScaleAspectFill;
                bannerView.image = tempImg;
                bannerView.width = self.view.width;
                bannerView.height = self.view.height;
                bannerView.x = i * bannerView.width;
                bannerView.y = 0;
                self.bannerScrollView.contentSize = CGSizeMake(self.view.width * tempArray.count, 0);
                [self.bannerScrollView addSubview:bannerView];
            }
        }
        
        [self uploadBanner : banners];
        
    }
    
}

- (void)uploadBanner : (NSMutableArray *)banners
{
    [UploadManager uploadImageList:banners hasLoggedIn:NO success:^(NSArray *resultList) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"companyId"] = self.companyInfo.companyId;
        params[@"topBanner"] = resultList;
        
        [[JWNetClient defaultJWNetClient] postNetClient:@"Company/info" requestParm:params result:^(id responObject, NSString *errmsg) {
            if (!errmsg) {
                [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
            }else
            {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }
        }];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
}

@end
