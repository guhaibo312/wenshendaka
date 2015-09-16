//
//  AddOrEditCommodityViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "AddOrEditCommodityViewController.h"
#import "CommodityModel.h"
#import "Configurations.h"
#import "AddImageViews.h"
#import "UIImageView+WebCache.h"
#import "JWPreviewPhotoController.h"
#import "CommodityTagViewController.h"
#import "CommodityTagInfoView.h"
#import "JWEditView.h"
#import "JWPriceTypeButton.h"
#import "UserPageViewController.h"

@interface AddOrEditCommodityViewController ()<UITextFieldDelegate,AddImageViewsDelegate,UIActionSheetDelegate,UITextViewDelegate,SelectedCommodityDelegate,UIAlertViewDelegate>
{
    NSArray *nuitTypeS;                         //单位数
    NSMutableArray *prictTypeButtons;           //价格单位数组
    
    AddImageViews *addimageViews;               //添加图片的按钮
    FilledColorButton *completeBtn;             //完成按钮
    FilledColorButton *deleteBtn;               //删除按钮
    FilledColorButton *upDownBtn;               //上下架按钮
    
    CommodityTagInfoView *commodityTags;        //标签数据
    
    NSMutableArray *imageArrays;                //图片url数组
    NSMutableDictionary *parm;                  //请求参数
    
    
    UIScrollView *backScrollView;               //滑动的层
    UIView *imageBottomView;                    //图片下面的层
    int curentNuit;                             //当前的单位
    NSString *currentCommodityTag;              //当前标签
//    UISwitch *recomSwitch;                      //推荐的开关
    
    JWEditView *nameItem;                       //名称
    JWEditView *priceTypeItem;                  //价格类型
    JWEditView *priceItem;                      //价格数量
    JWEditView *desItem;                        //服务描述
    JWEditView *tagItem;                        //标签
//    JWEditView *djItem;                         //定金
//    JWEditView *recomItem;                      //推荐
    
    
    
}
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, strong) CommodityModel *comModel;
@end

