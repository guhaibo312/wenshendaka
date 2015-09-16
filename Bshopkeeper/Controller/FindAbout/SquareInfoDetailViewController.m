//
//  SquareInfoDetailViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/3.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SquareInfoDetailViewController.h"
#import "SquareUserPageViewController.h"
#import "SquareObject.h"
#import "SquareInfoDetailHead.h"
#import "SquareLikeButton.h"
#import "SquareCommentCell.h"

@interface SquareInfoDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,JWSharedManagerDelegate>
{
    UITableView *detailTable;
    SquareInfoDetailHead *detailTableHead;
    SquareLikeButton * likedBtn;                //赞
    SquareLikeButton * commentBtn;              //评论
    SquareCommentItem *operationComment;        //当前操作的评论
    
    UITextField *commentfield;                  //输入框
    UIView *_toolBar;                           //输入视图
    UIView *backClearView;                      //透明层
    NSDictionary *replayInfo;                   //回复的信息
    UIView *nothingView;                        //什么都没有
    
}
@property (nonatomic, strong) NSMutableArray *commentArray; //评论列表
@property (nonatomic, strong) SquareDataItem *dataSourceItem;//数据源
@property (nonatomic, strong) NSString *feedId;
@property (nonatomic, assign) BOOL isCircle;
@end

@implementation SquareInfoDetailViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _feedId = query[@"feedId"];
            _dataSourceItem  = query[@"item"];
            _isCircle = [query[@"iscircle"] boolValue];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTitle:@"详情"];

    [self layoutSubViews];
    
    UIButton* rightBar = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBar.frame = CGRectMake(0, 0, 40, 40);
    [rightBar setImage:[UIImage imageNamed:@"icon_moreList_white"] forState:UIControlStateNormal];
    [rightBar setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 0)];
    [rightBar addTarget:self action:@selector(rightNavigationBarAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBar];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    [self requestCommentAction];
}

#define 更多按钮功能

- (void)rightNavigationBarAction:(UIButton *)sender
{
    if (!_dataSourceItem) {
        return;
    }
   
    if ([_dataSourceItem.userInfo[@"userId"]  isEqual:[User defaultUser].item.userId]) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
        actionSheet.tag = 65;
        [actionSheet showInView:self.view];
        
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"举报此信息,选择举报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"淫秽",@"虚假信息",@"垃圾广告",@"其他" ,nil];
        actionSheet.tag = 66;
        [actionSheet showInView:self.view];
    }
 

}

- (void)layoutSubViews
{
    _commentArray = [NSMutableArray array];
    detailTableHead = [[SquareInfoDetailHead alloc]initWithSquareItem:_dataSourceItem ownerController:self];
    detailTableHead.backgroundColor = [UIColor whiteColor];
    detailTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64- 44)];
    detailTable.delegate = self;
    detailTable.dataSource = self;
    detailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = VIEWBACKGROUNDCOLOR;
    detailTable.tableFooterView = footView;
    detailTable.tableHeaderView = detailTableHead;
    detailTable.backgroundColor = VIEWBACKGROUNDCOLOR;
    [self.view addSubview:detailTable];
    
    likedBtn = [[SquareLikeButton alloc]initWithFrame:CGRectMake(10, SCREENHEIGHT-37-64, 93, 30) withTitle:@"赞 0" imageName:@"icon_square_unliked.png"];
    likedBtn.layer.cornerRadius = 5;
    likedBtn.backgroundColor = [UIColor whiteColor];
    likedBtn.layer.borderWidth = 1;
    [likedBtn addTarget:self action:@selector(clickLikedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    likedBtn.layer.borderColor = SquareTextColor.CGColor;
    [self.view addSubview:likedBtn];
    
    
    
    commentBtn = [[SquareLikeButton alloc]initWithFrame:CGRectMake(10+108, SCREENHEIGHT-37-64, 93, 30) withTitle:@"评论 0" imageName:@"icon_square_comment.png"];
    commentBtn.layer.cornerRadius = 5;
    commentBtn.backgroundColor = [UIColor whiteColor];
    commentBtn.layer.borderWidth = 1;
    [commentBtn addTarget:self action:@selector(clickCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.hightColor = [UIColor colorWithRed:1.0f green:162/255.0f blue:0.0f alpha:0.5];
    commentBtn.layer.borderColor = SquareTextColor.CGColor;
    [self.view addSubview:commentBtn];
    
    
    UIButton *sharedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sharedBtn.frame = CGRectMake(SCREENWIDTH-45, SCREENHEIGHT-37-64, 35, 30);
    sharedBtn.backgroundColor = [UIColor whiteColor];
    [sharedBtn setImage:[UIImage imageNamed:@"icon_square_shared.png"] forState:UIControlStateNormal];
    sharedBtn.layer.cornerRadius = 5;
    sharedBtn.layer.borderWidth = 1;
    sharedBtn.layer.borderColor = SquareTextColor.CGColor;
    sharedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 2.5, 0, 2.5);
    [sharedBtn addTarget:self action:@selector(sharedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sharedBtn];
    
    backClearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backClearView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapDetailTable = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewWillBeginDragging:)];
    backClearView.userInteractionEnabled = YES;
    backClearView.hidden = YES;
    [backClearView addGestureRecognizer:tapDetailTable];
    [self.view addSubview:backClearView];
    
    [self addToolBar];
    
    nothingView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    nothingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nothingView];
}

