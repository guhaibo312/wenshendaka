//
//  SystemNoticeViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SystemNoticeViewController.h"
#import "MessageCenterModel.h"
#import "MessageCenterCell.h"
#import "H5PreviewManageViewController.h"
#import "JWTabItemButton.h"
#import "JWChatListView.h"
#import "JWChatMessageModel.h"
#import "MessageRelatedTableView.h"


@interface SystemNoticeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *listTable;
    
    NSMutableArray  *dataArray;
    
    MessageRelatedTableView *messageView;
    
    int noticecount;
    
    int messagecount;
    
    JWTabItemButton * circleButton;
    
    JWTabItemButton * chatListItem;
    
}

@property (nonatomic, assign) float viewHeight;
@property (nonatomic, assign) BOOL newMessage;

@end

@implementation SystemNoticeViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        
        _viewHeight = SCREENHEIGHT-64;
        _newMessage = [query[@"newMessage"]boolValue];
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    
    dataArray = [NSMutableArray array];
    
    noticecount = 0;
    messagecount = 0;
    
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 44,SCREENWIDTH , _viewHeight-44)];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.rowHeight = 50;
    UIView *footView =[[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    listTable.tableFooterView = footView;
    [self.view addSubview:listTable];
    
    
    messageView = [[MessageRelatedTableView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, _viewHeight-44)withOwner:self isReceiveNotice:_newMessage];
    [self.view addSubview:messageView];
        
    
   
    
    circleButton = [[JWTabItemButton  alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/2 , 44) withTitle:@"通知" normalTextColor:[UIColor whiteColor] needBottomView:NO];
    circleButton.backgroundColor = SEGMENTNORMAL;
    circleButton.messageLabel.left = circleButton.width/2+20;
    circleButton.messageLabel.top = circleButton.height/2-10;
    circleButton.tag = 150;
    [circleButton addTarget:self action:@selector(clickCircleAndCityAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:circleButton];
    
    chatListItem = [[JWTabItemButton  alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/2 , 44) withTitle:@"动态" normalTextColor:[UIColor whiteColor] needBottomView:NO];
    chatListItem.backgroundColor = SEGMENTNORMAL;
    chatListItem.messageLabel.left = chatListItem.width/2+20;
    chatListItem.messageLabel.top = chatListItem.height/2-10;
    chatListItem.tag = 200;
    chatListItem.selected = YES;
    [chatListItem addTarget:self action:@selector(clickCircleAndCityAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chatListItem];
    
    
    __weak __typeof (chatListItem ) item = chatListItem;

    messageView.countBlock = ^(int count){
        if (count > 0) {
            item.messageLabel.text = [NSString stringWithFormat:@"%d",count];
            item.messageLabel.hidden = NO;

        }else{
            item.messageLabel.text = nil;
            item.messageLabel.hidden = YES;
        }
        
    };
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataFromServer];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewHeight = SCREENHEIGHT-64;
    }
    return self;
}



#pragma mark ---------------------------------- 加载数据
- (void)loadDataFromServer
{
    [LoadingView show:@"请稍后..."];
    [dataArray removeAllObjects];
    
    User *currentUser = [User defaultUser];
    NSString *requestLastUpTime = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",MESSAGECENTERNAME,currentUser.item.userId]];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    if (currentUser.storeItem.storeId) {
        [parm setObject:currentUser.storeItem.storeId forKey:@"storeId"];
        [parm setObject:@"true" forKey:@"new"];
    }
    if (requestLastUpTime) {
        //存在拉取上次以后的增量
        [parm setObject:requestLastUpTime forKey:@"updateTime"];
    }else{
        requestLastUpTime = @"0";
    }
   
    __weak __typeof (self)weakSelf = self;
    [[JWNetClient defaultJWNetClient]getNetClient:@"Update/list" requestParm:@{@"NoticeMessage":requestLastUpTime} result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!weakSelf)return ;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
            [weakSelf requestFinishAction:nil];
        }else{
            [weakSelf requestFinishAction:responObject];
        }
    }];
    

}

