//
//  InstitutionSelectedViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/17.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//  机构选择

#import "BasViewController.h"

@protocol InstitutionDelegate <NSObject>

- (void)selectedInstitution:(NSDictionary *)dict;

@end

@interface InstitutionSelectedViewController : BasViewController

@property (nonatomic, assign)id <InstitutionDelegate>delegate;
@end