#pragma mark -------------------UITableView Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 && _commentArray.count < 1 ) {
        return 0;
    }
    if (section == 0 && !_isCircle) {
        return 0;
    }
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headViewFrom:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && _isCircle) {
        static NSString *commentCellIdentifier = @"fromCellIdentifeir";
        SquareFromeCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
        if (!cell) {
            cell =[[SquareFromeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellIdentifier];
        }
        if (_dataSourceItem) {
            [cell refreshFromDict:_dataSourceItem.fromInfo];
        }
        return cell;
    }
    static NSString *commentCellIdentifier = @"commentCellIdentifier";
    SquareCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
    if (!cell) {
        cell = [[SquareCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tag = indexPath.row;
    
    [cell bingLongPressAction:@selector(longPressAction:) target:self withSender:@"longpress"];
    [cell bingLongPressAction:@selector(popUpDetailedFunction:) target:self withSender:@"detailed"];
    
    SquareCommentItem *item = [_commentArray objectAtIndex:indexPath.row];
    [cell refreshDataWith:item owner:self];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && _isCircle) {
        return 1;
    }
    return _commentArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isCircle) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && _isCircle) {
        return 100;
    }
    
    if (_commentArray.count >0) {
        SquareCommentItem *item = [_commentArray objectAtIndex:indexPath.row];
        if (!item) {
            return 0;
        }
        return item.commentCellHeight;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0 && _isCircle) {
        NSString *userId = _dataSourceItem.userInfo[@"userId"];
        if (userId == NULL || self == NULL || self == NULL) return;
        SquareUserPageViewController *userPageVC = [[SquareUserPageViewController alloc]initWithQuery:@{@"userId":userId}];
        [self.navigationController pushViewController:userPageVC animated:YES];
        return;
    }
    
    SquareCommentItem *item = [_commentArray objectAtIndex:indexPath.row];
    if (![commentfield isFirstResponder]) {
        [commentfield becomeFirstResponder];
    }
    commentfield.text = nil;
    if (![item.userInfo[@"userId"] isEqual:[User defaultUser].item.userId]) {
        replayInfo  = item.userInfo;
        commentfield.placeholder = [NSString stringWithFormat:@"回复：%@",item.userInfo[@"nickname"]];
    }
   
}

/** 请求数据
 */
