//
//  GoStoreSettingViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/28.
//  Copyright (c) 2015年 jinwei. All rights reserved.
// 到店设置

#import "BasViewController.h"


@protocol SelectedCompanyDelegate <NSObject>

- (void)completeCompanyEditWithDict:(NSDictionary *)dict;

@end
@interface GoStoreSettingViewController : BasViewController

@property(nonatomic, assign) id <SelectedCompanyDelegate>delegate;

@end