@implementation AddOrEditCommodityViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _isAdd = [query[@"isAdd"]boolValue];
            _comModel = query[@"item"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *rightBarTitle = @"";
    if (_isAdd) {
        self.title = @"添加服务";
        rightBarTitle = @"完成";
    }else{
        self.title = @"修改服务";
        rightBarTitle = @"保存";
    }
    
    [self setRightNavigationBarTitle:rightBarTitle color:[UIColor whiteColor] fontSize:14 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
    
    
    
    imageArrays = [[NSMutableArray alloc]init];
    parm = [[NSMutableDictionary alloc]init];
    [self initWithSubViews];
}
#pragma mark --------------------- 点击完成／保存
- (void)rightNavigationBarAction:(UIButton *)sender
{
    [self clickCompleteBtnAction:nil];
    
}
#pragma mark --------------------- 初始化页面

- (void)initWithSubViews
{
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    backScrollView.backgroundColor = [UIColor whiteColor];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backScrollView];
    
    NSMutableArray *imageArr = [NSMutableArray array];
    if (_comModel) {
        [imageArr addObjectsFromArray: _comModel.images];
    }
    
    UILabel *topPromptLabel = [UILabel labelWithFrame:CGRectMake(10, 6, SCREENWIDTH- 20, 20) fontSize:14 fontColor:GRAYTEXTCOLOR text:@"样例图片"];
    [backScrollView addSubview:topPromptLabel];
    
    addimageViews = [[AddImageViews alloc]initWithFrame:CGRectMake(0, topPromptLabel.bottom, SCREENWIDTH, 50) withDelegate:self listArray:imageArr controller:self];
    [backScrollView addSubview:addimageViews];
    
    
    imageBottomView  = [[UIView alloc]initWithFrame:CGRectMake(0, addimageViews.bottom, SCREENWIDTH, 500)];
    imageBottomView.backgroundColor = [UIColor whiteColor];
    [backScrollView addSubview:imageBottomView];
    
  
    UIView *topBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    topBackView.backgroundColor = VIEWBACKGROUNDCOLOR;
    [imageBottomView addSubview:topBackView];

    
    //名称
    nameItem = [[JWEditView alloc]initWithFrame:CGRectMake(0,topBackView.bottom, SCREENWIDTH, 44) withTitleLabel:@"服务名称" type:JWEditTextField detailImgName:nil];
    nameItem.editTextField.placeholder = @"无";
    nameItem.editTextField.delegate = self;
    [imageBottomView addSubview:nameItem];
    
    //价格类型
    prictTypeButtons = [NSMutableArray array];
    priceTypeItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, nameItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"价格类型" type:JWEditLable detailImgName:nil];
    NSString * sector = [User defaultUser].item.sector;
    if ([sector integerValue] == 40) {
        nuitTypeS = @[@"元",@"每套",@"每天",@"每次",@"每张"];

    }else{
        nuitTypeS = @[@"元",@"每套"];
    }
    float pricetypeButtonWidth = (SCREENWIDTH-100)/nuitTypeS.count;
    for (int i = 0 ; i< nuitTypeS.count; i++) {
        JWPriceTypeButton  *button = [[JWPriceTypeButton alloc]initWithFrame:CGRectMake(i*pricetypeButtonWidth+100, 0,pricetypeButtonWidth, 43.5) title:nuitTypeS[i] font:14 selectedbackgroundColor:SEGMENTSELECT];
        [button addTarget:self action:@selector(chooseThePriceType:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [priceTypeItem addSubview:button];
        [prictTypeButtons addObject:button];
    }
    [imageBottomView addSubview:priceTypeItem];
    
    //价格
    priceItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, priceTypeItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"价格" type:JWEditTextField detailImgName:nil];
    priceItem.editTextField.delegate = self;
    priceItem.editTextField.keyboardType = UIKeyboardTypeNumberPad;
    priceItem.editTextField.placeholder = @"无";
    [imageBottomView addSubview:priceItem];
    
    
    //价格包含项
    desItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, priceItem.bottom, SCREENWIDTH, 80) withTitleLabel:@"价格包含项" type:JWEditTextView detailImgName:nil];
    desItem.titleLabel.height = 50;
    desItem.titleLabel.width+=20;
    desItem.editTextView.delegate = self;
    desItem.textViewPlaceHolder.text = @"报价所包含详细服务项目";
    desItem.textViewPlaceHolder.hidden = NO;
    [imageBottomView addSubview:desItem];
    
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, desItem.bottom, SCREENWIDTH, 10)];
    middleView.backgroundColor = VIEWBACKGROUNDCOLOR;
    [imageBottomView addSubview:middleView];
    
    