- (void)requestCommentAction
{
    self.view.userInteractionEnabled = NO;
    [LoadingView show:@"加载中..."];
    [[JWNetClient defaultJWNetClient]squareGet:@"/feeds/" requestParm:@{@"feed_id":_feedId?_feedId:_dataSourceItem._id} result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!self) return ;
        self.view.userInteractionEnabled = YES;
        if (!errmsg && responObject != NULL) {
            NSDictionary *data = responObject[@"data"];
            if (data) {
                nothingView.hidden = YES;
                _dataSourceItem = [[SquareDataItem alloc]initWithDictionary:data];
                [detailTableHead setValueForViews:_dataSourceItem];
                [self changeLikeBtnStatus:_dataSourceItem.liked];
                if (detailTable) {
                    [detailTable setTableHeaderView:detailTableHead];
                }
                
                commentBtn.contentLabel.text = [NSString stringWithFormat:@"评论 %d",_dataSourceItem.comment_count];

                if (!_feedId) {
                    _feedId = data[@"_id"];
                }
                NSArray *commentList = [data objectForKey:@"comment_list"];
                for (int i = 0 ; i< commentList.count; i++) {
                    SquareCommentItem *oneItem = [[SquareCommentItem alloc]initWithDictionary:commentList[i]];
                    [_commentArray addObject:oneItem];
                }
            }
            [detailTable reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:errmsg];
            detailTable.hidden = YES;
        }
    }];
}


#pragma mark ------------------------点击分享 -----------------------------------------
- (void)sharedBtnAction:(UIButton *)sender
{
    
    SharedItem *shareItem = [[SharedItem alloc] init];
    shareItem.title = @"纹身大咖最新动态";
    if (_dataSourceItem.content) {
        shareItem.content = _dataSourceItem.content;
    }
    shareItem.sharedURL = API_SHAREURL_FEED(_dataSourceItem._id);    
    BOOL haveHead = NO;
    if (detailTableHead) {
        if ([detailTableHead getHeadImg]) {
            haveHead = YES;
        }
    }
    shareItem.shareImg = haveHead?[detailTableHead getHeadImg]:[UIImage imageNamed: @"icon_userHead_default.png.png"];
    JWShareView *shareView = [[JWShareView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) withShareTypes:nil dataItem:shareItem UIViewController:self];
    [shareView show];

}


#pragma mark -------------------------- 点击赞 或取消赞-----------------------------------
- (void)clickLikedBtnAction:(SquareLikeButton *)sender
{
    //已经赞过取消赞
    if (sender.selected == YES) {
        likedBtn.selected = NO;

        --_dataSourceItem.like_count;
        _dataSourceItem.liked = NO;
        if (_dataSourceItem.like_count <=0 || !_dataSourceItem.like_count) {
            _dataSourceItem.like_count = 0;
        }
        [self changeLikeBtnStatus:NO];
        [[JWNetClient defaultJWNetClient]squareDelegate:@"/feeds/like/" requestParm:@{@"feed_id":_dataSourceItem._id} result:^(id responObject, NSString *errmsg) {
            if (errmsg ) {
                _dataSourceItem.like_count++;
                [self changeLikeBtnStatus:YES];
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:SquareLikeOrcommentChangedNotice object:_dataSourceItem];
            }
        }];
    }else{//没有赞过，赞
       
        likedBtn.selected = YES;
        _dataSourceItem.like_count++;
        _dataSourceItem.liked = YES;
        [self changeLikeBtnStatus:YES];
       
        

        [[JWNetClient defaultJWNetClient]squarePut:@"/feeds/like/" requestParm:@{@"feed_id":_dataSourceItem._id} result:^(id responObject, NSString *errmsg) {
            if (errmsg ) {
                _dataSourceItem.like_count--;
                if (_dataSourceItem.like_count <=0) {
                    _dataSourceItem.like_count = 0;
                }
                [self changeLikeBtnStatus:NO];
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:SquareLikeOrcommentChangedNotice object:_dataSourceItem];
            }
        }];
    }
}

/** 改变赞的状态
 */
