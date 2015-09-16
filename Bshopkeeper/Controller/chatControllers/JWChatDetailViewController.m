//
//  JWChatDetailViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/21.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWChatDetailViewController.h"
#import "JWChatInpuBarView.h"
#import "JWPluginBoardView.h"
#import "JWChatDetaillistTableView.h"
#import "JWChatMessageModel.h"
#import "JWChatMessageFrameModel.h"
#import "JWSocketCpu.h"
#import "JWSocketManage.h"
#import "TJWAssetPickerController.h"
#import "SystemNoticeViewController.h"
#import "JWChatDataManager.h"
#import "OtherUserModel.h"


typedef NS_ENUM(NSInteger, CurrentChatType){
    inputViewTextType = 1,
    inputViewActionType
};

@interface JWChatDetailViewController ()<JWInPutDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,TJWAssetPickerControllerDelegate>
{
    JWChatInpuBarView *inputBarView;
    
    JWPluginBoardView *pluginView;
    
    
    float animationDuration;
    
    CGRect keyboardRect;
    
    NSArray *sendImages;
    
    UIButton *disConnectionView;
}

@property (nonatomic, strong) JWChatDetailListTableView *listTable;

@property (nonatomic, strong) NSString *reciveID;       //聊天对象的id


@end

@implementation JWChatDetailViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _reciveID = [NSString stringWithFormat:@"%@",query[@"id"]];
     
        }
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showDisConnectView];
}

- (void)showDisConnectView
{
    if (![JWSocketManage shareManage].isConnect) {
        disConnectionView.hidden = NO;
        disConnectionView.frame = CGRectMake(0, -40, SCREENWIDTH, 40);
        [UIView animateWithDuration:0.25 animations:^{
            disConnectionView.frame = CGRectMake(0, 0, SCREENWIDTH, 40);
        } completion:^(BOOL finished) {
            if (finished) {
                disConnectionView.frame = CGRectMake(0, 0, SCREENWIDTH, 40);
            }
        }];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    self.view.backgroundColor = VIEWBACKGROUNDCOLOR;
    
     OtherUserModel * model =  [[JWChatDataManager sharedManager].userInfoDict objectForKey:_reciveID];
    if (model) {
        self.title = model.nickname;
    }else{
        self.title = @"私聊";
    }
    
    [self layoutSubViews];
    
    //获取历史消息
    [self requestHistoryMessage:nil goToservice:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendMessageRespond:) name:ChatMessageSendSucessNotice object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedMessage:) name:ChatMessageReceiveNotive object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getHistoryMessage:) name:ChatMessageHistoreRecordChangedNotice object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectionStateChanged:) name:ChatSytemConnectFailNotice object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectionStateChanged:) name:ChatSystemConnectSucessNotice object:nil];



    if (_listTable.dataArray.count >0) {
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_listTable.dataArray.count - 1 inSection:0];
        [_listTable scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    if ([[NSString stringWithFormat:@"%@",_reciveID] isEqual:[NSString stringWithFormat:@"%@",[User defaultUser].kefuNum]]) {
        //加入客服的id
            __weak __typeof(self)weakSelf = self;
            [[JWNetClient defaultJWNetClient]squareGet:@"/users" requestParm:@{@"userId":[User defaultUser].kefuNum} result:^(id responObject, NSString *errmsg) {
                if (weakSelf == NULL)return ;
                if (!errmsg) {
                    NSDictionary *result = responObject[@"data"];
                    if (result) {
                        [[JWChatDataManager sharedManager] saveUserToLocal:result];
                    }
                }
            }];

    }
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)keyboardChange:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat moveY = keyFrame.origin.y - SCREENHEIGHT;
        
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
    } completion:^(BOOL finished) {
        if (finished) {
            if (_listTable) {
                if (_listTable.dataArray.count>0) {
                    [_listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_listTable.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
        }
    }];
}

- (void)layoutSubViews
{
 
    __weak __typeof (self) weakSelf = self;

    _listTable = [[JWChatDetailListTableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-40) controller:self];
    _listTable.backgroundColor = VIEWBACKGROUNDCOLOR;
    _listTable.allowsSelection = NO;
    
    _listTable.loadMoreBlock = ^(JWChatMessageFrameModel *model){
        [weakSelf resetInputViewFrame];
        [weakSelf requestHistoryMessage:model goToservice:YES];
    };
    _listTable.resetAction = ^{

        [weakSelf.view endEditing:YES];
        [weakSelf resetInputViewFrame];
       
    };
    [self.view addSubview:_listTable];
    
    inputBarView = [[JWChatInpuBarView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-64-40, SCREENWIDTH, 40)];
    inputBarView.delegate = self;
    [self.view addSubview:inputBarView];
    

    pluginView = [[JWPluginBoardView alloc]initWithFrame:CGRectMake(0, inputBarView.bottom, SCREENWIDTH, 216)];
    pluginView.hidden = YES;

    pluginView.actionBlock = ^(int index){
        [weakSelf resetInputViewFrame];
        if (index == 0) {
            [weakSelf getPhotos];
        }else if (index == 1){
            [weakSelf takeAPicture];
        };
    };
    [self.view addSubview:pluginView];
    
    disConnectionView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    disConnectionView.backgroundColor = TAGSCOLORFORE;
    [disConnectionView setTitle:@"与服务器断开连接，点击重新连接!" forState:UIControlStateNormal];
    disConnectionView.titleLabel.font = [UIFont systemFontOfSize:14];
    [disConnectionView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [disConnectionView addTarget:self action:@selector(resetConnectionStates) forControlEvents:UIControlEventTouchUpInside];
    UIActivityIndicatorView *acivityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(SCREENWIDTH-40, 5, 30, 30)];
    acivityView.activityIndicatorViewStyle =UIActivityIndicatorViewStyleWhite;
    [disConnectionView addSubview:acivityView];
    acivityView.tag = 50;
    disConnectionView.hidden = YES;
    [self.view addSubview:disConnectionView];
}

- (void)backAction
{
    //读取消息数清零
    [[JWChatDataManager sharedManager]updataUserMessage:_reciveID clean:YES];
    
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[SystemNoticeViewController class]]) {
//            SystemNoticeViewController *systemVC = (SystemNoticeViewController *)controller;
//            if (_listTable.dataArray) {
//                JWChatMessageFrameModel *model = _listTable.dataArray.lastObject;
////                [systemVC updateMessageRecord:model.message];
//            }
//            break;
//        }
//    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    if (_listTable) {
        _listTable.delegate = nil;
    }
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [super backAction];
}

