//
//  OrderBankCardBundledViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderBankCardBundledViewController.h"
#import "OrderChooseBankView.h"

@interface OrderBankCardBundledViewController ()<UITextFieldDelegate,OrderChooseBankViewDelegate>
{
    UILabel *bankNameLabel;
    UITextField *bankCardNumberField;
    UITextField *bankCardNameField;
    UIScrollView *backScrollView;
    NSString *currentCardIdentifier;
    NSDictionary *cardIdentifier;
    NSMutableDictionary *parm;
}
@end

@implementation OrderBankCardBundledViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    parm = [NSMutableDictionary dictionary];
    cardIdentifier = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BankName" ofType:@"plist"]];
    self.title = @"绑定银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setRightNavigationBarTitle:@"完成" color:[UIColor whiteColor] fontSize:14 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
    [self layoutSubViews];
}

- (void)rightNavigationBarAction:(UIButton *)sender
{
    [bankCardNameField resignFirstResponder];
    [bankCardNumberField resignFirstResponder];
    if (![NSObject nulldata:bankCardNumberField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写银行卡号"];
        return;
    }else{
        NSString *bankNumberStr = [self bankNumToNormalNum];
        if (bankNumberStr.length<16 || bankNumberStr.length >19) {
            [SVProgressHUD showErrorWithStatus:@"正确的银行卡号是16或者19位，请重新确认"];
            return;
        }
    }
    if (![NSObject nulldata:bankCardNameField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写银行卡对应的姓名"];
        return;
    }
    
    NSMutableDictionary *bankcardDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [bankcardDict setObject:currentCardIdentifier forKey:@"bank"];
    [bankcardDict setObject:bankCardNameField.text forKey:@"name"];
    [bankcardDict setObject:[self bankNumToNormalNum] forKey:@"cardNum"];
    [parm setObject:bankcardDict forKey:@"bankcard"];
    
    [LoadingView show:@"请稍后..."];
    self.view.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[JWNetClient defaultJWNetClient]postNetClient:@"User/userInfo" requestParm:parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!self) return ;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.view.userInteractionEnabled = YES;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            
            [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
            [User defaultUser].item.bankcard = [parm objectForKey:@"bankcard"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
   
}

- (void)layoutSubViews
{
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    backScrollView.backgroundColor = [UIColor whiteColor];
    backScrollView.contentSize = backScrollView.size;
    backScrollView.scrollEnabled = NO;
    [self.view addSubview:backScrollView];
    
    UILabel *titlelabel = [UILabel labelWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 40) fontSize:12 fontColor:GRAYTEXTCOLOR text:@"请填写银行卡信息，用于收取定金"];
    [backScrollView addSubview:titlelabel];
    
    UIView *inputCardView = [[UIView alloc]initWithFrame:CGRectMake(10, titlelabel.bottom, SCREENWIDTH-20, 44*3)];
    inputCardView.backgroundColor = [UIColor whiteColor];
    inputCardView.layer.cornerRadius = 5;
    inputCardView.layer.borderWidth = 0.5;
    inputCardView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [backScrollView addSubview:inputCardView];
    
     // 两条分割线
    UIView *oneLine = [[UIView alloc]initWithFrame:CGRectMake(0, 43.75, inputCardView.width, 0.5)];
    oneLine.backgroundColor = [UIColor lightGrayColor];
    [inputCardView addSubview:oneLine];
    
    UIView *twoLine = [[UIView alloc]initWithFrame:CGRectMake(0, 43.75+44, inputCardView.width, 0.5)];
    twoLine.backgroundColor = [UIColor lightGrayColor];
    [inputCardView addSubview:twoLine];
    
    bankNameLabel = [UILabel labelWithFrame:CGRectMake(20, 2, inputCardView.width-40, 40) fontSize:14 fontColor:[UIColor blackColor] text:@"招商银行"];
    [inputCardView addSubview:bankNameLabel];
    currentCardIdentifier = @"CMBCCNBS";
    
    UIImageView *point1 = [[UIImageView alloc]initWithFrame:CGRectMake(inputCardView.width-16-10,14, 16,16)];
    point1.image = [UIImage imageNamed:@"icon_point_down.png"];
    [inputCardView addSubview:point1];

    UIButton *chooseBankBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, inputCardView.width, 44)];
    chooseBankBtn.backgroundColor = [UIColor clearColor];
    [chooseBankBtn addTarget:self action:@selector(shooseBankFunction:) forControlEvents:UIControlEventTouchUpInside];
    [inputCardView addSubview:chooseBankBtn];
    
    bankCardNumberField = [[UITextField alloc]initWithFrame:CGRectMake(20, 46, inputCardView.width-40, 40)];
    bankCardNumberField.font = [UIFont systemFontOfSize:14];
    bankCardNumberField.placeholder = @"输入银行卡号";
    bankCardNumberField.keyboardType = UIKeyboardTypeNumberPad;
    bankCardNumberField.returnKeyType = UIReturnKeyDone;
    bankCardNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    bankCardNumberField.delegate = self;
    [inputCardView addSubview:bankCardNumberField];
    
    bankCardNameField = [[UITextField alloc]initWithFrame:CGRectMake(20, 90, inputCardView.width-40, 40)];
    bankCardNameField.font = [UIFont systemFontOfSize:14];
    bankCardNameField.placeholder = @"输入姓名";
    bankCardNameField.delegate = self;
    bankCardNameField.returnKeyType = UIReturnKeyDone;
    bankCardNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [inputCardView addSubview:bankCardNameField];
    
    UILabel *footLabel = [UILabel labelWithFrame:CGRectMake(20, inputCardView.bottom+20, SCREENWIDTH-40, SCREENHEIGHT-inputCardView.bottom-64-20) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
    NSString *labelText = @"注意\n1.银行卡开户人信息必须同填写的姓名一致，才能提现。\n2.开户银行、卡号必须准确无误，否则无法提现。\n3.银行卡仅支持储蓄卡，请不要填写信用卡。\n4.绑定62开头、有银联标识的储蓄卡，提现更及时。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    
    footLabel.attributedText = attributedString;
    footLabel.numberOfLines = 0;
    [footLabel sizeToFit];
    footLabel.top = inputCardView.bottom+20;
    [backScrollView addSubview:footLabel];
    
}

#pragma mark ------------------------------------选择银行卡------------------------------------------
- (void)shooseBankFunction:(UIButton *)sender
{
    [bankCardNameField resignFirstResponder];
    [bankCardNumberField resignFirstResponder];
    [self.view endEditing:YES];
    
    OrderChooseBankView *bankView = (OrderChooseBankView *)[self.view viewWithTag:32];
    if (bankView) {
        [bankView dissMiss];
        return;
    }
    
    OrderChooseBankView *chooseView = [[OrderChooseBankView alloc]initWithFrame:CGRectMake(0, 84, SCREENWIDTH, SCREENHEIGHT-64-84-10) withDelegate:self superView:self.view];
    [chooseView show];
}

#pragma mark ------------------------- 选择银行卡回调----------------------
- (void)chooseBankNameIdentifier:(NSString *)bankNameId;
{
    currentCardIdentifier = bankNameId;
    bankNameLabel.text = [cardIdentifier objectForKey:bankNameId];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
    if (textField == bankCardNameField && textField.text.length >=14 && ![string isEqualToString:@""]) {
        return NO;
    }
    if (textField == bankCardNumberField ) {
        NSString *text = [bankCardNumberField text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        // 限制长度
        if (newString.length >= 24) {
            return NO;
        }
        
        [bankCardNumberField setText:newString];
        
        return NO;  
        
    }
    
    return YES;
}

-(NSString *)bankNumToNormalNum
{
    return [bankCardNumberField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
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
