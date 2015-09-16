//
//  FindViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "FindViewController.h"
#import "InfoItemView.h"
#import "SquareUserPageViewController.h"
#import "StoreInfoSettingsViewController.h"
#import "TabBarView.h"
#import "ContactServerViewController.h"
#import "JWMessagePointButton.h"
#import "SystemNoticeViewController.h"

@interface FindViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong)JWMessagePointButton *messageButton;

@end

@implementation FindViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestHaveNewMessage];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageButton = [[JWMessagePointButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40) BackImage:[UIImage imageNamed:@"icon_system_messages.png"]];
    
    [_messageButton addTarget:self action:@selector(rightNavigationBarAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.messageButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    self.title = @"发现";
    
    
    InfoItemView *firstItem = [[InfoItemView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 44) Img:[UIImage imageNamed:@"icon_find_circle.png"] titleString:@"圈子" detailInfo:nil];
    [firstItem setAction:@selector(clickInfoItemAction:) target:self];
    firstItem.tag = 401;
    firstItem.controlDes = @"AllCircleViewController";
    [self.view addSubview:firstItem];
    
    InfoItemView *secondItem = [[InfoItemView alloc]initWithFrame:CGRectMake(0, firstItem.bottom+10, SCREENWIDTH, 44) Img:[UIImage imageNamed:@"icon_find_images.png"] titleString:@"图库" detailInfo:nil];
    [secondItem setAction:@selector(clickInfoItemAction:) target:self];
    secondItem.tag = 402;
    secondItem.controlDes = @"AllGalleryViewController";
    [self.view addSubview:secondItem];

    InfoItemView *threeItem = [[InfoItemView alloc]initWithFrame:CGRectMake(0, secondItem.bottom+1, SCREENWIDTH, 44) Img:[UIImage imageNamed:@"icon_mine_city.png"] titleString:@"同城" detailInfo:nil];
    [threeItem setAction:@selector(clickInfoItemAction:) target:self];
    threeItem.tag = 403;
    threeItem.controlDes = @"SameCityViewController";
    [self.view addSubview:threeItem];

    
    InfoItemView *fourthItem = [[InfoItemView alloc]initWithFrame:CGRectMake(0, threeItem.bottom+10, SCREENWIDTH, 44) Img:[UIImage imageNamed:@"icon_find_service.png"] titleString:@"联系客服" detailInfo:nil];
    [fourthItem setAction:@selector(clickInfoItemAction:) target:self];
    fourthItem.tag = 404;
    [self.view addSubview:fourthItem];
  
    UIImageView *petImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, fourthItem.bottom+(SCREENHEIGHT-64-49-fourthItem.bottom)/2-49, 235, 98)];
    petImageView.backgroundColor = [UIColor clearColor];
    petImageView.image = [UIImage imageNamed:@"icon_find_pet.png"];
    [self.view addSubview:petImageView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAboutNotice:) name:kPushNotication object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAboutNotice:) name:ChatMessageReceiveNotive object:nil];

}

#pragma mark-- 展示新消息
- (void)showAboutNotice:(NSNotification *)notication
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        TabBarView *jwtabView = (TabBarView *)[self.navigationController.tabBarController.tabBar viewWithTag:5];
        if (jwtabView) {
            jwtabView.threeItem.messageLabel.hidden = YES;
            jwtabView.threeItem.messageView.hidden = YES;
        }
        for (int i = 401; i< 404; i++) {
            InfoItemView *tempView = (InfoItemView *)[self.view viewWithTag:i];
            if (tempView) {
                [tempView setMessageCount:-10];
            }
            
        }        
        BOOL showTabMessage = NO;
        
        
        //系统消息
        if ([JudgeMethods defaultJudgeMethods].showSystemNotice || [JudgeMethods defaultJudgeMethods].showSquareNotice || [JudgeMethods defaultJudgeMethods].showimageNotice) {
            self.messageButton.messageLabel.hidden = NO;
            showTabMessage = YES;
        }
        
      
        if ([JudgeMethods defaultJudgeMethods].showKefuMessage || [JudgeMethods defaultJudgeMethods].kefuMessageCount) {
            [self infoItemViewHaveNewMessage:404 withMessageNum:[JudgeMethods defaultJudgeMethods].kefuMessageCount];
            showTabMessage = YES;
        }
        
    
        if (!showTabMessage) {
            TabBarView *jwtabView = (TabBarView *)[self.navigationController.tabBarController.tabBar viewWithTag:5];
            if (jwtabView) {
                jwtabView.threeItem.messageLabel.hidden = YES;
                jwtabView.threeItem.messageView.hidden = YES;
            }
        }
    });
}


