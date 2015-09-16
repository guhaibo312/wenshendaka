//
//  OrderChooseBankView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderChooseBankViewDelegate <NSObject>

- (void)chooseBankNameIdentifier:(NSString *)bankNameId;

@end

@interface OrderChooseBankView : UITableView

@property (nonatomic, assign) id<OrderChooseBankViewDelegate> chooseDelegate;

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<OrderChooseBankViewDelegate>)adelegate superView:(UIView *)supView;

- (void)show;

- (void)dissMiss;

@end
