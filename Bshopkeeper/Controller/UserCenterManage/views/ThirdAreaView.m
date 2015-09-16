//
//  ThirdAreaView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/31.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ThirdAreaView.h"
#import "CitySelectedViewController.h"
#import "Configurations.h"

@interface ThirdAreaView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *thirdTable;
}
@property (nonatomic, strong)NSArray *keyArray;

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) CityObject *selectCity;
@end

@implementation ThirdAreaView

- (instancetype)initWithFrame:(CGRect)frame cityObject:(CityObject *)currentCityObject
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _selectCity = [[CityObject alloc]init];
        _selectCity.cityName = currentCityObject.cityName;
        _selectCity.provinceCode = currentCityObject.provinceCode;
        _selectCity.cityCode = currentCityObject.cityCode;
        
        if (currentCityObject.cityCode) {
            NSDictionary *result = [[JudgeMethods defaultJudgeMethods].areaListDict objectForKey:[NSString stringWithFormat:@"%@",currentCityObject.cityCode]];
            if (result) {
                _keyArray = [NSArray arrayWithArray:result.allKeys];
                _dataDict = [NSDictionary dictionaryWithDictionary:result];
            }
        }
        thirdTable = [[UITableView alloc]initWithFrame:CGRectMake(30, 20, self.width-60, self.height-40)];
        thirdTable.backgroundColor = [UIColor whiteColor];
        thirdTable.layer.cornerRadius = 5;
        thirdTable.clipsToBounds = YES;
        thirdTable.tableFooterView = [[UIView alloc]init];
        thirdTable.dataSource = self;
        thirdTable.delegate = self;
        [self addSubview:thirdTable];
        self.backgroundColor = [UIColor colorWithWhite:.6 alpha:.7];
        
        if (_keyArray.count >0) {
            if (_keyArray.count *44+80 > self.height-40) {
                thirdTable.frame = CGRectMake(30, 20, self.width-60, self.height-40);
            }else{
                thirdTable.frame = CGRectMake(30, 20,self.width-60, _keyArray.count*44+80);
            }
        }
        thirdTable.center = self.center;

    }
    return self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *thirdViewIdentifier= @"thirdViewIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:thirdViewIdentifier];
    if (!cell) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:thirdViewIdentifier];
    }
    
    NSString *titleString= [_dataDict objectForKey:_keyArray[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = titleString;
   
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = _keyArray[indexPath.row];
    NSString *titleString= [_dataDict objectForKey:key];
    if (key && titleString) {
        _selectCity.areaCode = key;
        _selectCity.areaName = titleString;
        [self performCompleteBlockBack:@(YES)];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _keyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *clostButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.width, 40)];
    [clostButton addTarget:self action:@selector(closeThirdView:) forControlEvents:UIControlEventTouchUpInside];
    clostButton.backgroundColor = SEGMENTSELECT;
    [clostButton setTitle:@"关闭" forState:UIControlStateNormal];
    [clostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    clostButton.titleLabel.font = [UIFont systemFontOfSize:16];
    return clostButton;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *headLabel = [UILabel labelWithFrame:CGRectMake(0, 0, self.width, 40) fontSize:16 fontColor:[UIColor whiteColor] text:@""];
    if (_selectCity) {
        headLabel.text = _selectCity.cityName;
    }
    headLabel.backgroundColor = NAVIGATIONCOLOR;
    headLabel.textAlignment = NSTextAlignmentCenter;
 
    return headLabel;
}

- (void)closeThirdView:(id)sender
{
    self.transform = CGAffineTransformMakeScale(1, 1);
    
    __weak __typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.transform = CGAffineTransformMake(0, 0, 0, 0, 0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf removeFromSuperview];
        }
    }];
    
}

- (void)performCompleteBlockBack:(id)object
{
    BOOL isback = [object boolValue];
    if (_completeBlock) {
        _completeBlock(_selectCity,isback);
        _completeBlock = NULL;
    }

}

@end


