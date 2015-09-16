//
//  OrderWXYYViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderWXYYViewController.h"
#import "OrderWxRMViewController.h"
#import "JWEditView.h"
#import "TTTAttributedLabel.h"
#import "UserHomeBtn.h"
#import "UIImageView+WebCache.h"

@interface OrderWXYYViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    JWEditView *djItem;
    JWEditView *remarkItem;
}
@property (nonatomic, strong)    UIImageView *headI;

@end

@implementation OrderWXYYViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _isInvitation = [query[@"invitation"] boolValue];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setRightNavigationBarTitle:@"下一步" color:[UIColor whiteColor] fontSize:14 isBold:NO frame:CGRectMake(0, 0, 60, 40)];
    self.view.backgroundColor = VIEWBACKGROUNDCOLOR;
    
    _headI = [[UIImageView alloc]init];
    _headI.image =[UIImage imageNamed:@"icon_userHead_default.png"];
    if ([User defaultUser].item.avatar) {
        [_headI sd_setImageWithURL:[NSURL URLWithString:[User defaultUser].item.avatar]];
    }
    
    
    djItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 44) withTitleLabel:_isInvitation?@"定金( ¥ )":@" ¥ " type:JWEditTextField detailImgName:nil];
    djItem.editTextField.delegate = self;
    djItem.editTextField.placeholder = _isInvitation?@"0表示不收取定金":@"请输入收款金额";
    djItem.editTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:djItem];
    
    TTTAttributedLabel *threeLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(30, djItem.bottom+10, SCREENWIDTH-60 , 30)];
    NSMutableDictionary *mutableLinkAttributes3 = [NSMutableDictionary dictionary];
    [mutableLinkAttributes3 setValue:(id)[[UIColor redColor] CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
    [mutableLinkAttributes3 setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    threeLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes3];
    threeLabel.font = [UIFont systemFontOfSize:12];
    threeLabel.leading = 10;
    threeLabel.numberOfLines = 0;
    if (_isInvitation) {
        threeLabel.text = @"提示: 建议金额不用设置太高，提高成单率。";
    }else{
        threeLabel.text = @"提示：为打击无真实交易背景的虚假交易，银行卡转账套现或洗钱等被禁止的交易行为，请如实交易，否则款项将不能提现。";
        threeLabel.height = 60;
    }
    [threeLabel addLinkToPhoneNumber:@"提示" withRange:[threeLabel.text rangeOfString:@"提示"]];
    [self.view addSubview:threeLabel];
    
    if (_isInvitation) {
        self.title = @"微信邀约";

        remarkItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, threeLabel.bottom, SCREENWIDTH, 88) withTitleLabel:@"预约备注" type:JWEditTextView detailImgName:nil];
        remarkItem.editTextView.delegate = self;
        remarkItem.textViewPlaceHolder.text = @"填写预约须知或联系方式，以便用户了解更多信息";
        remarkItem.textViewPlaceHolder.top = 10;
        remarkItem.titleLabel.height = 44;
        remarkItem.textViewPlaceHolder.hidden = NO;
        remarkItem.editTextView.top = 5;
        remarkItem.textViewPlaceHolder.left+=2;
        remarkItem.hidden = YES;
        [self.view addSubview:remarkItem];
        
        
        UserHomeBtn *addRemarkBtn = [UserHomeBtn buttonWithFrame:CGRectMake(0, threeLabel.bottom+20, SCREENWIDTH, 40) text:@"添加备注信息" imageName:@"icon_order_add.png"];
        [addRemarkBtn setBackgroundImage:[UIUtils imageFromColor:VIEWBACKGROUNDCOLOR] forState:UIControlStateNormal];
        addRemarkBtn.desIamgeView.frame= CGRectMake(SCREENWIDTH/2-60, 10, 20, 20);
        addRemarkBtn.desIamgeView.backgroundColor = [UIColor clearColor];
        addRemarkBtn.nameLabel.frame = CGRectMake(SCREENWIDTH/2-30, 0, 100, 40);
        addRemarkBtn.nameLabel.backgroundColor = [UIColor clearColor];
        [addRemarkBtn addTarget:self action:@selector(addFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addRemarkBtn];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addRemarkBtnEditChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }else{
        self.title = @"微信收款";
        djItem.editTextField.frame =  CGRectMake(50, 0, SCREENWIDTH-60, 44);
    }
   
}

- (void)addFunction:(UserHomeBtn *)sender
{
    remarkItem.hidden = NO;
    if (sender) {
        [sender removeFromSuperview];
    }
}