- (void)changeLikeBtnStatus:(BOOL)isLiked
{
    likedBtn.contentLabel.text =[NSString stringWithFormat:@"赞 %d",_dataSourceItem.like_count];
    if (isLiked) {
        likedBtn.leftImgView.image = [UIImage imageNamed:@"icon_square_liked_white.png"];
        likedBtn.contentLabel.textColor = [UIColor whiteColor];
        likedBtn.backgroundColor = SEGMENTSELECT;
        likedBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        likedBtn.selected = YES;
    }else{
        likedBtn.selected = NO;
        likedBtn.leftImgView.image = [UIImage imageNamed:@"icon_square_unliked.png"];
        likedBtn.contentLabel.textColor = SquareTextColor;
        likedBtn.backgroundColor = [UIColor whiteColor];
        likedBtn.layer.borderColor = SquareTextColor.CGColor;

    }
    
}


#pragma mark ------------------------------ 点击评论-----------------------------
- (void)clickCommentBtn:(SquareLikeButton *)sender
{
    if (![commentfield isFirstResponder]) {
        [commentfield becomeFirstResponder];
    }
}

#pragma mark ------------------------------ longpress---------------------------------

- (void)longPressAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        if (!sender.view)   return;

        NSInteger tag = sender.view.tag;
        if (tag < _commentArray.count) {
            SquareCommentCell *cell = (SquareCommentCell *)sender.view;
            [cell becomeFirstResponder];
             operationComment = [_commentArray objectAtIndex:tag];
            NSString *userId = [[operationComment userInfo]objectForKey:@"userId"];
            UIMenuItem *item;
            if ([userId  isEqual:[User defaultUser].item.userId]) {
                item = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteCommentFunction:)];
            }else{
                item = [[UIMenuItem alloc]initWithTitle:@"举报" action:@selector(toReportCommentFunction:)];
            }
            UIMenuController *controll = [UIMenuController sharedMenuController];
            controll.menuItems = @[item];
            CGPoint location = [sender locationInView:sender.view];
            [controll setTargetRect:CGRectMake(location.x-60, location.y-15, 80, 30)  inView:cell];
            [controll setMenuVisible:YES animated:YES];

        }
    }
}

#pragma mark- ------------------------ 弹出 重新发送 删除----------------------------

- (void)popUpDetailedFunction:(UIButton *)sender
{
    
    SquareCommentCell *cell = (SquareCommentCell *)sender.superview;
    [sender becomeFirstResponder];
    NSInteger tag = sender.tag;
    if (tag < _commentArray.count) {
        operationComment = [_commentArray objectAtIndex:tag];
         UIMenuItem *  item1 = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteCommentFunction:)];
         UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:@"重新发送" action:@selector(resendCommentFunction:)];
        UIMenuController *controll = [UIMenuController sharedMenuController];
        controll.menuItems = @[item2,item1];
        [controll setTargetRect:sender.frame inView:cell];
        [controll setMenuVisible:YES animated:YES];
    }
}

#pragma mark ------------------------------ 重新发送评论 -----------------------------

- (void)resendCommentFunction:(id)sender
{
    if (!operationComment) {
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:_dataSourceItem._id forKey:@"feed_id"];
    [parm setObject:operationComment.content forKey:@"content"];
    if (operationComment.replyUserInfo) {
        [parm setObject:operationComment.replyUserInfo[@"userId"] forKey:@"replyUserId"];
        [parm setObject:operationComment.replyUserInfo[@"nickname"] forKey:@"replyNickName"];
    }
    __block SquareCommentItem *item = operationComment;
    item.dataStatus = CommentItemStatusLoading;
    
    
    [[JWNetClient defaultJWNetClient]squarePut:@"/comments/" requestParm:parm result:^(id responObject, NSString *errmsg) {
        if (!self) return ;
        if (errmsg || !responObject) {
            [SVProgressHUD showErrorWithStatus:errmsg];
            if (item) {
                if (responObject[@"data"]) {
                    item._id = [[responObject objectForKey:@"data"]objectForKey:@"comment_id"];
                }
                item.dataStatus = CommentItemStatusFail;
                if (item.changBlock) {
                    item.changBlock(item.dataStatus);
                }
            }
        }else{
            if (item) {
                item.dataStatus = CommentItemStatusNormal;
                if (item.changBlock) {
                    item.changBlock(item.dataStatus);
                }
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:SquareLikeOrcommentChangedNotice object:item];
        }
        
    }];

}