//    djItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, middleView.bottom, SCREENWIDTH, 44) withTitleLabel:@"定金( ¥ )" type:JWEditTextField detailImgName:nil];
//    djItem.editTextField.delegate = self;
//    djItem.editTextField.placeholder = @"0表示不收取定金";
//    djItem.editTextField.keyboardType = UIKeyboardTypeNumberPad;
//    [imageBottomView addSubview:djItem];
//    
//    UIView *middleView2 = [[UIView alloc]initWithFrame:CGRectMake(0, djItem.bottom, SCREENWIDTH, 30)];
//    middleView2.backgroundColor = VIEWBACKGROUNDCOLOR;
//    [imageBottomView addSubview:middleView2];
//    
//    TTTAttributedLabel *threeLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(30, djItem.bottom, SCREENWIDTH-60 , 30)];
//    NSMutableDictionary *mutableLinkAttributes3 = [NSMutableDictionary dictionary];
//    [mutableLinkAttributes3 setValue:(id)[[UIColor redColor] CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
//    [mutableLinkAttributes3 setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
//    threeLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes3];
//    threeLabel.font = [UIFont systemFontOfSize:12];
//    threeLabel.text = @"提示: 建议金额不用设置太高，提高成单率。";
//    [threeLabel addLinkToPhoneNumber:@"提示" withRange:[threeLabel.text rangeOfString:@"提示"]];
//    [imageBottomView addSubview:threeLabel];

    
    //标签
    tagItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, middleView.bottom, SCREENWIDTH, 44) withTitleLabel:@"标签" type:JWEditLable detailImgName:nil];
    [imageBottomView addSubview:tagItem];
    
    commodityTags = [[CommodityTagInfoView alloc]initWithFrame:CGRectMake(50, 0, SCREENWIDTH-85, 44) withSelectdArray:nil];
    [tagItem addSubview:commodityTags];
    UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tagBtn.frame = CGRectMake(SCREENWIDTH- 40, 0, 40, 44);
    tagBtn.backgroundColor = [UIColor clearColor];
    [tagBtn addTarget:self action:@selector(clickTagBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapCommodityTags = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTagBtnAction)];
    commodityTags.userInteractionEnabled = YES;
    UIImageView *point1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-25,44/2-5, 6, 10)];
    point1.image = [UIImage imageNamed:@"icon_right_img.png"];
    [commodityTags addGestureRecognizer:tapCommodityTags];
    commodityTags.userInteractionEnabled = YES;
    [tagItem addSubview:point1];
    [tagItem addSubview:tagBtn];
    
    
    //推荐
