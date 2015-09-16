//
//  HobbyMainViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/7/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//  爱好者的主页

#import <UIKit/UIKit.h>



@interface HobbyMainViewController : UITabBarController


+ (instancetype) sharedInstance ;

- (void)selectControllerWithTag:(int)tag;

@end