#pragma mark -- 输入协议
- (void)resetInputViewHeight:(float)heitht
{
    if (inputBarView) {
        inputBarView.frame = CGRectMake(0 , SCREENHEIGHT - 64- heitht-10, SCREENWIDTH, heitht+10);
    }
}

- (void)actionButton
{
    [inputBarView.inputTextView resignFirstResponder];
    pluginView.hidden = NO;
    pluginView.top = inputBarView.bottom;
    [UIView animateWithDuration:0.25 animations:^{
        inputBarView.frame = CGRectMake(0, inputBarView.frame.origin.y-216+20, SCREENWIDTH, inputBarView.height);
        pluginView.frame = CGRectMake(0, SCREENHEIGHT-216-44, SCREENWIDTH, 216);
    }];
}

#pragma mark -- 发送数据
- (void)sendMessage:(NSString *)content
{
    if (inputBarView) {
        [inputBarView.inputTextView resignFirstResponder];
    }
    
    if ([NSObject nulldata:content]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:content forKey:@"text"];
        [dict setObject:@(1) forKey:@"type"];
        [dict setObject:[User defaultUser].item.userId forKey:@"fromId"];
        int otherId = [_reciveID integerValue];
        [dict setObject:@(otherId) forKey:@"otherId"];
        double time = [[NSDate date]timeIntervalSince1970]*1000;
        time = [[NSString stringWithFormat:@"%.f",time] doubleValue];
        [dict setObject:@(time) forKey:@"time"];
        [dict setObject:@(time) forKey:@"checkCode"];
        
        JWChatMessageModel *item = [[JWChatMessageModel alloc]initWithDictionary:dict];
        JWChatMessageFrameModel *model = [[JWChatMessageFrameModel alloc]init];
        [model setMessage:item];
        model.messagestatus = chatmessageStatusLoading;

        if (_listTable) {
            [_listTable.dataArray addObject:model];
            [_listTable reloadData];
            [_listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_listTable.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        [[JWSocketCpu sharedInstance] writeActionWithcommand:CS_talk UserParm:dict withModel:item];
        [self resetInputViewFrame];
    }
}


#pragma mark -- 重置位置

- (void)resetInputViewFrame
{

    inputBarView.inputTextView.text = nil;
    inputBarView.frame = CGRectMake(0, SCREENHEIGHT-64-40, SCREENWIDTH, 40);
    _listTable.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-40-64);
    pluginView.frame = CGRectMake(0, SCREENHEIGHT-44, SCREENWIDTH, 216);
    pluginView.hidden = YES;
    
}


