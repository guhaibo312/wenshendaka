//
//  OrderWaitConfirmViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/2.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderWaitConfirmViewController.h"
#import "EditOrAddOrderViewController.h"
#import "OrderModel.h"
#import "OrderTableCell.h"
#import "CustomerModel.h"
#import "OrderInfoDetailViewController.h"

@interface OrderWaitConfirmViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *orderListTabel;
    NSMutableArray *dataArray;
}

@property (nonatomic, strong) NSString * orderStatus;  //订单状态
@end

@implementation OrderWaitConfirmViewController


- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _orderStatus = query[@"statusString"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    orderListTabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-90)];
    orderListTabel.delegate = self;
    orderListTabel.dataSource = self;
    orderListTabel.rowHeight = 140;
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    orderListTabel.tableFooterView = footView;
    [self.view addSubview:orderListTabel];
    dataArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor redColor];
    [self requestFromServer];

}

#pragma mark ----------------------拉去数据
- (void)requestFromServer
{
    
    [dataArray removeAllObjects];
    User *currentUser = [User defaultUser];
    TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",currentUser.item.userId]];
    
    NSArray *searchList =  [operationDB findAllFromType:3 fromeTable:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,currentUser.item.userId]];
    if (searchList.count >0) {
        for (int i = 0 ; i< searchList.count; i++) {
            OrderModel *one = [searchList objectAtIndex:i];
            
            if (one.customerInfoId) {
                TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",currentUser.item.userId]];
                CustomerModel *customerInfo = [[operationDB findWithClassType:1 fromid:one.customerInfoId keyName:@"_id" fromeTable:[NSString stringWithFormat:@"%@%@",CUSTOMERTABLENAME,currentUser.item.userId]] firstObject];
                if (customerInfo) {
                    one.customerInfoName = customerInfo.name;
                    one.customerInfoPhonenum = customerInfo.phonenum;
                }
            }
            if ([_orderStatus isEqualToString:@"待处理"]) {
                if ([one.orderStatus intValue] == 10 || [one.orderStatus intValue] == 11){
                    [dataArray addObject:one];
                }
                continue;
            }else if ([_orderStatus isEqualToString:@"待消费"]){
                if ([one.orderStatus intValue] == 4|| [one.orderStatus intValue] == 7){
                    [dataArray addObject:one];
                }
                continue;
            }else{
                [dataArray addObject:one];
                continue;
            }
        }
        [orderListTabel reloadData];
    }
    
}

/*刷新
 **/
- (void)refreshControlList
{
    [self requestFromServer];
}

#pragma mark ---------------------  table delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *orderCellIdentifier = @"orderCellIdentifier";
    OrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier];
    if (cell == nil) {
        cell = [[OrderTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCellIdentifier];
    }
    [cell changContentFrom:[dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderModel *orderM = [dataArray objectAtIndex:indexPath.row];
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