- (void)requestHaveNewMessage
{
    
    NSNumber *created = @(0);
    NSNumber *lasetNum = [[NSUserDefaults standardUserDefaults]objectForKey:homeLastMessageCreated];
    if (lasetNum) {
        created = lasetNum ;
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:created forKey:@"latest_created"];
    [parm setObject:@(100) forKey:@"limit"];
    [parm setObject:@(-1) forKey:@"order"];
    
    [[JWNetClient defaultJWNetClient]squareGet:@"/notice" requestParm:parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!self) return ;
        if (!errmsg) {
            NSArray *resultArray = responObject[@"data"];
            if (resultArray.count >=1) {
                [JudgeMethods defaultJudgeMethods].showSquareNotice = YES;
            }
        }
        [self showAboutNotice:nil];
    }];
}



- (void)infoItemViewHaveNewMessage:(int)atag withMessageNum:(int)num
{
    InfoItemView *tempView = (InfoItemView *)[self.view viewWithTag:atag];
    
    TabBarView *jwtabView = (TabBarView *)[self.navigationController.tabBarController.tabBar viewWithTag:5];

    if (!tempView || !jwtabView) return;
    
    jwtabView.threeItem.messageView.hidden = NO;
    jwtabView.threeItem.messageLabel.hidden = YES;

    [tempView setMessageCount:num];
    
}


#pragma mark ----- 跳转
- (void)clickInfoItemAction:(UIButton *)sender
{
 
    InfoItemView *sendView = (InfoItemView *)[self.view viewWithTag:sender.tag];
    if (!sendView)return;
    sendView.detailLabel.text = nil;
    [sendView setMessageCount:-2];
    
    if (sendView.tag == 404) {
       
        [JudgeMethods defaultJudgeMethods].showKefuMessage = NO;
        [JudgeMethods defaultJudgeMethods].kefuMessageCount = 0;
        if (![User defaultUser].supportRongyun) {
            [SVProgressHUD showErrorWithStatus:@"客服系统异常，正在排查中，请稍后使用"];
            [self showAboutNotice:nil];
            return;
        }
        ContactServerViewController *conversationVC = [[ContactServerViewController alloc]init];
        conversationVC.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
        conversationVC.conversationType = 1;
        conversationVC.targetId =[NSString stringWithFormat:@"%@",[User defaultUser].kefuNum];
        conversationVC.userName = [User defaultUser].kefuName;
        conversationVC.title = [User defaultUser].kefuName;
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:conversationVC action:@selector(backAction)];
        leftBar.tintColor = [UIColor whiteColor];
        conversationVC.navigationItem.leftBarButtonItem = leftBar;
        [self.navigationController pushViewController:conversationVC animated:YES];
       
        return;
    }else if (sendView.tag == 402){
        [JudgeMethods defaultJudgeMethods].showimageNotice = NO;
    }else{
        [JudgeMethods defaultJudgeMethods].showSquareNotice = NO;
    }
    
    if ([NSObject nulldata:sendView.controlDes]) {
        
        if (sender.tag == 403 && (![User defaultUser].item.city || ![User defaultUser].item.province)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你还没有开通同城，马上去个人设置更新所在地！" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"现在设置", nil];
            alert.tag = 555;
            [alert show];
            return;
        }
        Class sampleClase = NSClassFromString(sendView.controlDes);
        UIViewController *controller = (UIViewController *)[[sampleClase alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 555 && buttonIndex == 1) {
        StoreInfoSettingsViewController *pageVC = [[StoreInfoSettingsViewController alloc]init];
        [self.navigationController pushViewController:pageVC animated:YES];
        return;
    }
}



#pragma mark ------ 点击消息切入


- (void)rightNavigationBarAction:(UIButton *)sender
{
    
     self.messageButton.messageLabel.hidden = YES;
    
    BOOL newMessage = [JudgeMethods defaultJudgeMethods].showSquareNotice;
    self.messageButton.messageLabel.hidden = YES;
    SystemNoticeViewController *noticeVC = [[SystemNoticeViewController alloc]initWithQuery:@{@"newMessage":@(newMessage)}];
    [self.navigationController pushViewController:noticeVC animated:YES];
    [JudgeMethods defaultJudgeMethods].showSystemNotice = NO;
    [JudgeMethods defaultJudgeMethods].showSquareNotice = NO;
    [JudgeMethods defaultJudgeMethods].showimageNotice  = NO;
    

    
   
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
