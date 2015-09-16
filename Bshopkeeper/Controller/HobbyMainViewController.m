//
//  HobbyMainViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "HobbyMainViewController.h"
#import "AllCircleViewController.h"
#import "AllGalleryViewController.h"
#import "AboutMeViewController.h"
#import "SystemNoticeViewController.h"
#import "BaseNavigationViewController.h"
#import "HobbyCircleViewController.h"
#import "TabBarView.h"
#import "CreateSquareMessageViewController.h"
#import "HobbyCityViewController.h"
#import "MobClick.h"
#import "JWEvent.h"
#import "JWChatMessageModel.h"

@interface HobbyMainViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) TabBarView *customTabbarView;

@end

@implementation HobbyMainViewController

+ (instancetype) sharedInstance {
    HobbyMainViewController *sharedController = nil;
    sharedController = [[HobbyMainViewController alloc] initWithNibName: nil bundle: nil];
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
    self.tabBar.tintColor = [UIColor clearColor];
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
        
    AllGalleryViewController *galleryVC = [[AllGalleryViewController alloc]initWithQuery:@{@"viewHeight":@(SCREENHEIGHT-64-49)}];
    galleryVC.title = @"纹身大咖";
    galleryVC.hidesBottomBarWhenPushed = NO;
    
    HobbyCircleViewController *circleVC = [[HobbyCircleViewController alloc]initWithQuery:@{@"viewHeight":@(SCREENHEIGHT-64-49)}];
    circleVC.hidesBottomBarWhenPushed = NO;
   
    HobbyCityViewController *cityvc = [[HobbyCityViewController alloc]init];
    cityvc.hidesBottomBarWhenPushed = NO;
    
    AboutMeViewController *aboutMeVC  =[[AboutMeViewController alloc]initWithQuery:@{@"viewHeight":@(SCREENHEIGHT-64-49)}];
    aboutMeVC.hidesBottomBarWhenPushed = NO;
    self.viewControllers = @[[[BaseNavigationViewController alloc]initWithRootViewController:galleryVC],
                             [[BaseNavigationViewController alloc]initWithRootViewController:circleVC],
                             [[BaseNavigationViewController alloc]initWithRootViewController:cityvc],
                             [[BaseNavigationViewController alloc]initWithRootViewController:aboutMeVC]];
    self.delegate = self;
    self.view.backgroundColor = VIEWBACKGROUNDCOLOR;
    self.tabBar.tintColor = RGBCOLOR_HEX(0x000000);
    
    _customTabbarView = [[TabBarView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 49) withType:122];
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

    
//    UIButton * _releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _releaseBtn.frame = CGRectMake(SCREENWIDTH/5*2, -20, SCREENWIDTH/5, SCREENWIDTH/5);
//    _releaseBtn.backgroundColor = [UIColor clearColor];
//    _releaseBtn.clipsToBounds = YES;
//    float spaceHeight = (_releaseBtn.height-57)/2;
//    _releaseBtn.imageEdgeInsets = UIEdgeInsetsMake(spaceHeight, spaceHeight, spaceHeight, spaceHeight);
//    [_releaseBtn setImage:[UIImage imageNamed:@"icon_tab_release.png"] forState:UIControlStateNormal];
//    [_releaseBtn addTarget:self action:@selector(createFeedFunction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.tabBar addSubview:_releaseBtn];
//    [self.tabBar bringSubviewToFront:_releaseBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNewMessageAction:) name:kPushNotication object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNewMessageAction:) name:ChatMessageReceiveNotive object:nil];

    
}

- (void)createFeedFunction:(UIButton *)sender
{

    CreateSquareMessageViewController *createMessageVC = [[CreateSquareMessageViewController alloc]init];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:createMessageVC];
    [self presentViewController:navigation animated:YES completion:NULL];
}

