//
//  OrderChooseBankView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderChooseBankView.h"
#import "Configurations.h"

@interface OrderChooseBankView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *cardIdArray;
@end

@implementation OrderChooseBankView

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<OrderChooseBankViewDelegate>)adelegate superView:(UIView *)supView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.chooseDelegate = adelegate;
        _imageArray = @[@"ICBKCNBJ.png",@"PCBCCNBJ.png",@"ABOCCNBJ.png",@"COMMCNSH.png",@"CMBCCNBS.png",@"CIBKCNBJ.png",@"SPDBCNSJ.png",@"SZDBCNBS.png",@"MSBCCNBJ.png",@"SZCBCNBS.png"];
        _titleArray = @[@"中国工商银行",@"中国建设银行",@"中国农业银行",@"交通银行",@"招商银行",@"中信银行",@"上海浦东发展银行",@"深证发展银行",@"中国民生银行",@"平安银行"];
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 44;
        self.tag = 32;
        [supView addSubview:self];
    }
    return self;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"bankCellidentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *imgStr = [_imageArray objectAtIndex:indexPath.row];
    NSString *key = [[imgStr componentsSeparatedByString:@".png"]firstObject];
    if (_chooseDelegate && [_chooseDelegate respondsToSelector:@selector(chooseBankNameIdentifier:)]) {
        [_chooseDelegate chooseBankNameIdentifier:key];
    }
    [self dissMiss];
    
}

- (void)show
{
    CGRect rect = self.frame;
    self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 1);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        if (finished) {
            self.frame = rect;
        }
    }];
}

- (void)dissMiss
{
    if (self) {
        CGRect rect = self.frame;
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 0);
        } completion:^(BOOL finished) {
            if (finished) {
                if (self) {
                    [self removeFromSuperview];
                }
            }
        }];
    }
}

- (void)dealloc
{
    _titleArray = nil;
    _imageArray = nil;
}

@end