#pragma mark ------------------------------- 删除评论 -----------------------------
- (void)deleteCommentFunction:(id)sender
{
    if (operationComment) {
        if ([NSObject nulldata:operationComment._id ]) {
            [LoadingView show:@"删除中..."];
            [[JWNetClient defaultJWNetClient]squareDelegate:@"/comments/" requestParm:@{@"feed_id":_dataSourceItem._id,@"comment_id":operationComment._id} result:^(id responObject, NSString *errmsg) {
                [LoadingView dismiss];
                if (!self) return ;
                if (errmsg || !responObject) {
                    [SVProgressHUD showErrorWithStatus:errmsg];
                }else{
                    if ([_commentArray containsObject:operationComment]) {
                        [_commentArray removeObject:operationComment];
                        operationComment = nil;
                        [detailTable reloadData];
                    }
                    _dataSourceItem.comment_count-=1;
                    if (_dataSourceItem.comment_count<=0) {
                        _dataSourceItem.comment_count = 0;
                    }
                    commentBtn.contentLabel.text = [NSString stringWithFormat:@"评论 %d",_dataSourceItem.comment_count];
                    [[NSNotificationCenter defaultCenter]postNotificationName:SquareLikeOrcommentChangedNotice object:_dataSourceItem];
                }
                
            }];
            
        }else{
            if ([_commentArray containsObject:operationComment]) {
                [_commentArray removeObject:operationComment];
                operationComment = nil;
                [detailTable reloadData];

            }
            return;
        }
    }
    
}
#pragma mark ---------------------------- 举报评论 ---------------------------------

- (void)toReportCommentFunction:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"选择预报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"淫秽",@"虚假信息",@"垃圾广告",@"其他", nil];
    action.tag = 67;
    [action showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 67 && buttonIndex!= 4) {
        
        [[JWNetClient defaultJWNetClient]squarePut:@"/feeds/accuse/" requestParm:@{@"feedId":_dataSourceItem._id,@"reasonType":@(buttonIndex+1)} result:^(id responObject, NSString *errmsg) {
            if (!self) return ;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else {
                [SVProgressHUD showSuccessWithStatus:@"感谢参与！"];
            }
            
        }];
        return;
    }
    if (actionSheet.tag == 65 && buttonIndex == 0) {
        [LoadingView show:@"请稍候..."];
        self.view.userInteractionEnabled = NO;
        [[JWNetClient defaultJWNetClient]squareDelegate:@"/feeds/" requestParm:@{@"feed_id":_dataSourceItem._id} result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if (!self) return ;
            self.view.userInteractionEnabled = YES;
            if (errmsg || !responObject) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:SquareFeedDelegateNotice object:_dataSourceItem];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }];

        return;
    }
    if (actionSheet.tag == 66 && buttonIndex!= 4) {
        [[JWNetClient defaultJWNetClient]squarePut:@"/feeds/accuse/" requestParm:@{@"feedId":_dataSourceItem._id,@"reasonType":@(buttonIndex+1)} result:^(id responObject, NSString *errmsg) {
            if (!self) return ;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else {
                [SVProgressHUD showSuccessWithStatus:@"感谢参与！"];
            }
            
        }];

        return;
    }

}
/**
 *  添加工具栏
 */
- (void)addToolBar
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0,SCREENHEIGHT, SCREENWIDTH, 44);
    bgView.image = [UIImage imageNamed:@"chat_bottom_bg"];
    bgView.userInteractionEnabled = YES;
    _toolBar = bgView;
    [self.view addSubview:bgView];
    
    
    UITextField *textField = [[UITextField alloc] init];
    textField.returnKeyType = UIReturnKeySend;
    textField.enablesReturnKeyAutomatically = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.frame = CGRectMake(20, 7, SCREENWIDTH-40, 30);
    textField.background = [UIImage imageNamed:@"chat_bottom_textfield"];
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:14];
    commentfield = textField;
    [bgView addSubview:textField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

}

