//
//  MainViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "MainViewController.h"
#import "Configurations.h"
#import "BaseNavigationViewController.h"
#import "AboutMeViewController.h"
#import "FindViewController.h"
#import "OrderManageCenterViewController.h"
#import "LogInViewController.h"
#import "SetingViewController.h"
#import "UserPageViewController.h"
#import "TabBarView.h"
#import "MobClick.h"

@interface MainViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) TabBarView *customTabbarView;
@end

@implementation MainViewController

+ (instancetype) sharedInstance {
     MainViewController *sharedController = nil;
    sharedController = [[MainViewController alloc] initWithNibName: nil bundle: nil];
    
    return sharedController;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UserPageViewController *userPageVC = [[UserPageViewController alloc]init];
    userPageVC.hidesBottomBarWhenPushed = NO;
    OrderManageCenterViewController *orderManageVC = [[OrderManageCenterViewController alloc]init];
    orderManageVC.hidesBottomBarWhenPushed = NO;
    FindViewController *findVC = [[FindViewController alloc]init];
    findVC.hidesBottomBarWhenPushed = NO;
    AboutMeViewController *aboutMeVC  =[[AboutMeViewController alloc]init];
    aboutMeVC.hidesBottomBarWhenPushed = NO;
    
    self.viewControllers = @[[[BaseNavigationViewController alloc]initWithRootViewController:userPageVC],
                             [[BaseNavigationViewController alloc]initWithRootViewController:orderManageVC],
                             [[BaseNavigationViewController alloc]initWithRootViewController:findVC],
                             [[BaseNavigationViewController alloc]initWithRootViewController:aboutMeVC]];
    self.delegate = self;
    self.view.backgroundColor = VIEWBACKGROUNDCOLOR;
    self.tabBar.tintColor = RGBCOLOR_HEX(0x000000);
    
    _customTabbarView = [[TabBarView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 49) withType:1];
    _customTabbarView.tag = 5;
    _customTabbarView.backgroundColor = RGBCOLOR_HEX(0x000000);
  
    _customTabbarView.firstItem.selected = YES;
    [_customTabbarView.firstItem addTarget:self action:@selector(selectTabController:) forControlEvents:UIControlEventTouchUpInside];
    
    [_customTabbarView.secondItem addTarget:self action:@selector(selectTabController:) forControlEvents:UIControlEventTouchUpInside];
    
    [_customTabbarView.threeItem addTarget:self action:@selector(selectTabController:) forControlEvents:UIControlEventTouchUpInside];
    
    [_customTabbarView.fourthItem addTarget:self action:@selector(selectTabController:) forControlEvents:UIControlEventTouchUpInside];
    if (self.tabBar.subviews) {
        [self.tabBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.tabBar addSubview:self.customTabbarView];
    
    
    User *currentUser = [User defaultUser];
    TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",currentUser.item.userId]];
    int number  =  [operationDB searchAllCountWithsql:[NSString stringWithFormat:@" select COUNT(*) number from %@%@ where ((orderStatus = 7 or orderStatus = 4) and recycle != 1 and orderTime > %f )",ORDERTABNAME,currentUser.item.userId,[[NSDate date] timeIntervalSince1970]*1000]];
    if (number>0) {
        _customTabbarView.secondItem.messageLabel.hidden = NO;
        _customTabbarView.secondItem.messageLabel.text = [NSString stringWithFormat:@"%d",number];
    }else{
        _customTabbarView.secondItem.messageLabel.hidden = YES;
    }


}



- (void)selectTabController:(JWTabItem *)sender
{
    
    
    TabBarView *temp = (TabBarView *)[self.tabBar viewWithTag:5];
    if (temp) {
        [temp setNothingSelected];
    }
    [_customTabbarView setNothingSelected];
    
    int selectedIndex = (int)sender.tag-10;
    [sender setSelected:YES];
    self.selectedIndex = selectedIndex;
    switch (sender.tag) {
        case 10:
            [MobClick event:@"30_click_tab_micro_card"];
            break;
        case 11:
            [MobClick event:@"30_click_tab_order"];
            break;
        case 12:
            [MobClick event:@"30_click_tab_discover"];
            break;
        default:
            [MobClick event:@"30_click_tab_mine"];
            break;
    }

   
}
- (void)didReceiveMemoryWarning {
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
