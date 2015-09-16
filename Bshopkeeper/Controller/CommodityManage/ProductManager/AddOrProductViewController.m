//
//  AddOrProductViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/30.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "AddOrProductViewController.h"
#import "CommodityTagViewController.h"
#import "Configurations.h"
#import "AddImageViews.h"
#import "ProductModel.h"
#import "UIImageView+WebCache.h"
#import "JWPreviewPhotoController.h"
#import "CommodityTagInfoView.h"
#import "JWEditView.h"
#import "UserPageViewController.h"

@interface AddOrProductViewController ()<UITextFieldDelegate,AddImageViewsDelegate,UIActionSheetDelegate,SelectedCommodityDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    JWEditView *nameItem;                   //作品名称
    JWEditView *tagItem;                    //作品标签表头
    JWEditView *desItem;                    //作品描述
    
    
    UISwitch *circleSwitch;              //分享到圈子
    AddImageViews *addimageViews;           //添加图片的按钮
    
    FilledColorButton *completeBtn;         //完成按钮
    FilledColorButton *deleteBtn;           //删除按钮
    
    NSMutableArray *imageArrays;            //图片url数组
    NSMutableDictionary *parm;              //请求参数
    
    
    UIScrollView *backScrollView;           //滑动的层
    UIView *imageBottomView;                //图片下面的层
    
    CommodityTagInfoView *productTagView ;  //作品标签内容
    NSString *currentProductTag ;           //当前标签
}
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, strong) ProductModel *productModel;

@end

