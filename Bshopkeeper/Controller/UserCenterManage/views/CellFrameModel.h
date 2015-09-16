//
//  CellFrameModel.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/9.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MessageModel;

#define textPadding 15

@interface CellFrameModel : NSObject

@property (nonatomic, strong) MessageModel *message;
@property (nonatomic, assign) CGRect timeFrame;
@property (nonatomic, assign) CGRect iconFrame;
@property (nonatomic, assign) CGRect textFrame;
@property (nonatomic, assign) float cellHeght;

@end
