//
//  SpecialDetailController.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SpecialDetailController.h"
#import "SquareInfoDetailHead.h"
#import "Configurations.h"
#import "SquareCommentCell.h"
#import "SpecialDetailHeaderView.h"
#import "JWSquarePhotoAndTextViewController.h"
#import "UIImageView+WebCache.h"

@interface SpecialDetailController ()<SpecialDetailHeaderViewDelegate>

@property (nonatomic, strong) NSMutableArray *commentArray; //评论列表

@property (nonatomic,strong) SquareInfoDetailHead *detailTableHead;

@property (nonatomic, strong) SquareDataItem *dataSourceItem;//数据源

@property (nonatomic,strong) UITableView *detailTable;

@property (nonatomic,strong) SquareCommentItem *item;

@end

@implementation SpecialDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTitle:@"专题名称"];
    
    UIButton* rightBar = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBar.frame = CGRectMake(0, 0, 40, 40);
    [rightBar setImage:[UIImage imageNamed:@"icon_square_shared.png"] forState:UIControlStateNormal];
    [rightBar setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 0)];
    [rightBar addTarget:self action:@selector(sharedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBar];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    SpecialDetailHeaderView *headerView = [SpecialDetailHeaderView specialDetailHeaderView];
    headerView.isUp = YES;
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = VIEWBACKGROUNDCOLOR;
    
    [self setUpData];
  
}

- (void)setUpData
{
    self.commentArray = [NSMutableArray array];
    SquareCommentItem *item = [[SquareCommentItem alloc] init];
    item.content = @"大佛多少积分";
    item.time = 1442289963577;
    item.userInfo = @{@"nickname" : @"大纹身的确哈哈哈",@"userId" : @"100179",@"avatar" : @"http://img.meizhanggui.cc/499e93d6b935022b7af6f3429f97b4c3_640X640"};
    item.dataStatus = CommentItemStatusNormal;
    [item calculateWithCommentCellHeight];
    [self.commentArray addObject:item];
}

#pragma mark ------------------------点击分享 -----------------------------------------
- (void)sharedBtnAction:(UIButton *)sender
{
    HBLog(@"点击分享");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *commentCellIdentifier = @"commentCellIdentifier";
    SquareCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
    if (!cell) {
        cell = [[SquareCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    self.item = [self.commentArray objectAtIndex:indexPath.row];
    [cell refreshDataWith:self.item owner:self];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.item.commentCellHeight;
}

- (void)specialDetailHeaderViewDidClick:(SpecialDetailHeaderView *)specialDetailHeaderView index:(NSInteger)index
{
    NSArray *array = @[@"http://img.meizhanggui.cc/62e34eefa2413ff837f8bc16ef283dee_320X200",@"http://img.meizhanggui.cc/3c85c98a32f116705a037e64444eba88_225X200"];
    JWSquarePhotoAndTextViewController *jwSpeVc = [[JWSquarePhotoAndTextViewController alloc] initWithImgs:array withCurrentIndex:index];
    jwSpeVc.titleText = @"就覅圣诞节封ID实际覅劳动手机福利的手机福利的时间里手机福利时间到了ijdslifj水利局劳动时间是";
    [self.navigationController presentViewController:jwSpeVc animated:YES completion:nil];
}

@end