#pragma mark --- 发送消息回调
- (void)sendMessageRespond:(NSNotification *)notication
{
    NSDictionary *result = notication.object;
    chatmessagestatus status = chatmessageStatusNormal;
    
    if (result) {
        double sendTime = [[result objectForKey:@"checkCode"]doubleValue];
        NSString *errorCode = [result objectForKey:@"errorCode"];
        if ([errorCode boolValue]) {
             status = chatmessageStatusFail;
        }
        if (sendTime && _listTable ) {
            [_listTable.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                JWChatMessageFrameModel *model = (JWChatMessageFrameModel *)obj;
                if ([model.message.time doubleValue]  == sendTime) {
                    model.messagestatus = status;
                    if (model.completeBlock) {
                        model.completeBlock(status);
                    }
                    *stop = YES;
                }
            }];
        }
    }
}

#pragma mark -- 收到消息
- (void)receivedMessage:(NSNotification *)notification
{
    JWChatMessageModel *result = notification.object;
    if (result) {
        JWChatMessageFrameModel *model = [[JWChatMessageFrameModel alloc]init];
        [model setMessage:result];
        if (self && _listTable) {
            [_listTable.dataArray addObject:model];
            [_listTable reloadData];
            if (_listTable.dataArray.count>0) {
                [_listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_listTable.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

            }
        }
    }
}


#pragma mark -- 拉取历史消息

- (void)requestHistoryMessage:(JWChatMessageFrameModel *)model goToservice:(BOOL)isRequest
{
    
    TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",[User defaultUser].item.userId]];
    NSString *historeMessage = [NSString stringWithFormat:@"%@%@",ChatDataTableName,[User defaultUser].item.userId];

    NSArray *searchList = [operationDB startSearchWithString:[NSString stringWithFormat:@" SELECT * FROM %@ where otherId = %@ and time < %@ ORDER BY time DESC limit 20 ",historeMessage,_reciveID,model?model.message.time:@"9999999999999"] withType:10];
    
    
    if (searchList.count>0) {
        int num = searchList.count;
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        [tempArray  addObjectsFromArray:[[searchList reverseObjectEnumerator] allObjects]];
        [tempArray addObjectsFromArray:_listTable.dataArray];
        _listTable.dataArray = tempArray;
        [_listTable reloadData];
        if (num>0 && num<tempArray.count ) {
            [_listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:num inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        _listTable.isLoading = NO;
        return;
    }else{
        if (isRequest) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:_reciveID forKey:@"otherId"];
            [dict setObject:model?model.message._id:@"" forKey:@"_id"];
            [dict setObject:@(20) forKey:@"limit"];
            [dict setObject:_reciveID forKey:@"checkCode"];
            [[JWSocketCpu sharedInstance]writeActionWithcommand:CS_getOldMessage UserParm:dict];
        }else{
            _listTable.isLoading = NO;
        }
    }
}

#pragma mark -- 获取历史消息通知
- (void)getHistoryMessage:(NSNotification *)notication
{
    //获取历史纪录的通知 有记录就把记录带进去，无记录传空
    if (_listTable.dataArray.count >0) {
        JWChatMessageFrameModel *model = [_listTable.dataArray firstObject];
        if (model) {
            [self requestHistoryMessage:model goToservice:NO];
        }
    }else{
        [self requestHistoryMessage:nil goToservice:NO];
    }
    
}

#pragma mark -- 功能项
- (void)takeAPicture
{
    // 拍照
    UIImagePickerController* controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] ) {
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.showsCameraControls = YES;
    } else {
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    controller.allowsEditing = NO;
    [self.navigationController presentViewController: controller animated: YES completion: NULL];

}

#pragma mark -- 相册
- (void)getPhotos{
    
    TJWAssetPickerController *zye = [[TJWAssetPickerController alloc]init];
    zye.maximumNumberOfSelection = 1;
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
    [self presentViewController:zye animated:YES completion:nil];

}

