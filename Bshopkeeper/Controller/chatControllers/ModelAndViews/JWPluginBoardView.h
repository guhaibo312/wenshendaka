//
//  JWPluginBoardView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//  功能版

#import <UIKit/UIKit.h>

typedef void(^selectedItemAction)(int index);


@interface JWPluginBoardView : UIScrollView

@property (nonatomic, copy) selectedItemAction actionBlock;


@end

@interface JWPluginBoardItem : NSObject

@property (nonatomic, strong) NSString *imageNamed;
@property (nonatomic, strong) NSString *titleString;

- (id)initWithDict:(NSDictionary *)dict;

@end