- (void)requestFinishAction:(NSDictionary *)result
{
    if (!self) return;
    User *currentUser = [User defaultUser];
    TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",currentUser.item.userId]];
    
    if (result) {
        NSArray *list = [[result objectForKey:@"data"]objectForKey:@"NoticeMessage"];
        if (list) {
            [dataArray removeAllObjects];
            noticecount = list.count;
            for (int i = 0 ; i< list.count; i++) {
                NSDictionary *tempD = [list objectAtIndex:i];
                
                MessageCenterModel *one = [[MessageCenterModel alloc]initWithDictionary:tempD];
                if ([tempD[@"deletedTime"] compare:[NSNumber numberWithInt:1]]  == NSOrderedDescending) {
                    
                    if ([operationDB theTableIsHavetheData:one._id fromeTable:[NSString stringWithFormat:@"%@%@",MESSAGECENTERNAME,currentUser.item.userId]]) {
                        [operationDB delegateObjectFromeTable:tempD[@"_id"]fromeTable:[NSString stringWithFormat:@"%@%@",MESSAGECENTERNAME,currentUser.item.userId]];
                    }
                }else{
                    //判断数据库有数据就更新 没有就添加
                    if ([operationDB theTableIsHavetheData:one._id fromeTable:[NSString stringWithFormat:@"%@%@",MESSAGECENTERNAME,currentUser.item.userId]]) {
                        [operationDB upDataObjectInfo:one fromTable:[NSString stringWithFormat:@"%@%@",MESSAGECENTERNAME,currentUser.item.userId]];
                    }else{
                        [operationDB insertObjectObject:one fromeTable:[NSString stringWithFormat:@"%@%@",MESSAGECENTERNAME,currentUser.item.userId]];
                    }
                }
                
                if (i == list.count-1) {
                    NSString *upDataTime = [[list objectAtIndex:i] objectForKey:@"updateTime"];
                    if (upDataTime) {
                        // 存储拉取新的时间
                        [[NSUserDefaults standardUserDefaults] setObject:upDataTime forKey:[NSString stringWithFormat:@"%@%@",MESSAGECENTERNAME,currentUser.item.userId]];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                    }
                }
            }
        }
        
    }
    
    if (dataArray) {
        [dataArray removeAllObjects];
    }
    NSArray *searchList =  [operationDB findAllFromType:9 fromeTable:[NSString stringWithFormat:@"%@%@",MESSAGECENTERNAME,currentUser.item.userId]];
    
    if (searchList.count >0) {
        for (int i = 0 ; i< searchList.count; i++) {
            MessageCenterModel *one = [searchList objectAtIndex:i];
            [dataArray addObject:one];
        }
    }
    [LoadingView dismiss];
    if (circleButton) {
        if (noticecount >0) {
            circleButton.messageLabel.text = [NSString stringWithFormat:@"%d",noticecount];
            circleButton.messageLabel.hidden = NO;
        }else{
            circleButton.messageLabel.hidden = YES;
            circleButton.messageLabel.text = @"";
        }
    }
    
    [listTable reloadData];
    
    
}

#pragma mark ----------------------------------- tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"messageCell";
    MessageCenterCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil) {
        cell = [[MessageCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    if (dataArray.count>0) {
        [cell bingMessgeCenterModer:[dataArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageCenterModel *model = [dataArray objectAtIndex:indexPath.row];
    if (![NSObject nulldata:model.url]) return;
    if (model) {
        H5PreviewManageViewController *h5prev = [[H5PreviewManageViewController alloc]initWithQuery:@{@"urlStr":model.url,@"title":model.userInfoName?model.userInfoName:@"纹身大咖"}];
        [self.navigationController pushViewController:h5prev animated:YES];
    }
}

#pragma mark -- 切换
- (void)clickCircleAndCityAction:(JWTabItemButton *)sender
{
    sender.messageLabel.text = nil;
    sender.messageLabel.hidden = YES;
    sender.selected = YES;

    if (sender == circleButton) {
        messageView.hidden = YES;
        listTable.hidden = NO;
        if (chatListItem) {
            chatListItem.selected = NO;
        }
    }else{
        listTable.hidden = YES;
        messageView.hidden = NO;
        if (circleButton) {
            circleButton.selected = NO;
        }
        
    }
}

- (void)backAction
{
    if (listTable){
        listTable.delegate = nil;
        listTable.dataSource = nil;
        listTable = nil;
    }
    if (messageView) {
       
        messageView.delegate = nil;
        messageView.dataSource = nil;
        messageView = nil;
    }
    
    [super backAction];
}

//#pragma mark --- 收到消息列表
//- (void)receivedListMessage:(NSNotification *)nocification
//{
//    NSDictionary *parm = nocification.object;
//    if (parm) {
//        NSArray *resultArray = [parm objectForKey:@"list"];
//        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:resultArray.count+1];
//        if (resultArray) {
//            for (int i = 0 ; i< resultArray.count; i++) {
//                JWChatMessageModel *model = [[JWChatMessageModel alloc]initWithDictionary:resultArray[i]];
//                [tempArray addObject:model];
//            }
//        }
//        if (chatList) {
//            chatList.dataArray = [NSMutableArray arrayWithArray:tempArray];
//            [chatList reloadData];
//            chatList.getMessageSucess = YES;
//        }
//    }
//}
//
//#pragma mark --- 收到消息
//- (void)SystemNoticeReceivedMessage:(NSNotification *)notification
//{
//    if (_topView) {
//        JWTabItemButton *chatListItem = (JWTabItemButton *)[_topView viewWithTag:200];
//        if (chatListItem){
//            if (chatListItem.selected == YES) {
//                chatListItem.messageLabel.hidden = YES;
//                chatListItem.messageLabel.text = nil;
//            }else{
//                chatListItem.messageLabel.text = @"新";
//                chatListItem.messageLabel.hidden = NO;
//            }
//        }
//        
//        JWChatMessageModel *result = notification.object;
//        [self updateMessageRecord:result];
//   }
//   
//}


//- (void)updateMessageRecord:(JWChatMessageModel *)model
//{
//    if (model) {
//        if (self && chatList) {
//            
//            NSMutableArray *tempArray = [chatList.dataArray mutableCopy];
//            
//            if (chatList.dataArray.count>0) {
//                int count = tempArray.count;
//                for ( int i = 0 ; i< count; i++) {
//                    JWChatMessageModel *temp = [tempArray objectAtIndex:i];
//                    if ([StringFormat(temp.otherId) isEqualToString:StringFormat(model.otherId)]) {
//                        [tempArray removeObject:temp];
//                        break;
//                    }
//                }
//            }
//            
//            if (tempArray.count >0) {
//                [tempArray insertObject:model atIndex:0];
//            }else{
//                [tempArray addObject:model];
//            }
//            chatList.dataArray = tempArray;
//            [chatList reloadData];
//            if (chatList.dataArray.count>0) {
//                [chatList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                
//            }
//        }
//
//    }
//}

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
