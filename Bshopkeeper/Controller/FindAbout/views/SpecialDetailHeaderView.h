//
//  SpecialDetailHeaderView.h
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpecialDetailHeaderView;

@protocol SpecialDetailHeaderViewDelegate <NSObject>

- (void)specialDetailHeaderViewDidClick : (SpecialDetailHeaderView *)specialDetailHeaderView index : (NSInteger)index;

@end

@interface SpecialDetailHeaderView : UIView

+ (instancetype)specialDetailHeaderView;

@property (nonatomic,assign) bool isUp;

@property (nonatomic,weak) id<SpecialDetailHeaderViewDelegate> delegate;

@end