//    recomItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, tagItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"推荐" type:JWEditLable detailImgName:nil];
//    [imageBottomView addSubview:recomItem];
//    
//    recomSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREENWIDTH-70, 6, 60, 30)];
//    recomSwitch.tintColor = LINECOLOR;
//    recomSwitch.onTintColor = TABSELECTEDCOLOR;
//    [recomItem addSubview:recomSwitch];
    
    
    
    
    if (!_isAdd) {
        
        upDownBtn = [[FilledColorButton alloc]initWithFrame:CGRectMake(20, tagItem.bottom+40, SCREENWIDTH/2-40, 44) color:[UIColor whiteColor] borderColor:SEGMENTSELECT textClolr:[UIColor blackColor] title:@"下架" fontSize:16 isBold:NO];
        upDownBtn.layer.borderWidth = 1;
        [upDownBtn addTarget:self action:@selector(upDownCommodityAction:) forControlEvents:UIControlEventTouchUpInside];
        upDownBtn.layer.borderColor = DeleteLayerBoderColor.CGColor;
        upDownBtn.layer.cornerRadius = 0;
        [imageBottomView addSubview:upDownBtn];
        
        
        
        deleteBtn = [[FilledColorButton alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+20, tagItem.bottom+40, SCREENWIDTH/2-40, 44) color:[UIColor whiteColor] borderColor:SEGMENTSELECT textClolr:[UIColor blackColor] title:@"删除" fontSize:16 isBold:NO];
        [deleteBtn addTarget:self action:@selector(clickDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.layer.borderWidth = 1;
        deleteBtn.layer.borderColor = DeleteLayerBoderColor.CGColor;
        deleteBtn.layer.cornerRadius = 0;
        [imageBottomView addSubview:deleteBtn];
    }else{
        //保存按钮
        completeBtn = [[FilledColorButton alloc]initWithFrame:CGRectMake(40, tagItem.bottom+40, SCREENWIDTH- 80, 44) color:[UIColor whiteColor] borderColor:TABSELECTEDCOLOR textClolr:[UIColor blackColor] title:@"保存" fontSize:16 isBold:NO];
        [completeBtn addTarget:self action:@selector(clickCompleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        completeBtn.layer.cornerRadius =22;
        completeBtn.layer.borderWidth = 1;
        [imageBottomView addSubview:completeBtn];
    }
    
    if (_comModel) {
        nameItem.editTextField.text = _comModel.title;
        if (_comModel.price) {
            priceItem.editTextField.text =[NSString stringWithFormat:@"%@",_comModel.price];
        }
        if (_comModel.des) {
            desItem.editTextView.text = _comModel.des;
            desItem.textViewPlaceHolder.hidden = YES;
        }
        
        int tag = [_comModel.quantifier intValue];
        curentNuit = tag;
        if (curentNuit < prictTypeButtons.count) {
            JWPriceTypeButton*button = [prictTypeButtons objectAtIndex:curentNuit];
            if (button) {
                button.selected = YES;
            }
        }
        if ([_comModel.show boolValue] == YES) {
            [upDownBtn setTitle:@"下架"];
        }else{
            [upDownBtn setTitle:@"上架"];
        }
//        if (_comModel.deposit) {
//            djItem.editTextField.text = [NSString stringWithFormat:@"%d",_comModel.deposit];
//        }
//        if ([_comModel.top boolValue] == YES) {
//            recomSwitch.on = YES;
//        }
        
        if ([NSObject nulldata:_comModel.itag ]) {
            currentCommodityTag = _comModel.itag;
            NSArray *tempArray = [currentCommodityTag componentsSeparatedByString:@"#"];
            if (tempArray.count> 0) {
                [commodityTags createdSubViewsFromeArray:tempArray];
            }
        }else{
            currentCommodityTag = @"";
        }
    }else{
        curentNuit = 0;
        JWPriceTypeButton *button = [prictTypeButtons firstObject];
        button.selected = YES;
    }
    
    [self onImageViewFrameChaned];
}
#pragma mark ---------------------- 点击完成

- (void)clickCompleteBtnAction:(id)sender
{
    
    [self.view endEditing:YES];
    
    if (addimageViews.imageViewList.count <1 ) {
        [SVProgressHUD showErrorWithStatus:@"最少添加一张服务图片"];
        return;
    }
    if (![NSObject nulldata:nameItem.editTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写服务名称"];
        return;
    }
    if (![NSObject nulldata:desItem.editTextView.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写价格包含项"];
        return;
    }

    if (desItem.editTextView.text.length <20) {
        [SVProgressHUD showErrorWithStatus:@"价格包含项最少20个字符"];
        return;
    }
    
    
    [imageArrays removeAllObjects];
    
    NSInteger imgCount = addimageViews.imageViewList.count;
    NSInteger urlCount = addimageViews.urlList.count;
    for (int i = 0; i< imgCount; i++) {
        if (i+1 > urlCount ) {
            UIImageView *tempImg = (UIImageView *)addimageViews.imageViewList[i];
            [imageArrays addObject:tempImg.image];
        }
    }
   
    [parm removeAllObjects];
    [parm setObject:nameItem.editTextField.text forKey:@"title"];
    [parm setObject:desItem.editTextView.text forKey:@"description"];
    if (priceItem.editTextField.text.length >=1) {
        [parm setObject:priceItem.editTextField.text forKey:@"price"];
    }
//    [parm setObject:@([recomSwitch isOn]) forKey:@"top"];
    if (currentCommodityTag) {
        [parm setObject:currentCommodityTag forKey:@"tag"];
    }
    
//    if ([djItem.editTextField.text isNothing]) {
//        [parm setObject:djItem.editTextField.text forKey:@"deposit"];
//    }else{
//        [parm setObject:@"0" forKey:@"deposit"];
//    }
    [parm setObject:[NSNumber numberWithInt:curentNuit] forKey:@"quantifier"];
    if (completeBtn) {
        completeBtn.enabled = NO;
    }
    
    //添加 修改的区分
    if (_isAdd) {
        User *current = [User defaultUser];
        NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]*1000];
        NSString *_id = [NSString stringWithFormat:@"%@%@",current.item.userId,timeSp];
        [parm setObject:_id forKey:@"_id"];
    }else{
        [parm setObject:_comModel._id forKey:@"_id"];
    }
    NSMutableArray *imageUrls = [NSMutableArray arrayWithArray:addimageViews.urlList];
    if (imageArrays.count > 0) {
        [UploadManager uploadImageList: imageArrays hasLoggedIn: YES success:^(NSArray *resultList) {
            if ([self currentIsTopViewController]) {
                [imageUrls addObjectsFromArray:resultList];
                [self requestAddFromServerWithHaveImgList:imageUrls];
            }
        } failure:^(NSError *error) {
            [LoadingView dismiss];
            if ([self WhetherInMemoryOfChild]) {
                if (completeBtn) completeBtn.enabled = YES;
                self.navigationItem.rightBarButtonItem.enabled = YES;
                [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
            }
        }];
    }else{
        [self requestAddFromServerWithHaveImgList:imageUrls];
    }
    
}

#pragma mark ---------------------- 点击删除
- (void)clickDeleteBtnAction:(FilledColorButton *)sender
{
    
    //判断是保存还是删除
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"确定删除该服务？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    action.tag = 105;
    [action showInView:self.view];
    return;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 105) {
        if (buttonIndex == 0) {
            [self deleteCommodity];
        }
    }
}

- (void) deleteCommodity{
    deleteBtn.enabled = NO;
    [LoadingView show:@"请稍候..."];
    [parm removeAllObjects];
    [parm setObject:_comModel._id forKey:@"_id"];
    
    [[JWNetClient defaultJWNetClient]deleteNetClient:@"Commodity/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if ([self WhetherInMemoryOfChild]) {
            deleteBtn.enabled = YES;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[UserPageViewController class]]) {

                        [[NSNotificationCenter defaultCenter]postNotificationName:wgwCommodityChangedNotice object:nil];
                        [self releaseAll];
                        [self.navigationController popToViewController:controller animated:YES];
                        return ;
                    }
                }
            }
        }
    }];
}