@implementation AddOrProductViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _isAdd = [query[@"isAdd"]boolValue];
            _productModel = query[@"item"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any add itional setup after loading the view.
    NSString *rightBarTitle = @"";
    if (_isAdd) {
        self.title = @"添加作品";
        rightBarTitle = @"保存";
    }else{
        self.title = @"修改作品";
        rightBarTitle = @"保存";
    }
    
    [self setRightNavigationBarTitle:rightBarTitle color:[UIColor whiteColor] fontSize:14 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
    imageArrays = [[NSMutableArray alloc]init];
    parm = [[NSMutableDictionary alloc]init];
    [self initWithSubViews];
}

#pragma mark -------------------- 点击右上角保存／完成
- (void)rightNavigationBarAction:(UIButton *)sender
{
    [self clickCompleteBtnAction:nil];
}

#pragma mark --------------------- 初始化页面

- (void)initWithSubViews
{
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    backScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backScrollView];
    
    NSMutableArray *imageArr = [NSMutableArray array];
    if (_productModel) {
        [imageArr addObjectsFromArray: _productModel.images];
    }
    UILabel *topPromptLabel = [UILabel labelWithFrame:CGRectMake(10, 6, SCREENWIDTH-20, 20) fontSize:14 fontColor:GRAYTEXTCOLOR text:@"多角度展示你的作品，仅限同一款哦～"];
    [backScrollView addSubview:topPromptLabel];
    
    addimageViews = [[AddImageViews alloc]initWithFrame:CGRectMake(0, topPromptLabel.bottom, SCREENWIDTH, 50) withDelegate:self listArray:imageArr controller:self];
    [backScrollView addSubview:addimageViews];
    
    
    imageBottomView  = [[UIView alloc]initWithFrame:CGRectMake(0, addimageViews.bottom+10, SCREENWIDTH, 400)];
    imageBottomView.backgroundColor = [UIColor whiteColor];
    [backScrollView addSubview:imageBottomView];
    
    UIView *middleView  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    middleView.backgroundColor =  VIEWBACKGROUNDCOLOR;
    [imageBottomView addSubview:middleView];
    
    //名称
    nameItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, middleView.bottom, SCREENWIDTH, 44) withTitleLabel:@"作品名称" type:JWEditTextField detailImgName:nil];
    nameItem.editTextField.placeholder = @"无";
    nameItem.editTextField.delegate = self;
    [imageBottomView addSubview:nameItem];
    
    //描述
    desItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, nameItem.bottom, SCREENWIDTH, 88)withTitleLabel:@"作品描述" type:JWEditTextView detailImgName:nil];
    desItem.textViewPlaceHolder.text = @"选填";
    desItem.editTextView.delegate = self;
    desItem.titleLabel.height = 44;
    [imageBottomView addSubview:desItem];
    
    
    UIView *middleView2  =[[UIView alloc]initWithFrame:CGRectMake(0, desItem.bottom, SCREENWIDTH, 10)];
    middleView2.backgroundColor =  VIEWBACKGROUNDCOLOR;
    [imageBottomView addSubview:middleView2];
    
    //标签
    tagItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, middleView2.bottom, SCREENWIDTH, 44) withTitleLabel:@"标签" type:JWEditLable detailImgName:nil];
    [imageBottomView addSubview:tagItem];
    
    
    //分类
    productTagView = [[CommodityTagInfoView alloc]initWithFrame:CGRectMake(50, 0, SCREENWIDTH-85, 44) withSelectdArray:nil];
    [tagItem addSubview:productTagView];
    UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tagBtn.frame = CGRectMake(SCREENWIDTH -40, 2, 40, 40);
    tagBtn.backgroundColor = [UIColor clearColor];
    [tagBtn addTarget:self action:@selector(clickPructTagViewAction) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapCommodityTags = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPructTagViewAction)];
    productTagView.userInteractionEnabled = YES;
    UIImageView *point1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-20, 17, 6, 10)];
    point1.image = [UIImage imageNamed:@"icon_right_img.png"];
    [productTagView addGestureRecognizer:tapCommodityTags];
    productTagView.userInteractionEnabled = YES;
    [tagItem addSubview:point1];
    [tagItem addSubview:tagBtn];

    //分享到圈子
    JWEditView * shareTocircle  = [[JWEditView alloc]initWithFrame:CGRectMake(0, tagItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"分享到圈子" type:JWEditLable detailImgName:nil];
    shareTocircle.titleLabel.width = 120;
    circleSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREENWIDTH-60, 7, 50, 30)];
    circleSwitch.onTintColor = TAGSCOLORTHREE;
    circleSwitch.tintColor = LINECOLOR;
    circleSwitch.on = NO;
    [shareTocircle addSubview:circleSwitch];
    [imageBottomView addSubview:shareTocircle];
    if (_productModel) {
        if (_productModel.share) {
            shareTocircle.hidden = YES;
            shareTocircle.height = 0;
        }
    }
    
    completeBtn = [[FilledColorButton alloc]initWithFrame:CGRectMake(40, shareTocircle.bottom+40, SCREENWIDTH-80, 44) color:[UIColor whiteColor] borderColor:SEGMENTSELECT textClolr:[UIColor blackColor] title:@"保存" fontSize:16 isBold:NO];
    [completeBtn addTarget:self action:@selector(clickBottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    completeBtn.layer.cornerRadius = 22;
    completeBtn.layer.borderWidth = 1;
    [imageBottomView addSubview:completeBtn];
    
    if (!_isAdd) {
       [completeBtn setTitle:@"删除"];
        completeBtn.layer.cornerRadius = 0;
        completeBtn.layer.borderColor = DeleteLayerBoderColor.CGColor;
    }
    
   
    if (_productModel) {
        nameItem.editTextField.text = _productModel.title;
        desItem.editTextView.text = _productModel.des;
        if ([NSObject nulldata:_productModel.itag]) {
            currentProductTag = _productModel.itag;
            NSArray *tempArray = [currentProductTag componentsSeparatedByString:@"#"];
            if (tempArray.count> 0) {
                [productTagView createdSubViewsFromeArray:tempArray];
            }
        }else{
            currentProductTag = @"";
        }
    }else{
        desItem.textViewPlaceHolder.hidden = NO;

    }
    [self onImageViewFrameChaned];
}


#pragma mark -------------------------- 选择标签

- (void)clickPructTagViewAction
{
    NSArray *tempArray = [NSArray array];
    if ([NSObject nulldata:currentProductTag]) {
        tempArray = [currentProductTag componentsSeparatedByString:@"#"];
    }
    CommodityTagViewController *tagVC  = [[CommodityTagViewController alloc]initWithQuery:@{@"item":tempArray}];
    tagVC.chooseTagDelegate = self;
    [self.navigationController pushViewController:tagVC animated:YES];
    
}
#pragma mark ------------------------- 修改标签回调
- (void)theLabelIsCompleteFromArray:(NSArray *)selectedArray
{
    if (selectedArray.count<1) {
        currentProductTag = nil;
        [productTagView createdSubViewsFromeArray:selectedArray];
        return;
    }
    NSArray *array = [NSArray arrayWithArray:selectedArray];
    currentProductTag = [array componentsJoinedByString:@"#"];
    [productTagView createdSubViewsFromeArray:array];
    
}


#pragma mark ---------------------- 删除或者保存
- (void)clickBottomButtonAction:(FilledColorButton *)sender
{
    if (_isAdd) {
        [self clickCompleteBtnAction:nil];
    }else{
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"确定删除该作品？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [action showInView:self.view];
        return;

    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //第一个就删除
    if (buttonIndex == 0) {
        [self deleteCommodity];
    }
}
- (void) deleteCommodity{
    deleteBtn.enabled = NO;
    [LoadingView show:@"请稍候..."];
    [parm removeAllObjects];
    [parm setObject:_productModel._id forKey:@"_id"];
    
    [[JWNetClient defaultJWNetClient]deleteNetClient:@"Product/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!self) return ;
        deleteBtn.enabled = YES;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:wgwProductChangedNotice object:nil];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[UserPageViewController class]]) {
                    [self releaseAll];
                    [self.navigationController popToViewController:controller animated:YES];
                    return;
                }
            }
        }
    }];
}

