//
//  OrderRecycleViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderRecycleViewController.h"
#import "OrderInfoDetailViewController.h"
#import "OrderTableCell.h"


@interface OrderRecycleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *firstArray;
    UITableView *table;
}

@end

@implementation OrderRecycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"回收站";
    firstArray  = [NSMutableArray array];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT-64)];
    table.delegate = self;
    table.dataSource = self;
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    table.tableFooterView = footView;
    table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self changeData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"orderScrollViewIdentifier%ld%ld",(long)indexPath.section,(long)indexPath.row];
    OrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[OrderTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    [cell changContentFrom:firstArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return firstArray.count;
}

- (void)changeData
{
    
    [firstArray removeAllObjects];
    
    User *currentUser = [User defaultUser];
    TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",currentUser.item.userId]];
    
    NSString *orderTableName1 = [NSString stringWithFormat:@"%@%@",ORDERTABNAME,[User defaultUser].item.userId];
    NSString *customerTableName1 = [NSString stringWithFormat:@"%@%@",CUSTOMERTABLENAME,[User defaultUser].item.userId];

    NSArray *searchList = [operationDB startSearchWithString:[NSString stringWithFormat:@"select a.*, ifnull(b.name,a.customerInfoName ) resultname,ifnull(b.phonenum,a.customerInfoPhonenum ) resultphone from %@  as a left  outer join %@  as b on a.customerInfoId = b._id where a.recycle=1  ORDER BY updateTime DESC",orderTableName1,customerTableName1] withType:3];
    if (searchList.count >0) {
        for (int i = 0 ; i< searchList.count; i++) {
            OrderModel *one = [searchList objectAtIndex:i];
            NSTimeInterval currentTime = [[NSDate date]timeIntervalSince1970];
           
            [firstArray addObject:one];
        }
    }
    [table reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderModel *orderM = [firstArray objectAtIndex:indexPath.row];
    
    if (!orderM)return;
    
    OrderInfoDetailViewController *detailVC = [[OrderInfoDetailViewController alloc]initWithQuery:@{@"item":orderM}];
    [self.navigationController pushViewController:detailVC animated:YES];
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
