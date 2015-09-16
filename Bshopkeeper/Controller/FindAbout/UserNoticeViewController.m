//
//  UserNoticeViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "UserNoticeViewController.h"
#import "MessageRelatedTableView.h"

@interface UserNoticeViewController ()
{
    MessageRelatedTableView *messageView;
}
@property (nonatomic, assign) BOOL showNewMessage;
@end

@implementation UserNoticeViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _showNewMessage  = [query[@"newmessage"] boolValue];
        }
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [JudgeMethods defaultJudgeMethods].showSquareNotice = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    messageView = [[MessageRelatedTableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)withOwner:self isReceiveNotice:_showNewMessage];
    [self.view addSubview:messageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
