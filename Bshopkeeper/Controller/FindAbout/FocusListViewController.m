//
//  FocusListViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/17.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "FocusListViewController.h"
#import "SquareUserPageViewController.h"
#import "UIImageView+WebCache.h"

@class FocusItemCell;

@interface FocusListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *listTable;

}
@property (nonatomic, strong) NSString *urlHost;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) BOOL isFocus;


@property (nonatomic, strong)NSMutableArray *dataArray;

@end


@implementation FocusListViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _urlHost = query[@"urlhost"];
            _isFocus = [query[@"isFocus"] boolValue];
            _userID = query[@"userId"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _isFocus?@"关注":@"粉丝";
    
    _dataArray = [[NSMutableArray alloc]init];
    
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.backgroundColor = VIEWBACKGROUNDCOLOR;
    listTable.rowHeight = 60;
    [listTable setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
     listTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:listTable];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestAction];
}


- (void)requestAction

{
    __weak __typeof(self)weakSelf = self;
    [[JWNetClient defaultJWNetClient]squareGet:_urlHost requestParm:@{@"userId":_userID} result:^(id responObject, NSString *errmsg) {
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            if (weakSelf) {
                [weakSelf requestFinish:responObject];
            }
        }
    }];
}


- (void)requestFinish:(NSDictionary *)dict
{
    NSArray *tempArray = dict[@"data"];
    if (tempArray) {
        _dataArray = [NSMutableArray arrayWithArray:tempArray];
        [listTable reloadData];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    FocusItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FocusItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell refreshDataFrom:_dataArray[indexPath.row] ownerController:self];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

@interface FocusItemCell ()
{
    AFHTTPRequestOperation *operation;
}

@end

@implementation FocusItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 44, 44)];
        headImageView.backgroundColor = [UIColor clearColor];
        headImageView.layer.cornerRadius = 22;
        headImageView.clipsToBounds = YES;
        headImageView.userInteractionEnabled = YES;
        [headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadAction:)]];
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:headImageView];
        
        nameLabel =  [UILabel labelWithFrame:CGRectMake(headImageView.right+10, 10, SCREENWIDTH-headImageView.right-80, 40) fontSize:16 fontColor:[UIColor blackColor] text:@""];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        
        addFocusButton = [[UserHomeBtn alloc]initWithFrame:CGRectMake(SCREENWIDTH-75, 18, 60, 24) text:@"" imageName:@"icon_user_addfocus.png"];
        addFocusButton.layer.cornerRadius = 5;
        addFocusButton.clipsToBounds = YES;
        addFocusButton.nameLabel.textAlignment = NSTextAlignmentCenter;
        addFocusButton.nameLabel.font = [UIFont systemFontOfSize:12];
        addFocusButton.desIamgeView.frame = CGRectMake( 5 , 4, 16, 16);
        addFocusButton.nameLabel.frame = CGRectMake( 26 , 0, 34, 24);
        [addFocusButton setBackgroundImage:[UIUtils imageFromColor:VIEWBACKGROUNDCOLOR] forState:UIControlStateSelected];
        [addFocusButton setBackgroundImage:[UIUtils imageFromColor:SEGMENTSELECT] forState:UIControlStateNormal];
        [addFocusButton addTarget:self action:@selector(addFocusButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:addFocusButton];
    }
    return self;
}

