//
//  OrderManageCenterViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/20.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "BasViewController.h"

@interface OrderManageCenterViewController : BasViewController

/**刷新数据
 */
- (void)changeList;

/* 登记预约之后直接跳到历史
 **/
- (void)addOrderCompleteScrollToHistory;

/**回到待确认
 */
- (void)backToPindingList;

@end