#pragma mark ---------------------- 点击完成

- (void)clickCompleteBtnAction:(FilledColorButton *)sender
{
    if (nameItem.editTextField.text.length <1) {
        [SVProgressHUD showErrorWithStatus:@"请填写作品名称"];
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
    if (imageArrays.count <1 && addimageViews.urlList.count <1) {
        [SVProgressHUD showErrorWithStatus:@"请添加一张作品图片"];
        return;
    }
    [parm removeAllObjects];
    [parm setObject:nameItem.editTextField.text forKey:@"title"];
    if (desItem.editTextView.text >0) {
        [parm setObject:desItem.editTextView.text forKey:@"description"];
    }
    if (currentProductTag) {
        [parm setObject:currentProductTag forKey:@"tag"];
    }

    completeBtn.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;

    //添加 修改的区分
    if (_isAdd) {
        User *current = [User defaultUser];
        NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]*1000];
        NSString *_id = [NSString stringWithFormat:@"%@%@",current.item.userId,timeSp];
        [parm setObject:_id forKey:@"_id"];
    }else{
        [parm setObject:_productModel._id forKey:@"_id"];
    }
    NSMutableArray *imageUrls = [NSMutableArray arrayWithArray:addimageViews.urlList];
    if (imageArrays.count > 0) {
        [UploadManager uploadImageList: imageArrays hasLoggedIn: YES success:^(NSArray *resultList) {
            if (!self) {
                return ;
            }
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


#pragma mark --------------------------- 请求添加作品
- (void)requestAddFromServerWithHaveImgList:(NSArray *)imgList
{
    [LoadingView show:@"请稍候..."];
    completeBtn.enabled = NO;
    [parm setObject:circleSwitch.isOn?@(1):@(0) forKey:@"share"];
    
    if (imgList.count >0) {
        [parm setObject:imgList forKey:@"images"];
    }
    if (_isAdd) {
        [[JWNetClient defaultJWNetClient]putNetClient:@"Product/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
           
            [LoadingView dismiss];
            if (self == NULL) return ;
            completeBtn.enabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else {
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:wgwProductChangedNotice object:nil];
                [self releaseAll];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }];
        
    }else{
        [[JWNetClient defaultJWNetClient]postNetClient:@"Product/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if (self == NULL) return ;
            completeBtn.enabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else{
                
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                NSDictionary *responInfo = responObject[@"data"][@"productInfo"];
                [[NSNotificationCenter defaultCenter]postNotificationName:wgwProductChangedNotice object:responInfo];
                [self releaseAll];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
    
}



#pragma mark ---------------------- 点击到店还是上门
- (void)selectedTohomeBtnAndGOshopBtnAction:(TitleImageButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark ---------------------- 点击添加图片调整位置
- (void) onImageViewFrameChaned
{
    imageBottomView.frame = CGRectMake(0, addimageViews.bottom+10, SCREENWIDTH,completeBtn.bottom);
    if (imageBottomView.bottom  >= backScrollView.height) {
        backScrollView.contentSize = CGSizeMake(SCREENWIDTH,imageBottomView.bottom+20);
    }else {
        backScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT- 64);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == nameItem.editTextField && ![string isEqualToString:@""] && textField.text.length >=16) {
        return NO;
    }
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
        if (textView == desItem.editTextView && ![text isEqualToString:@""] && textView.text.length >=128) {
            return NO;
        }
    return YES;
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    desItem.textViewPlaceHolder.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length <1) {
        desItem.textViewPlaceHolder.hidden = NO;
    }
}

- (void)backAction
{
    
    if (_isAdd) {
        
        if (addimageViews.imageViewList.count>0 || nameItem.editTextField.text.length >=1 || desItem.editTextView.text.length >=1 || currentProductTag) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有保存，确定返回吗？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
            alertView.tag = 108;
            [alertView show];
        }else{
            [self releaseAll];
            [super backAction];
        }
    }else{
        if (addimageViews.imageViewList.count != _productModel.images.count || ![_productModel.title isEqualToString:nameItem.editTextField.text] || ![_productModel.des isEqualToString:desItem.editTextView.text]|| ![_productModel.itag isEqualToString:currentProductTag] ) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有保存，确定返回吗？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
                alertView.tag = 108;
                [alertView show];
            }else{
                [self releaseAll];
                [super backAction];
            }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 108) {
        if (buttonIndex == 0) {
            [self releaseAll];
            [super backAction];
        }else{
            [self clickCompleteBtnAction:completeBtn];
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
    _productModel = nil;
    productTagView = nil;
}

- (void)releaseAll
{
    if (addimageViews) {
        [addimageViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    backScrollView = nil;
    addimageViews = nil;
    _productModel = nil;
    productTagView = nil;
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
