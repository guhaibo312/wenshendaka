//
//  BasViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "BasViewController.h"
#import "LoadingView.h"
#import "UIViewExt.h"
#import "Configurations.h"
#import "LogInViewController.h"
#import "MobClick.h"
#import "SDWebImageManager.h"

@interface BasViewController ()
@end

@implementation BasViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *sector = @"0";
    if ([User defaultUser].item) {
        sector = [User defaultUser].item.sector;
    }
     [MobClick beginLogPageView:[NSString stringWithFormat:@"%@%@",[[self class]description ],sector]];
//    self.navigationItem.backBarButtonItem = NULL;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [LoadingView dismiss];
    NSString *sector = @"0";
    if ([User defaultUser].item) {
        sector = [User defaultUser].item.sector;
    }
    [MobClick endLogPageView:[NSString stringWithFormat:@"%@%@",[[self class]description ],sector]];
    UIView *progressView = [[UIApplication sharedApplication].keyWindow viewWithTag:787];
    if (progressView) {
        [progressView removeFromSuperview];
        progressView = nil;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (id) initWithQuery:(NSDictionary*) query {
    self = [self initWithNibName: nil bundle: nil];
    if (self) {
    
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //去掉iOS7后tableview header的延伸高度。。适配iOS7
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.automaticallyAdjustsScrollViewInsets = NO;
            //去掉iOS7透明效果
            self.navigationController.navigationBar.translucent = NO;
            
//            //设置状态栏颜色
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        }
        
        //默认都有backButton
        _isBackButton = YES;
        
        //默认没有模态返回
        _isModelBack = NO;
        
        self.hidesBottomBarWhenPushed = YES;
    
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //去掉iOS7后tableview header的延伸高度。。适配iOS7
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.automaticallyAdjustsScrollViewInsets = NO;
            //去掉iOS7透明效果
            self.navigationController.navigationBar.translucent = NO;
        }
        
        //默认都有backButton
        _isBackButton = YES;
        
        //默认没有模态返回
        _isModelBack = NO;
        self.hidesBottomBarWhenPushed = YES;
        

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = VIEWBACKGROUNDCOLOR;
    
    //导航的viewController数组,第一个就是根控制器，第二个是推送的。从1开始的
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && self.isBackButton) {

        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_img_white.png"] style:0 target:self action:@selector(backAction)];
        barButtonItem.tintColor = [UIColor whiteColor];
        [barButtonItem setImageInsets:UIEdgeInsetsMake(10, 0, 10, 20)];
        
        UIView *view = [[UIView alloc] init];
        view.width = 30;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.leftBarButtonItems = @[barButtonItem,item];

    }
    
    if (self.isModelBack) {
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
        leftBtn.showsTouchWhenHighlighted = NO;
        [leftBtn setImage:[UIImage imageNamed:@"back_img_white.png"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    
}

//设置导航栏上的标题
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setTextAlignment:1];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)backAction
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [LoadingView dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

//模态返回
- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//调用alertView方法
- (void)showAlertView:(NSString *)message
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)setRightNavigationBarTitle:(NSString *)text color:(UIColor *)normalColor fontSize:(float)font isBold:(BOOL)isBold frame:(CGRect)fframe
{
    UIButton * rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = fframe;
    [rightButton setTitle:text forState:UIControlStateNormal];
    [rightButton setTitle:text forState:UIControlStateHighlighted];
    [rightButton setTitleColor:SEGMENTSELECT forState:UIControlStateHighlighted];
    [rightButton setTitleColor:normalColor forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightNavigationBarAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = isBold?[UIFont boldSystemFontOfSize:font]:[UIFont systemFontOfSize:font];
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}
/*设置右上角按钮 图片
 **/

- (void)setRightNavigationBarBackGroundImgName:(NSString*)imageName frame:(CGRect)frame
{
    UIButton * rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = frame;
    [rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [rightButton addTarget:self action:@selector(rightNavigationBarAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;

}

- (void)rightNavigationBarAction:(UIButton *)sender{}

- (BOOL)WhetherInMemoryOfChild
{
    if (!self) {
        return NO ;
    }
    if (![self isKindOfClass:[UIViewController class]]) {
        return NO;
    }
    return NO;
}
- (BOOL)currentIsTopViewController
{
    if (self.navigationController.topViewController == self) {
        return YES;
    }
    return NO;
}

- (void)sharedResultCallBack:(BOOL)isSucess info:(NSString *)result
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (self) {
        if (self.view.subviews) {
            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    }
}

- (void)didReceiveMemoryWarning {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