/** 键盘发生改变执行
 */
- (void)keyboardWillChanged:(NSNotification *)note
{

    NSDictionary *userInfo = note.userInfo;
//    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y- 64-44;
    
    if (keyFrame.origin.y>=SCREENHEIGHT-64) {
        moveY=  SCREENHEIGHT;
    }
    
        _toolBar.frame = CGRectMake(0, moveY, SCREENWIDTH, 44);
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    backClearView.hidden = NO;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    backClearView.hidden = YES;
    _toolBar.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 44);
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([NSObject nulldata:textField.text ] ) {
        [self performSelectorInBackground:@selector(requestReleaseCommentAction:) withObject:textField.text];
    }
    textField.text = nil;
    replayInfo = nil;
    commentfield.placeholder = nil;
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([commentfield isFirstResponder]) {
        [commentfield resignFirstResponder];
        commentfield.text= nil;
        commentfield.placeholder = nil;
        replayInfo = nil;
    }

}


#pragma mark --------------------------------- 发布评论-------------------------------
- (void)requestReleaseCommentAction:(NSString *)text
{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:_dataSourceItem._id forKey:@"feed_id"];
    [parm setObject:text forKey:@"content"];
    if (replayInfo) {
        [parm setObject:replayInfo[@"userId"] forKey:@"replyUserId"];
        [parm setObject:replayInfo[@"nickname"] forKey:@"replyNickName"];
    }
    __block SquareCommentItem *item = [[SquareCommentItem alloc]initWithDictionary:parm];
    item.dataStatus = CommentItemStatusLoading;
    NSMutableDictionary *myUserInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    [myUserInfo setObject:[User defaultUser].item.nickname forKey:@"nickname"];
    [myUserInfo setObject:[User defaultUser].item.userId forKey:@"userId"];
    [myUserInfo setObject:[User defaultUser].item.avatar forKey:@"avatar"];
    item.userInfo = myUserInfo;
    item.replyUserInfo = replayInfo;
    item.time = [[NSDate date]timeIntervalSince1970];
    [item calculateWithCommentCellHeight];
    [_commentArray addObject:item];
    [detailTable reloadData];
    [detailTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_commentArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [[JWNetClient defaultJWNetClient]squarePut:@"/comments/" requestParm:parm result:^(id responObject, NSString *errmsg) {
        if (!self) return ;
            if (errmsg || !responObject) {
                [SVProgressHUD showErrorWithStatus:errmsg];
                if (item) {
                    if (responObject[@"data"]) {
                        item._id = [[responObject objectForKey:@"data"]objectForKey:@"comment_id"];
                    }
                    item.dataStatus = CommentItemStatusFail;
                    if (item.changBlock) {
                        item.changBlock(item.dataStatus);
                    }
                }
            }else{
                if (item) {
                    item.dataStatus = CommentItemStatusNormal;
                    if (item.changBlock) {
                        item.changBlock(item.dataStatus);
                    }
                }
                _dataSourceItem.comment_count+=1;
                commentBtn.contentLabel.text = [NSString stringWithFormat:@"评论 %d",_dataSourceItem.comment_count];
                [[NSNotificationCenter defaultCenter]postNotificationName:SquareLikeOrcommentChangedNotice object:_dataSourceItem];
            }

    }];
}


- (UIView *)headViewFrom:(NSInteger)index
{
    UILabel *label = [UILabel labelWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
    label.backgroundColor = VIEWBACKGROUNDCOLOR;
    if (index == 0 && _isCircle) {
        label.text = @"  来自";
    }else{
        if (_commentArray.count<1 ) {
            return nil;
        }
        label.text = @"  评论";
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(50, 15, SCREENWIDTH-50, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    [label addSubview:lineView];
    
    return label;
}

- (void)dealloc
{
    _dataSourceItem = nil;
    
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



