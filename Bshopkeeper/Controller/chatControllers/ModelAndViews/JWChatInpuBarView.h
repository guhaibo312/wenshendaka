//
//  JWChatInpuBarView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JWInPutDelegate <NSObject>

- (void)resetInputViewHeight:(float)heitht;

- (void)sendMessage:(NSString *)content;

- (void)actionButton;

@end

@interface JWChatInpuBarView : UIView

@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UIButton *actionbutton;

@property (nonatomic, weak) id <JWInPutDelegate> delegate;


@end
