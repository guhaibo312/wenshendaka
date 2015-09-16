//
//  OrderScrollView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderScrollView.h"
#import "Configurations.h"
#import "OrderTableCell.h"
#import "CustomerModel.h"
#import "OrderInfoDetailViewController.h"

@interface OrderScrollView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *firstArray;
    NSMutableArray *secondArray;
    
    UIView *nothingView1;
    UIView *nothingView2;
}
@property (nonatomic, assign) BasViewController *baseVC;
@end

@implementation OrderScrollView


- (instancetype)initWithFrame:(CGRect)frame withController:(BasViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        _baseVC = controller;
        firstArray = [NSMutableArray array];
        secondArray = [NSMutableArray array];
        
        for (int i= 0 ; i< 2; i++) {
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(i*SCREENWIDTH, 0, SCREENWIDTH, frame.size.height)];
            tableView.delegate = self;
            tableView.dataSource = self;
            UIView *footView = [[UIView alloc]init];
            footView.backgroundColor = [UIColor whiteColor];
            tableView.tableFooterView = footView;
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            [self addSubview:tableView];
            
            if (i ==0) {
                firstTableView = tableView;
            }else{
                secondTableView = tableView;
            }
        }
        
        nothingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.height)];
        nothingView1.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel labelWithFrame:CGRectMake(30, 40, SCREENWIDTH-40, 200) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        NSString *labelText = @"如何获得预约订单?\n方式一：多多分享作品，顾客主动预约。\n方式二：主动发出邀约。";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:
         NSMakeRange(0, [labelText length])];
        label.attributedText = attributedString;
        label.numberOfLines = 0;
        [label sizeToFit];
        label.top = 40;
        [nothingView1 addSubview:label];
        nothingView1.hidden = YES;
        [self addSubview:nothingView1];
        
        nothingView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, self.height)];
        nothingView2.backgroundColor = [UIColor whiteColor];
        UILabel *label1 = [UILabel labelWithFrame:CGRectMake(30, 40, SCREENWIDTH-60, 200) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        NSString *labelText1 = @"如何获得预约订单?\n方式一：多多分享作品，顾客主动预约。\n方式二：主动发出邀约。";
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:labelText1];
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:10];//调整行间距
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:
         NSMakeRange(0, [labelText1 length])];
        label1.attributedText = attributedString1;
        label1.numberOfLines = 0;
        [label1 sizeToFit];
        label1.top = 40;
        [nothingView2 addSubview:label1];
        nothingView2.hidden = YES;
        [self addSubview:nothingView2];

        
        self.contentSize = CGSizeMake(SCREENWIDTH *2, frame.size.height);
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"orderScrollViewIdentifier%ld%ld";
    OrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[OrderTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    }
     
    if (tableView == firstTableView) {
        [cell changContentFrom:firstArray[indexPath.row]];
    }else if (tableView == secondTableView){
        [cell changContentFrom:secondArray[indexPath.row]];

    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == firstTableView) {
        return firstArray.count;
    }
    return secondArray.count;
}

- (void)changeDataFromArray:(NSArray *)array
{
    
    [firstArray removeAllObjects];
    [secondArray removeAllObjects];
    User *currentUser = [User defaultUser];
    TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",currentUser.item.userId]];
    NSString *orderTableName1 = [NSString stringWithFormat:@"%@%@",ORDERTABNAME,[User defaultUser].item.userId];
    NSString *customerTableName1 = [NSString stringWithFormat:@"%@%@",CUSTOMERTABLENAME,[User defaultUser].item.userId];
    NSArray *searchList = [operationDB startSearchWithString:[NSString stringWithFormat:@"select a.*, ifnull(b.name,a.customerInfoName ) resultname,ifnull(b.phonenum,a.customerInfoPhonenum ) resultphone from %@ as a left  outer join  %@  as b on a.customerInfoId = b._id ORDER BY updateTime DESC",orderTableName1,customerTableName1] withType:3];
    
    if (searchList.count >0) {
        for (int i = 0 ; i< searchList.count; i++) {
            OrderModel *one = [searchList objectAtIndex:i];
        
            int statusCode = [one.orderStatus intValue];
            
            NSTimeInterval currentTime = [[NSDate date]timeIntervalSince1970];
            BOOL isValidity = YES;
            if (one.orderTime) {
                NSTimeInterval orderNumber = [one.orderTime doubleValue]/1000;
                if (orderNumber < currentTime) {
                    isValidity = NO;
                }
            }
            if (!one.recycle) {
                if ( statusCode == 7 && isValidity) {
                    [firstArray addObject:one];
                }else{
                    if (statusCode == 1 || statusCode == 2 || statusCode == 7 || statusCode == 10 || statusCode == 11 || statusCode == 14 || statusCode == 20 ) {
                        [secondArray addObject:one];
                    }
                }
            }
        }
    }
    if (firstArray.count >0) {
        nothingView1.hidden = YES;
    }else{
        nothingView1.hidden = NO;
    }
    if (secondArray.count >0) {
        nothingView2.hidden = YES;
    }else{
        nothingView2.hidden = NO;
    }
    
    [firstTableView reloadData];
    [secondTableView reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderModel *orderM;
    if (tableView == firstTableView) {
         orderM = [firstArray objectAtIndex:indexPath.row];
    }else{
        orderM = [secondArray objectAtIndex:indexPath.row];
    }
    OrderInfoDetailViewController *detailVC = [[OrderInfoDetailViewController alloc]initWithQuery:@{@"item":orderM}];
    [_baseVC.navigationController pushViewController:detailVC animated:YES];
}

/**获取是否有数据
 */
- (BOOL)gethaveDataListFrom:(int)type
{
    if (type == 1) {
        if (firstArray.count <1) {
            return NO;
        }
    }else{
        if (secondArray.count<1) {
            return NO;
        }
    }
    return YES;
}

- (int)getDataCount:(int)type
{
    if (type == 1) {
        return firstArray.count;
    }else{
        return secondArray.count;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
