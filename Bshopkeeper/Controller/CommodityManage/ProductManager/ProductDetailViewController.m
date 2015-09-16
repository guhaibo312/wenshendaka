//
//  ProductDetailViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductAndCommodityInfoView.h"
#import "UIImageView+WebCache.h"
#import "Configurations.h"
#import "ProductModel.h"
#import "NSString+BG.h"
#import "AddOrProductViewController.h"

@interface ProductDetailViewController ()<UIWebViewDelegate>
{
//    ProductAndCommodityInfoView *productInfoView;
    UIScrollView *backScrollView;
    UIWebView *productInfoView;
    UIImageView *sharedImageView;
}


@property (nonatomic,strong) ProductModel *currentModel;

@end

@implementation ProductDetailViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _currentModel = query[@"item"];
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"作品详情";
//    backScrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
//    backScrollView.backgroundColor = VIEWBACKGROUNDCOLOR;
//    [self.view addSubview:backScrollView];
//    
//    [self layoutSubViewsFrom:_currentModel];
//
    sharedImageView = [[UIImageView alloc]init];
    if (_currentModel.images) {
        [sharedImageView sd_setImageWithURL:[NSURL URLWithString:[_currentModel.images firstObject]]];
    }

    
    productInfoView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    productInfoView.delegate = self;
    [self.view addSubview:productInfoView];
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [shareBtn setImage:[UIImage imageNamed:@"ion_userpage_share_white.png"] forState:UIControlStateNormal];
    shareBtn.backgroundColor = [UIColor clearColor];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 0);
    [shareBtn addTarget:self action:@selector(shareFunction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [moreBtn setImage:[UIImage imageNamed:@"icon_userpage_edit_white.png"] forState:UIControlStateNormal];
    moreBtn.backgroundColor = [UIColor clearColor];
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 0);
    [moreBtn addTarget:self action:@selector(moreFunction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    self.navigationItem.rightBarButtonItems = @[moreBarButtonItem, shareBarButtonItem];
    
    NSString *url = API_SHAREUR_PRODUCT([User defaultUser].storeItem.storeId, _currentModel?_currentModel._id:@"0");
    [productInfoView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productChangedFunction:) name:wgwProductChangedNotice object:nil];
    
}

#pragma mark ------------------------ 作品变动通知----------------------------
- (void)productChangedFunction:(NSNotification *)notication
{
    NSDictionary *parm = notication.object;
    if (parm) {
//        _currentModel.des = parm[@"description"];
//        _currentModel.title = parm[@"title"];
//        _currentModel.images = [NSArray arrayWithArray:parm[@"images"]];
//        _currentModel.itag = parm[@"tag"];
//        if ([parm.allKeys containsObject:@"share"]) {
//            _currentModel.share = [parm[@"share"]boolValue];
//        }else{
//            _currentModel.share = NO;
//        }
//        [self layoutSubViewsFrom:_currentModel];
        NSString *url = API_SHAREUR_PRODUCT([User defaultUser].storeItem.storeId, _currentModel?_currentModel._id:@"0");
        [productInfoView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

#pragma mark --------------------分享-----------------------------------------
- (void)shareFunction:(id)sender
{
    if (!_currentModel) {
        return;
    }
    
    SharedItem *shareItem = [[SharedItem alloc] init];
    shareItem.title = @"我的最新作品，快来看看吧！";
    shareItem.content = _currentModel.title;
    NSString *urlStr =  API_SHAREUR_PRODUCT([User defaultUser].storeItem.storeId,_currentModel._id);
    shareItem.sharedURL = urlStr;
    UIImage *shareImg = [UIImage imageNamed:@"icon-60@2x.png"];
    
    
    if (sharedImageView.image) {
        shareImg = sharedImageView.image;
    }
    shareItem.shareImg = shareImg;
    JWShareView *shareView = [[JWShareView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) withShareTypes:nil dataItem:shareItem UIViewController:self];
    [shareView show];

}

#pragma mark --------------------  更多---------------------------------------
- (void)moreFunction:(id)sender
{
    if (!_currentModel) {
        return;
    }
    
    AddOrProductViewController *addVC = [[AddOrProductViewController alloc]initWithQuery:@{@"isAdd":@NO,@"item":_currentModel}];
    [self.navigationController pushViewController:addVC animated:YES];
}



//- (void)layoutSubViewsFrom:(ProductModel *)model
//{
//    
//    if (!model||!self) return;
//    NSArray *imageArrays = model.images;
//    if (!imageArrays || imageArrays.count<1) return;
//    
//    
//    if (backScrollView) {
//        [backScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    }
//    if (productInfoView) {
//        [productInfoView removeFromSuperview];
//    }
//   
//    float currentpoint_y = 0;
//    for (int i = 0 ; i< imageArrays.count; i++) {
//        
//        
//        NSString *imgUrls = imageArrays[i];
//        CGSize imgsize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
//        imgsize = [imgUrls imageUrlSizeWithTheOriginalSize:imgsize];
//        UIImageView *oneImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, currentpoint_y, SCREENWIDTH, imgsize.height)];
//        oneImg.backgroundColor = [UIColor whiteColor];
//        oneImg.clipsToBounds = YES;
//        oneImg.contentMode = UIViewContentModeScaleAspectFill;
//        [oneImg sd_setImageWithURL:[NSURL URLWithString:[imgUrls getQiNiuImgWithWidth:SCREENWIDTH*2]]];
//        [backScrollView addSubview:oneImg];
//        currentpoint_y = oneImg.bottom+10;
//        if (i==0) {
//            oneImg.tag = 36;
//            productInfoView = [[ProductAndCommodityInfoView alloc]initWithFrame:CGRectMake(0, currentpoint_y-10, SCREENWIDTH, 200) target:self];
//            [productInfoView setValueFrom:_currentModel];
//            [backScrollView addSubview:productInfoView];
//            currentpoint_y = productInfoView.bottom;
//        }
//
//    }
//    backScrollView.contentSize = CGSizeMake(SCREENWIDTH, currentpoint_y+10);
//}

- (void)backAction
{
    [super backAction];
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