#pragma mark ------------------------------ 下一步-------------------------------------
- (void)rightNavigationBarAction:(UIButton *)sender
{
    [djItem.editTextField resignFirstResponder];
    [remarkItem.editTextView resignFirstResponder];
    [self.view endEditing:YES];
    
    if (_isInvitation) {
        [LoadingView show:@"请稍后..."];
        
        NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithCapacity:4];
        if ([NSObject nulldata:djItem.editTextField.text]) {
            [parm setObject:djItem.editTextField.text forKey:@"deposit"];
        }else{
            [parm setObject:@0 forKey:@"deposit"];
        }
        if ([NSObject nulldata:remarkItem.editTextView.text ]) {
            [parm setObject:remarkItem.editTextView.text forKey:@"remark"];
        }
        [parm setObject:@(11) forKey:@"orderFrom"];
        [parm setObject:@(10) forKey:@"servicePlace"];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [[JWNetClient defaultJWNetClient]putNetClient:@"Order/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if (!self)return;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else{
                if (responObject) {
                    NSDictionary *orderDict = [[responObject objectForKey:@"data"]objectForKey:@"orderInfo"];
                    if (orderDict) {
                        NSString *orderID = orderDict[@"_id"];
                        if (orderID) {
                            [self sendOrderInvitation:orderID];
                            return;
                        }
                    }
                }
                [SVProgressHUD showErrorWithStatus:@"邀约失败"];
            }
            
        }];
   
    }else{
        BOOL isNeedMoney = YES;
        if ([NSObject nulldata:djItem.editTextField.text]) {
            int money  = [djItem.editTextField.text integerValue];
            if (money >0) {
                isNeedMoney = NO;
            }
        }
        if (isNeedMoney) {
            [SVProgressHUD showErrorWithStatus:@"收款金额必须大于零"];
            return;
        }
        self.navigationItem.rightBarButtonItem.enabled= NO;
        [LoadingView show:@"请稍后..."];
        [[JWNetClient defaultJWNetClient]putNetClient:@"Bill/info" requestParm:@{@"amount":djItem.editTextField.text?djItem.editTextField.text:@"1"} result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if (self == NULL) return ;
            self.navigationItem.rightBarButtonItem.enabled= YES;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else {
                SharedItem *shareItem = [[SharedItem alloc] init];
                NSString *  title = [NSMutableString stringWithFormat:@"[%@]向您发起收款",[User defaultUser].item.nickname];
                shareItem.title = title;
                shareItem.content = [NSString stringWithFormat:@"[%@]正在向您收取纹身相关服务费%@元",[User defaultUser].item.nickname,djItem.editTextField.text?djItem.editTextField.text:@"1"];
                NSString *storeID = [NSString stringWithFormat:@"%@",[User defaultUser].storeItem.storeId];
                NSString *billID = [NSString stringWithFormat:@"%@",responObject[@"data"]?responObject[@"data"][@"billId"]:@"10010"];
                shareItem.sharedURL = API_ORDER_RECEIVE(storeID, billID);
                UIImage *headImg = [UIImage imageNamed:@"icon_userHead_default.png"];
                if (_headI.image) {
                    headImg = _headI.image;
                }
                shareItem.shareImg = headImg;
        
                OrderWxRMViewController *createdSucessVC = [[OrderWxRMViewController alloc]init];
                createdSucessVC.oneItem = shareItem;
                [self.navigationController pushViewController:createdSucessVC animated:YES];
            }
        }];
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >=4 && ![string isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

#pragma mark -------------------------  发送邀约单
- (void)sendOrderInvitation:(NSString *)orderID
{
    SharedItem *shareItem = [[SharedItem alloc] init];
    NSString *  title = [NSMutableString stringWithFormat:@"%@向您发起邀约",[User defaultUser].item.nickname];
    shareItem.title = title;
    shareItem.content = @"亲，为了更好的为您服务，简单补充一下您的预约信息吧！";
    NSString *urlStr =  API_SHAREURL_ORDER([User defaultUser].storeItem.storeId,orderID);
    shareItem.sharedURL = urlStr;
    UIImage *headImg = [UIImage imageNamed:@"icon_userHead_default.png"];
    if (_headI.image) {
        headImg = _headI.image;
    }
    shareItem.shareImg = headImg;

//    JWShareView *shareView = [[JWShareView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) withShareTypes:@[@(JWShareViewTypewx)] dataItem:shareItem UIViewController:self];
//    shareView.block = ^(){
//        [self backAction];
//    };
//    [shareView show];
    
    OrderWxRMViewController *createdSucessVC = [[OrderWxRMViewController alloc]init];
    createdSucessVC.oneItem = shareItem;
    createdSucessVC.isWXYY = YES;
    [self.navigationController pushViewController:createdSucessVC animated:YES];

}


- (void)addRemarkBtnEditChanged:(NSNotification *)notification
{
    if ([NSObject nulldata:remarkItem.editTextView.text]) {
        remarkItem.textViewPlaceHolder.hidden = YES;
    }else{
        remarkItem.textViewPlaceHolder.hidden = NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
