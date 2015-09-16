//
//  SameCitySearchViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/9/6.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SameCitySearchViewController.h"
#import "SameCityListView.h"
#import "JWTabItemButton.h"
#import "CompanyInfoItem.h"


@interface SameCitySearchViewController ()
{
    UITextField *keywordField;
    
    SameCityListView *tattoolist;
    
    JWTabItemButton *tattooButton;
    JWTabItemButton *storeButton;

    UIImageView *pointImg;
}
@end

@implementation SameCitySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self setRightNavigationBarBackGroundImgName:@"icon_search_img_white.png" frame:CGRectMake(0, 0, 40, 40)];
   
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    textField.backgroundColor = [UIColor whiteColor];
    
    textField.font = [UIFont systemFontOfSize:14];
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
    
    textField.layer.cornerRadius = 5;
    
    keywordField = textField;
    
    self.navigationItem.titleView = textField;
    
    [self layoutSubViews];
}

- (void)layoutSubViews
{
    tattooButton = [[JWTabItemButton  alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH/2, 44) withTitle:@"纹身师" normalTextColor:TAGBODLECOLOR needBottomView:NO];
    tattooButton.backgroundColor = SEGMENTNORMAL;
    tattooButton.selected = YES;
    tattooButton.tag = 90;
    [tattooButton addTarget:self action:@selector(clickTattooOrStoreFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tattooButton];
    
    storeButton = [[JWTabItemButton  alloc]initWithFrame:CGRectMake(SCREENWIDTH/2,0, SCREENWIDTH/2, 44) withTitle:@"店铺" normalTextColor:TAGBODLECOLOR needBottomView:NO];
    storeButton.backgroundColor = SEGMENTNORMAL;
    storeButton.selected = NO;
    [storeButton addTarget:self action:@selector(clickTattooOrStoreFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:storeButton];
    
    
    float listHeight = SCREENHEIGHT-64-44;
    
    tattoolist = [[SameCityListView alloc]initWithFrame:CGRectMake(0, tattooButton.bottom, SCREENWIDTH,listHeight) ownerController:self];
    [self.view addSubview:tattoolist];
    
    pointImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4-47.5, tattooButton.bottom-4, 95, 8)];
    pointImg.image = [UIImage imageNamed:@"icon_order_pointer.png"];
    pointImg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pointImg];

}

#pragma mark ---- 切换( 纹身师 <====> 店铺 )
- (void)clickTattooOrStoreFunction:(JWTabItemButton *)sender
{
    tattooButton.selected = NO;
    storeButton.selected = NO;
    
    int index = 0;
    
    if (sender == storeButton){
        index = 1;
        storeButton.selected = YES;
        pointImg.left = SCREENWIDTH/4*3-47.5;
    }else{
        tattooButton.selected = YES;
        pointImg.left = SCREENWIDTH/4-47.5;
    }
    
}



- (void)rightNavigationBarAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (![NSObject nulldata:keywordField.text]) return;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.view.userInteractionEnabled = YES;
    
    [LoadingView show:@"搜索中..."];
    
    __weak __typeof (self) weakSelf = self;
    //纹身师  店铺
    
    NSString *api;
    NSDictionary *parm;
    if (tattooButton.selected) {
        api = @"User/searchList";
        parm = @{@"nickname":keywordField.text};
    }else{
        api = @"Company/searchList";
        parm = @{@"name":keywordField.text};
    }
    
    [[JWNetClient defaultJWNetClient]getNetClient:api requestParm:parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!weakSelf)return ;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
            [weakSelf requestFinish:nil];
        }else{
            [weakSelf requestFinish:responObject];
        }
        
    }];
        
    
}


- (void)requestFinish:(NSDictionary *)result
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.view.userInteractionEnabled = YES;
    
    if (result) {
        NSArray *resultArray = result[@"data"][@"list"];
        NSMutableArray *tempArray  = [[NSMutableArray alloc]init];
        
        
        
        if (tattooButton.selected ) {
            if (resultArray) {
                for (int i = 0 ; i< resultArray.count; i++) {
                    SameCityListobject *one = [[SameCityListobject alloc]init];
                    one.userInfo = [NSDictionary dictionaryWithDictionary:resultArray[i]];
                    if (one.userInfo) {
                        one.v = [one.userInfo objectForKey:@"v"];
                        one.storeId = [one.userInfo objectForKey:@"userId"];
                        if ([NSObject nulldata:[one.userInfo objectForKey:@"productNum"]]) {
                            one.productNum = [[one.userInfo objectForKey:@"productNum"] integerValue];
                        }
                        if ([NSObject nulldata:[one.userInfo objectForKey:@"hot"]]) {
                            one.hot = [one.userInfo objectForKey:@"hot"];
                        }
                    }
                    
                    [tempArray addObject:one];
                }
            }
            
            if (tattoolist) {
                tattoolist.listArray = [NSMutableArray arrayWithArray:tempArray];
                tattoolist.itemType = SameCityItemTypeTattoo;
                [tattoolist reloadData];
            }
        }else{
            
            if (resultArray) {
                for (int i = 0 ; i< resultArray.count; i++) {
                    CompanyInfoItem *one = [[CompanyInfoItem alloc]initWithParm:resultArray[i]];
                    [tempArray addObject:one];
                }
            }
            if (tattoolist) {
                tattoolist.listArray = [NSMutableArray arrayWithArray:tempArray];
                tattoolist.itemType = SameCityItemTypeShop;
                [tattoolist reloadData];
            }
            
        }
    }
    
}

- (void)dealloc
{
    if (tattoolist) {
        tattoolist.delegate = nil;
        tattoolist.dataSource = nil;
        tattoolist = nil;
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