#pragma mark --------------------------- 请求添加服务
- (void)requestAddFromServerWithHaveImgList:(NSArray *)imgList
{
    [LoadingView show:@"请稍候..."];
    
    if (completeBtn) {
        completeBtn.enabled = NO;
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;

    if (imgList.count >0) {
        [parm setObject:imgList forKey:@"images"];
    }
    
    if (_isAdd) {
        [[JWNetClient defaultJWNetClient] putNetClient:@"Commodity/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
           
            [LoadingView dismiss];
            if ([self WhetherInMemoryOfChild]) {
                if (completeBtn) {
                    completeBtn.enabled = YES;
                }
                self.navigationItem.rightBarButtonItem.enabled = YES;
                if (errmsg) {
                    [SVProgressHUD showErrorWithStatus:errmsg];
                }else {
                    [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:wgwCommodityChangedNotice object:nil];
                    [self releaseAll];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
        
    }else{
        
        
        [[JWNetClient defaultJWNetClient] postNetClient:@"Commodity/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if ([self WhetherInMemoryOfChild]) {
                if (completeBtn) {
                    completeBtn.enabled = YES;
                }
                self.navigationItem.rightBarButtonItem.enabled = YES;
                if (errmsg) {
                    [SVProgressHUD showErrorWithStatus:errmsg];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    NSDictionary *respondInfo = [responObject[@"data"]objectForKey:@"commodityInfo"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:wgwCommodityChangedNotice object:respondInfo];
                    [self releaseAll];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
        
    }
    
    
}

#pragma mark ---------------------- 点击添加图片调整位置
- (void) onImageViewFrameChaned
{
    float imageBottomViewHeight = deleteBtn?deleteBtn.bottom+10:completeBtn.bottom+10;
    imageBottomView.frame = CGRectMake(0,addimageViews.bottom+10, SCREENWIDTH, imageBottomViewHeight);
    if (imageBottomView.bottom  >= backScrollView.height) {
        backScrollView.contentSize = CGSizeMake(SCREENWIDTH, imageBottomView.bottom+10);
    }else {
        backScrollView.contentSize = backScrollView.bounds.size;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == nameItem.editTextField && ![string isEqualToString:@""] && textField.text.length >=16) {
        return NO;
    }
    if (textField == priceItem.editTextField && ![string isEqualToString:@""] && textField.text.length >=6) {
        return NO;
    }
//    if (textField == djItem.editTextField && ![string isEqualToString:@""] && textField.text.length >=4) {
//        return NO;
//    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    desItem.textViewPlaceHolder.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length <1) {
        desItem.textViewPlaceHolder.hidden = NO;
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (textView == desItem.editTextView && ![text isEqualToString:@""] && textView.text.length >=600) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -------------------------- 选择价格单位
- (void)chooseThePriceType:(JWPriceTypeButton *)sender
{
    if (curentNuit == sender.tag) {
        return;
    }
    for (JWPriceTypeButton *button in prictTypeButtons) {
        button.selected = NO;
    }
    sender.selected = YES;
    curentNuit = sender.tag;
}

#pragma mark -------------------------- 选择标签

- (void)clickTagBtnAction
{
    NSArray *tempArray = [NSArray array];
    if (currentCommodityTag) {
        tempArray = [currentCommodityTag componentsSeparatedByString:@"#"];
    }
    CommodityTagViewController *tagVC  = [[CommodityTagViewController alloc]initWithQuery:@{@"item":tempArray}];
    tagVC.chooseTagDelegate = self;
    [self.navigationController pushViewController:tagVC animated:YES];

}

#pragma mark ------------------------- 修改标签回调
- (void)theLabelIsCompleteFromArray:(NSArray *)selectedArray
{
    NSArray *array = [NSArray arrayWithArray:selectedArray];
    if (array.count <1) {
        currentCommodityTag = nil;
    }else{
        currentCommodityTag = [array componentsJoinedByString:@"#"];
    }
    [commodityTags createdSubViewsFromeArray:array];

    
}

#pragma mark --------------------------- 上下架管理
- (void)upDownCommodityAction:(FilledColorButton *)sender
{
    [parm removeAllObjects];
    [parm setObject:_comModel._id forKey:@"_id"];
    if ([_comModel.show boolValue]) {
        [parm setObject:@(NO) forKey:@"show"];
        [LoadingView show:@"下架中..."];
    }else{
        [parm setObject:@(YES) forKey:@"show"];
        [LoadingView show:@"上架中..."];
    }
    [self requestAddFromServerWithHaveImgList:nil];
}


- (void)backAction
{
    if (_isAdd) {
        if (addimageViews.imageViewList.count>0 || nameItem.editTextField.text.length >=1 || desItem.editTextView.text.length >=1 || currentCommodityTag|| priceItem.editTextField.text.length >1) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有保存，确定返回吗？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
            alertView.tag = 108;
            [alertView show];
        }else{
            [self releaseAll];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if (addimageViews.imageViewList.count != _comModel.images.count || ![_comModel.title isEqualToString:nameItem.editTextField.text] || ![_comModel.des isEqualToString:desItem.editTextView.text]|| ![_comModel.itag isEqualToString:currentCommodityTag] ||![_comModel.price isEqualToString:priceItem.editTextField.text]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有保存，确定返回吗？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
            alertView.tag = 108;
            [alertView show];
        }else{
            [self releaseAll];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 108) {
        if (buttonIndex == 0) {
            [self releaseAll];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self clickCompleteBtnAction:nil];
        }
    }
}


- (void)dealloc
{
    if (addimageViews) {
        [addimageViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    backScrollView = nil;
    addimageViews = nil;
    commodityTags = nil;
    _comModel = nil;
}

- (void)releaseAll
{
    if (addimageViews) {
        [addimageViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    backScrollView = nil;
    addimageViews = nil;
    _comModel = nil;
    commodityTags = nil;
    if (self) {
        if (self.view.subviews) {
            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    }
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