- (void)showNewMessageAction:(NSNotification *)notication
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([JudgeMethods defaultJudgeMethods].showSquareNotice ){
            _customTabbarView.firstItem.messageView.hidden = NO;
            _customTabbarView.firstItem.messageLabel.hidden = YES;
        }
        if ([JudgeMethods defaultJudgeMethods].showSystemNotice) {
            _customTabbarView.fourthItem.messageView.hidden = NO;
            _customTabbarView.fourthItem.messageLabel.hidden = YES;
        }
        if (notication) {
            if ([notication.object isKindOfClass:[JWChatMessageModel class]]) {
               
                //私信消息
                TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",[User defaultUser].item]];
                NSString *tableName= [NSString stringWithFormat:@"%@%@",ChatManageTableName,[User defaultUser].item.userId];
                NSDictionary *dict = [operationDB customQueryParameters:[NSString stringWithFormat:@"select count(*) numbercount , sum(messagenum) totalCount from %@ where messagenum  > 0 ",tableName] parm:@{@"numbercount":@(0),@"totalCount":@"0"}];
                int num = [[dict objectForKey:@"totalCount"] integerValue];
                if (num > 0 ) {
                    _customTabbarView.fourthItem.messageView.hidden = NO;
                    _customTabbarView.fourthItem.messageLabel.hidden = YES;
                }
            }
        }
        
    });
}

- (void)selectTabController:(JWTabItem *)sender
{
  
    if ([[User defaultUser].item.sector integerValue] != 30) {
        NSString *key = [ NSString stringWithFormat:@"%f+%@",[[NSDate date] timeIntervalSince1970],[User defaultUser].storeItem.storeId];

        if (sender.tag == 11) {
            [JWEvent defaultJWEvent].hobbyUrlTimesOfonce =0 ;
            [JWEvent defaultJWEvent].hobbyCircleTimesOfOnce = 0;
        }else{
            if ([JWEvent defaultJWEvent].hobbyUrlTimesOfonce !=0 ) {
                NSString *number = [NSString stringWithFormat:@"+%d",[JWEvent defaultJWEvent].hobbyUrlTimesOfonce];
                [MobClick event:@"0_count_click_feed_url" attributes:@{@"number":number,@"key":key}];
            }
            if ([JWEvent defaultJWEvent].hobbyCircleTimesOfOnce !=0) {
                NSString *number = [NSString stringWithFormat:@"+%d",[JWEvent defaultJWEvent].hobbyCircleTimesOfOnce];
                [MobClick event:@"0_count_click_feed" attributes:@{@"number":number,@"key":key}];
            }
            [JWEvent defaultJWEvent].hobbyUrlTimesOfonce =0 ;
            [JWEvent defaultJWEvent].hobbyCircleTimesOfOnce = 0;
        }
        
        if (sender.tag == 10) {
            [JWEvent defaultJWEvent].hobbyGalleryTimesOfOnce =0 ;
        }else{
            if ([JWEvent defaultJWEvent].hobbyUrlTimesOfonce !=0 ) {
                NSString *number = [NSString stringWithFormat:@"+%d",[JWEvent defaultJWEvent].hobbyGalleryTimesOfOnce];
                [MobClick event:@"0_count_gallery_feed" attributes:@{@"number":number,@"key":key}];
            }
            [JWEvent defaultJWEvent].hobbyGalleryTimesOfOnce =0 ;
        }
    }
    
    [_customTabbarView setNothingSelected];
    int selectedIndex = (int)sender.tag-10;
    [sender setSelected:YES];
    self.selectedIndex = selectedIndex;
    switch (sender.tag) {
        case 10:
            [MobClick event:@"0_click_tab_gallery"];
            break;
        case 11:
            [MobClick event:@"0_click_tab_circle"];
            break;
        case 12:
            [MobClick event:@"0_click_tab_msg"];
            break;
        default:
            [MobClick event:@"0_click_tab_mine"];
            break;
    }
}

- (void)selectControllerWithTag:(int)tag
{
    switch (tag) {
        case 0:
            [self selectTabController:self.customTabbarView.firstItem];
            break;
        case 1:
            [self selectTabController:self.customTabbarView.secondItem];
            break;
        case 2:
            [self selectTabController:self.customTabbarView.threeItem];
            break;
        default:
            [self selectTabController:self.customTabbarView.fourthItem];
            break;
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
