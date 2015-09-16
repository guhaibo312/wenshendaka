//
//  AppDelegate.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "HobbyMainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *mainVC;

@property (nonatomic, strong) HobbyMainViewController *hobbyVC;

@property (nonatomic, strong) NSString *vendor;

+ (AppDelegate*) appDelegate;

- (void)pushToLogInControllor:(BOOL)isPush;


- (void)setGeTuiToken:(NSString *)atoken;

- (BOOL)setGeTuiTag:(NSArray *)aTag;

- (void)bindGeTuiAlisa:(NSString *)alias;

- (void)unbingdGeTuiAlisa:(NSString *)alias;

- (void)openGetui:(BOOL)open;

@end

