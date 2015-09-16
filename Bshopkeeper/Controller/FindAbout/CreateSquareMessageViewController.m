//
//  CreateSquareMessageViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/2.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CreateSquareMessageViewController.h"
#import "Configurations.h"
#import "AddImageViews.h"
#import "JWEditView.h"
#import "CommodityTagInfoView.h"
#import "CommodityTagViewController.h"

@interface CreateSquareMessageViewController ()<UITextViewDelegate,AddImageViewsDelegate,SelectedCommodityDelegate>

{
    UITextView *contentTextView;
    UIButton *sendBtn;
    UILabel *placeLabel;
    
    AddImageViews *addImgView;
    JWEditView *tagItem;
    CommodityTagInfoView *squareTag;
    NSString *currentsquareTag;
    UIView *imageBottmView;
    BOOL isFirst;
    
}


@end

@implementation CreateSquareMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIUtils imageFromColor:NAVIGATIONCOLOR] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = VIEWBACKGROUNDCOLOR;
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.backgroundColor = [UIColor clearColor];
    cancleBtn.frame = CGRectMake(0, 0, 40, 40);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(dissmissAction) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:cancleBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.backgroundColor = [UIColor clearColor];
    sendBtn.frame = CGRectMake(0, 0, 40, 40);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(releaseMessage:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *righBarItem = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = righBarItem;
    
    [self theConfigurationView];
}

- (void)theConfigurationView
{
    
    contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 132)];
    contentTextView.textContainerInset = UIEdgeInsetsMake(10, 20, 10, 20);
    contentTextView.backgroundColor = [UIColor whiteColor];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.delegate = self;
    placeLabel = [UILabel labelWithFrame:CGRectMake(24, 0, SCREENWIDTH-40, 50) fontSize:14 fontColor:GRAYTEXTCOLOR text:[NSString stringWithFormat:@"来说点工作相关的吧～\n( 生活、吐槽也可以哦 )"]];
    if ([[User defaultUser].item.sector integerValue] != 30) {
        placeLabel.text = [NSString stringWithFormat:@"来说点纹身相关的吧～\n( 生活、吐槽也可以哦 )"];
    }
    placeLabel.numberOfLines = 0;
    [contentTextView addSubview:placeLabel];
    [self.view addSubview:contentTextView];
    
    addImgView = [[AddImageViews alloc]initWithFrame:CGRectMake(0, contentTextView.bottom, SCREENWIDTH, 100) withDelegate:self listArray:nil controller:self];
    addImgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addImgView];
    
    imageBottmView = [[UIView alloc]initWithFrame:CGRectMake(0, addImgView.bottom, SCREENWIDTH, 10)];
    imageBottmView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageBottmView];
    
    tagItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, imageBottmView.bottom+10, SCREENWIDTH, 44) withTitleLabel:@"标签" type:JWEditLable detailImgName:nil];
    tagItem.hidden = YES;
    [self.view addSubview:tagItem];
    
    //分类
    squareTag = [[CommodityTagInfoView alloc]initWithFrame:CGRectMake(50, 0, SCREENWIDTH-85, 44) withSelectdArray:nil];
    [tagItem addSubview:squareTag];
    UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tagBtn.frame = CGRectMake(SCREENWIDTH -40, 0, 44, 44);
    tagBtn.backgroundColor = [UIColor clearColor];
    [tagBtn addTarget:self action:@selector(clickSquareTagViewAction:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapCommodityTags = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSquareTagViewAction:)];
    UIImageView *point1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-30, 17, 6, 10)];
    point1.userInteractionEnabled = NO;
    point1.image = [UIImage imageNamed:@"icon_right_img.png"];
    [squareTag addGestureRecognizer:tapCommodityTags];
    squareTag.userInteractionEnabled = YES;
    [tagItem addSubview:point1];
    [tagItem addSubview:tagBtn];
    
}

- (void)clickSquareTagViewAction:(UIButton *)sender
{
    NSArray *tempArray = [NSArray array];
    if (currentsquareTag) {
        tempArray = [currentsquareTag componentsSeparatedByString:@"#"];
    }
    CommodityTagViewController *tagVC  = [[CommodityTagViewController alloc]initWithQuery:@{@"item":tempArray,@"square":@(YES)}];
    tagVC.chooseTagDelegate = self;
    [self.navigationController pushViewController:tagVC animated:YES];
}