- (void)refreshDataFrom:(NSDictionary *)dict ownerController:(UIViewController *)controller
{
    _dataItem = dict;
    _ownerController = controller;
    if (dict) {
        if ([NSObject nulldata: dict[@"avatar"]]) {
            [headImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"avatar"]]];
        }else{
            headImageView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
        }
        if ([NSObject nulldata:dict[@"nickname"]]) {
            nameLabel.text = dict[@"nickname"];
        }
        NSString *currentId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        NSString *userId = [NSString stringWithFormat:@"%@",[User defaultUser].item.userId];
        
        if ([currentId isEqual:userId]) {
            addFocusButton.hidden = YES;
        }else{
            addFocusButton.hidden = NO;
            if ([[User defaultUser].followingDict.allKeys containsObject:currentId]) {
                addFocusButton.selected = YES;
                addFocusButton.desIamgeView.hidden = YES;
                addFocusButton.nameLabel.text = @"已关注";
                addFocusButton.nameLabel.textColor = GRAYTEXTCOLOR;
                addFocusButton.nameLabel.frame = CGRectMake(0, 0, 60, 24);
            }else{
                addFocusButton.selected = NO;
                addFocusButton.desIamgeView.hidden = NO;
                addFocusButton.nameLabel.text = @"关注";
                addFocusButton.nameLabel.textColor = [UIColor whiteColor];
                addFocusButton.nameLabel.frame = CGRectMake(26, 0, 34, 24);
            }

        }
        
    }
    
}


#pragma mark -- 点击关注
- (void)addFocusButtonFunction:(UserHomeBtn *)sender
{
    __weak typeof(addFocusButton) focus = addFocusButton;

    if (!_dataItem[@"userId"]) return;
    focus.userInteractionEnabled = NO;
    
    if (sender.selected == YES) {
     operation  =   [[JWNetClient defaultJWNetClient]squarePost:@"/follows/cancelFollow" requestParm:@{@"follow_id":_dataItem[@"userId"]} result:^(id responObject, NSString *errmsg) {
            if (self == NULL ) return ;
         if (focus) {
             focus.userInteractionEnabled = YES;
             
         }
         if (responObject && !errmsg && focus ) {
            focus.selected = NO;
            focus.desIamgeView.hidden = NO;
            focus.nameLabel.frame = CGRectMake( 26 , 0, 34, 24);
            focus.nameLabel.textColor = [UIColor whiteColor];
            focus.nameLabel.text = @"关注";
            NSString *currentId = [NSString stringWithFormat:@"%@",_dataItem[@"userId"]];

            if ([User defaultUser].followingDict) {
               
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[User defaultUser].followingDict.allKeys];
                if ([tempArray containsObject:currentId]) {
                    [[User defaultUser].followingDict removeObjectForKey:currentId];
                }
            }
         }
        }];
    }else{
      operation =   [[JWNetClient defaultJWNetClient]squarePost:@"/follows/follow" requestParm:@{@"follow_id":_dataItem[@"userId"]} result:^(id responObject, NSString *errmsg) {
            if (self == NULL ) return ;
          if (focus) {
              focus.userInteractionEnabled = YES;
          }
          
          if (responObject && !errmsg ) {
            if (focus) {
                focus.selected = YES;
                focus.desIamgeView.hidden = YES;
                focus.nameLabel.frame = CGRectMake( 0 , 0, 60, 24);
                focus.nameLabel.text = @"已关注";
                focus.nameLabel.textColor = GRAYTEXTCOLOR;
                NSString *currentId = [NSString stringWithFormat:@"%@",_dataItem[@"userId"]];
                if ([User defaultUser].followingDict) {
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[User defaultUser].followingDict.allKeys];
                    if (![tempArray containsObject:currentId]) {
                        [[User defaultUser].followingDict setObject:_dataItem forKey:currentId];
                    }
                }
            }
          }
        }];
        
    }
}

- (void)clickHeadAction:(id)sender
{
    if (!_dataItem || !_ownerController) return;
    NSString *userId = StringFormat(_dataItem[@"userId"]);
    if ([NSObject nulldata:userId]) {
        SquareUserPageViewController *userPageVC = [[SquareUserPageViewController alloc]initWithQuery:@{@"userId":userId}];
        [_ownerController.navigationController pushViewController:userPageVC animated:YES];
    }
}

- (void)dealloc
{
    if (operation) {
        [operation cancel];
    }
}

@end
