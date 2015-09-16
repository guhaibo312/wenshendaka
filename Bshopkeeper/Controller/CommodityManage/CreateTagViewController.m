//
//  CreateTagViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CreateTagViewController.h"

@interface CreateTagViewController ()<UITextFieldDelegate>
{
    JWTextField *tagField;      //标签框
    
}
@end

@implementation CreateTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加标签";
    
    [self setRightNavigationBarTitle:@"完成" color:[UIColor whiteColor] fontSize:14 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
    
    UIView *lineView  = [[UIView alloc]initWithFrame:CGRectMake(10, 20, SCREENWIDTH- 20, 50)];
    lineView.layer.cornerRadius = 5;
    lineView.layer.borderColor = [UIColor whiteColor].CGColor;
    lineView.layer.borderWidth = 1;
    lineView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:lineView];
    
    tagField = [JWTextField fieldWithFrame:CGRectMake(5, 0, lineView.width-10, 50) font:14 place:@"标签" delete:self textColor:[UIColor blackColor]];
    tagField.backgroundColor = [UIColor clearColor];
    [lineView addSubview:tagField];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >=8 && ![string isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)rightNavigationBarAction:(UIButton *)sender
{
    [tagField resignFirstResponder];
    if (tagField.text.length <1) {
        [SVProgressHUD showErrorWithStatus:@"还没有内容哦"];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(createTagWith:)] ) {
        if ([_delegate createTagWith:tagField.text]) {
            return;
        }
    }
    [self backAction];
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
