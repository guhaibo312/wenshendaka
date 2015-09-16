//
//  CreateTagViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//  自定义标签

#import "BasViewController.h"

@protocol CreateTagDelegate <NSObject>

- (BOOL)createTagWith:(NSString *)tagString;
@end

@interface CreateTagViewController : BasViewController

@property (nonatomic, assign) id<CreateTagDelegate> delegate;
@end