- (void)dissmissAction
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)releaseMessage:(id)sender
{
    if (![NSObject nulldata:contentTextView.text] && addImgView.imageViewList.count < 1) {
        [SVProgressHUD showErrorWithStatus:@"内容和图片不能为空"];
        return;
    }
    if (addImgView.imageViewList.count >= 1) {
        if (!currentsquareTag) {
            if (!isFirst) {
                [self clickSquareTagViewAction:nil];
                tagItem.hidden = NO;
                isFirst = YES;
            }else{
                [SVProgressHUD showErrorWithStatus:@"标签不能为空"];
            }
            return;
        }
        sendBtn.enabled = NO;
        self.view.userInteractionEnabled = NO;
        
        NSInteger imgCount = addImgView.imageViewList.count;
        NSMutableArray *imageArrays = [NSMutableArray arrayWithCapacity:imgCount];
        for (int i = 0; i< imgCount; i++) {
            UIImageView *tempImg = (UIImageView *)addImgView.imageViewList[i];
            [imageArrays addObject:tempImg.image];
        }

        
        [UploadManager uploadImageList:imageArrays  hasLoggedIn: YES success:^(NSArray *resultList) {
            if (self) {
                [self startRequestwithImgUrl:resultList];
            }
        } failure:^(NSError *error) {
            [LoadingView dismiss];
            if (self) {
                 sendBtn.enabled = YES;
                self.view.userInteractionEnabled = YES;
                [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
            }
            
        }];

    }else{
        [self startRequestwithImgUrl:nil];
    }
    
}

- (void)startRequestwithImgUrl:(NSArray *)urls
{
    sendBtn.enabled = NO;
    self.view.userInteractionEnabled = NO;
    [LoadingView show:@"正在发布..."];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if (urls) {
        
        [dict setObject:urls  forKey:@"image_urls"];
        [dict setObject:currentsquareTag forKey:@"tag"];
    }
    
    if ([NSObject nulldata:contentTextView.text]) {
        [dict setObject:contentTextView.text forKey:@"content"];
        if (!urls) {
            [dict setObject:@(1) forKey:@"type"];
        }else{
            [dict setObject:@(0) forKey:@"type"];
        }
    }else{
        [dict setObject:@(2) forKey:@"type"];
    }
    
    if ([[User defaultUser].item.sector integerValue] != 30) {
        [dict setObject:@(30) forKey:@"sector"];
    }
    
    [[JWNetClient defaultJWNetClient]squarePut:@"/feeds/" requestParm:@{@"feed":[dict JSONRepresentation]} result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!self) return ;
        sendBtn.enabled = YES;
        self.view.userInteractionEnabled = YES;
        if (responObject != NULL && !errmsg) {
            if ([[responObject objectForKey:@"status"] isEqualToString:@"ok"]) {
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                if ([responObject objectForKey:@"data"]) {
                    if (responObject[@"data"][@"feed"]) {
                         [[NSNotificationCenter defaultCenter]postNotificationName:SquareFeedReleaseNotice object:responObject[@"data"][@"feed"]];
                    }
                   
                }
               
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([[User defaultUser].item.sector integerValue] != 30) {
                        HobbyMainViewController *rootVC = (HobbyMainViewController *)[AppDelegate appDelegate].window.rootViewController;
                        if ([rootVC isKindOfClass:[HobbyMainViewController class]]) {
                            [rootVC selectControllerWithTag:1];
                        }
                    }
                }];
                return ;
            }
        }
        [SVProgressHUD showErrorWithStatus:errmsg];
        
    }];

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![NSObject nulldata:textView.text]) {
        if (![text isEqualToString:@""]) {
            placeLabel.hidden = YES;
        }else{
            placeLabel.hidden = NO;
        }
    }else{
        if ([text isEqualToString:@""] && textView.text.length <=1) {
            placeLabel.hidden = NO;
        }else{
            placeLabel.hidden = YES;
        }
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    if ([NSObject nulldata:textView.text]) {
        placeLabel.hidden = YES;
    }else{
        placeLabel.hidden = NO;
    }
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([NSObject nulldata:textView.text]) {
        placeLabel.hidden = YES;
    }else{
        placeLabel.hidden = NO;
    }

}

- (void) onImageViewFrameChaned
{
    imageBottmView.top = addImgView.bottom;
    tagItem.top = imageBottmView.bottom+10;
    if (addImgView.imageViewList.count>=1) {
        
        tagItem.hidden = NO;
    }else{
        tagItem.hidden = YES;
    }
}


- (void)theLabelIsCompleteFromArray:(NSArray *)selectedArray
{
    if (!selectedArray)return;
    NSArray *array = [NSArray arrayWithArray:selectedArray];
    if (selectedArray.count >=1) {
        currentsquareTag = [array componentsJoinedByString:@"#"];
    }else{
        currentsquareTag = nil;
    }
    [squareTag createdSubViewsFromeArray:array];
}

- (void)dealloc
{
    addImgView = nil;
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
