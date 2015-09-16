//
//  LoadingView.h
//  CulturePlotContest
//
//  Created by wgkj on 13-12-26.
//  Copyright (c) 2013年 wgkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configurations.h"

#define sheme_black
//-------------------------------------------------------------------------------------------------------------------------------------------------
#define HUD_STATUS_FONT			[UIFont boldSystemFontOfSize:16]
//-------------------------------------------------------------------------------------------------------------------------------------------------
#ifdef sheme_white
#define HUD_STATUS_COLOR		[UIColor whiteColor]
#define HUD_SPINNER_COLOR		[UIColor whiteColor]
#define HUD_BACKGROUND_COLOR	[UIColor colorWithWhite:0 alpha:0.8]
#endif
//-------------------------------------------------------------------------------------------------------------------------------------------------
#ifdef sheme_black
#define HUD_STATUS_COLOR		[UIColor blackColor]
#define HUD_SPINNER_COLOR		[UIColor blackColor]
#define HUD_BACKGROUND_COLOR	[UIColor colorWithWhite:0 alpha:0.2]
#endif


@interface LoadingView : UIView

+ (LoadingView *)shared;

+ (void)dismiss;
+ (void)show:(NSString *)status;

@property (atomic, strong) UIWindow *window;
//@property (atomic, strong) UIToolbar *hud;
@property(atomic,strong)UIView *hud;

@property (atomic, strong) UIActivityIndicatorView *spinner;
@property (atomic, strong) UIImageView *image;
@property (atomic, strong) UILabel *label;

@end


