//
//  BaseNavigationViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "UIUtils.h"
#import "Configurations.h"
#import "LogInViewController.h"
#import "BasViewController.h"

@interface BaseNavigationViewController ()<UIGestureRecognizerDelegate>



@end


@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationBar setBackgroundImage:[UIUtils imageFromColor:NAVIGATIONCOLOR] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    self.navigationItem.hidesBackButton = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)initialize
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    NSMutableDictionary *dictH = [NSMutableDictionary dictionary];
    dictH[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    dictH[NSForegroundColorAttributeName] = SEGMENTSELECT;
    [item setTitleTextAttributes:dictH forState:UIControlStateHighlighted];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    NSMutableDictionary *navDict = [NSMutableDictionary dictionary];
    navDict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    navDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:navDict];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0 ) {
        if (![viewController.superclass isSubclassOfClass:[BasViewController class]]) {
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_img_white.png"] style:0 target:self action:@selector(back)];
            barButtonItem.tintColor = [UIColor whiteColor];
            [barButtonItem setImageInsets:UIEdgeInsetsMake(10, 0, 10, 20)];
            viewController.navigationItem.leftBarButtonItem = barButtonItem;
            
            viewController.hidesBottomBarWhenPushed = YES;
        }
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
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