#pragma mark --------------------------- tjwphonoDelegate
-(void)assetPickerController:(TJWAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (assets.count> 0) {
        NSArray *tempArray = [NSArray arrayWithArray:assets];
        NSMutableArray *imageArrays = [[NSMutableArray alloc]initWithCapacity:assets.count+1];
        for (int i = 0 ; i< tempArray.count; i++) {
            ALAsset *oneAsset=tempArray[i];
            UIImage *tempImg=[UIImage imageWithCGImage:oneAsset.defaultRepresentation.fullScreenImage];
            if (tempImg) {
                [imageArrays addObject:tempImg];
            }
        }
        __weak __typeof (self)weakSelf = self;
        
        [UploadManager uploadImageList:imageArrays hasLoggedIn:YES success:^(NSArray *resultList) {
            if (resultList.count>=1) {
                [weakSelf sendImage:resultList];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"图片发送失败"];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"图片发送失败"];

        }];

        
        
    }
    
}



#pragma mark ----------------------------- UIImagePickerViewControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated: YES completion: NULL];
    if (image) {
        __weak __typeof (self)weakSelf = self;
        
        sendImages = @[image];

        [UploadManager uploadImageList:@[image] hasLoggedIn:YES success:^(NSArray *resultList) {
            if (resultList.count>=1) {
                [weakSelf sendImage:resultList];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"图片发送失败"];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"图片发送失败"];

        }];
    }
}

#pragma mark -- 发送图片

- (void)sendImage:(NSArray *)array
{
    if (!array) return;
    if (array.count<= 0) return;

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"" forKey:@"text"];
    [dict setObject:array  forKey:@"images"];
    if (array.count == 1) {
        [dict setObject:@(2) forKey:@"type"];
    }else{
        [dict setObject:@(5) forKey:@"type"];
    }
    [dict setObject:[User defaultUser].item.userId forKey:@"fromId"];
    int otherId = [_reciveID integerValue];
    [dict setObject:@(otherId) forKey:@"otherId"];
    double time = [[NSDate date]timeIntervalSince1970]*1000;
    time = [[NSString stringWithFormat:@"%.f",time] doubleValue];
    [dict setObject:@(time) forKey:@"time"];
    [dict setObject:@(time) forKey:@"checkCode"];

    JWChatMessageModel *item = [[JWChatMessageModel alloc]initWithDictionary:dict];
    JWChatMessageFrameModel *model = [[JWChatMessageFrameModel alloc]init];
    item.sendImages = sendImages;
    [model setMessage:item];
    model.messagestatus = chatmessageStatusLoading;
    
    if (_listTable) {
        [_listTable.dataArray addObject:model];
        [_listTable reloadData];
        if (_listTable.dataArray.count>0) {
            [_listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_listTable.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    [[JWSocketCpu sharedInstance] writeActionWithcommand:CS_talk UserParm:dict withModel:item];
    
}



#pragma mark --- 重新连接
- (void)resetConnectionStates
{
    UIActivityIndicatorView *indicatiorView = (UIActivityIndicatorView *)[disConnectionView viewWithTag:50];
    if (indicatiorView) {
        if ([indicatiorView isAnimating]) {
            [indicatiorView stopAnimating];
        }
        [indicatiorView startAnimating];
        [disConnectionView setTitle:@"正在尝试连接中..." forState:UIControlStateNormal];
    }
    
    [[JWSocketManage shareManage]startConnect];
}

#pragma mark ---- 聊天系统状态的改变

- (void)connectionStateChanged:(NSNotification *)notification
{
    if (!disConnectionView) return;
    
    if ([notification.object boolValue]) {
        // 连接成功
        if (!disConnectionView.hidden) {
        
            disConnectionView.hidden = YES;
            UIActivityIndicatorView *indicatiorView = (UIActivityIndicatorView *)[disConnectionView viewWithTag:50];
            if (indicatiorView) {
                if ([indicatiorView isAnimating]) {
                    [indicatiorView stopAnimating];
                }
            }
        }
        
    }else{
        
        if (!disConnectionView.hidden) {
            [disConnectionView setTitle:@"连接失败，点击重新连接!" forState:UIControlStateNormal];
        }else{
            [disConnectionView setTitle:@"与服务器断开连接，点击重新连接!" forState:UIControlStateNormal];
            [self showDisConnectView];
        }
        
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


