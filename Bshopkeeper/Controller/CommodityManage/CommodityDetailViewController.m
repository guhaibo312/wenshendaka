//
//  CommodityDetailViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CommodityDetailViewController.h"
#import "ProductAndCommodityInfoView.h"
#import "UIImageView+WebCache.h"
#import "Configurations.h"
#import "CommodityModel.h"
#import "NSString+BG.h"
#import "AddOrEditCommodityViewController.h"

@interface CommodityDetailViewController ()
{
    ProductAndCommodityInfoView *productInfoView;
    UIScrollView *backScrollView;
    
}

@property (nonatomic,strong) CommodityModel *currentModel;

@end

@implementation CommodityDetailViewController

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
    backScrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    backScrollView.backgroundColor = VIEWBACKGROUNDCOLOR;
    [self.view addSubview:backScrollView];
    
    [self layoutSubViewsFrom:_currentModel];
    
    
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productChangedFunction:) name:wgwCommodityChangedNotice object:nil];

}

#pragma mark ------------------------ 服务变动通知----------------------------
- (void)productChangedFunction:(NSNotification *)notication
{
    NSDictionary *parm = notication.object;
    if (parm) {
        _currentModel.des = parm[@"description"];
        _currentModel.title = parm[@"title"];
        _currentModel.images = [NSArray arrayWithArray:parm[@"images"]];
        _currentModel.itag = parm[@"tag"];
        _currentModel.price = [NSString stringWithFormat:@"%@",parm[@"price"]];
        _currentModel.deposit = [parm[@"deposit"]integerValue];
        [self layoutSubViewsFrom:_currentModel];
    }
}


#pragma mark --------------------分享-----------------------------------------
- (void)shareFunction:(id)sender
{
    if (!_currentModel) {
        return;
    }
    
    SharedItem *shareItem = [[SharedItem alloc] init];
    shareItem.title = @"真的很适合你哦，快点约吧！";
    
    NSString *content = _currentModel.title;
    if (_currentModel.price) {
        content = [NSString stringWithFormat:@"%@  ¥%@",content,_currentModel.price];
    }
    shareItem.content = content;
    NSString *urlStr =  API_SHAREURL_COMMODICTY([User defaultUser].storeItem.storeId,_currentModel._id);
    shareItem.sharedURL = urlStr;
    UIImage *shareImg = [UIImage imageNamed:@"icon-60@2x.png"];
    UIImageView *firstImg = (UIImageView *)[backScrollView viewWithTag:36];
    if (firstImg) {
        if (firstImg.image) {
            shareImg = firstImg.image;
        }
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
    
    AddOrEditCommodityViewController *addVC = [[AddOrEditCommodityViewController alloc]initWithQuery:@{@"isAdd":@NO,@"item":_currentModel}];
    [self.navigationController pushViewController:addVC animated:YES];
    
}



- (void)layoutSubViewsFrom:(CommodityModel *)model
{
    
    if (!model||!self) return;
    NSArray *imageArrays = model.images;
    if (!imageArrays || imageArrays.count<1) return;
    
    
    if (backScrollView) {
        [backScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (productInfoView) {
        [productInfoView removeFromSuperview];
        productInfoView = nil;
    }
    
    float currentpoint_y = 0;
    for (int i = 0 ; i< imageArrays.count; i++) {
        
        
        NSString *imgUrls = imageArrays[i];
        CGSize imgsize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
        imgsize = [imgUrls imageUrlSizeWithTheOriginalSize:imgsize];
        
        
        UIImageView *oneImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, currentpoint_y, SCREENWIDTH, imgsize.height)];
        oneImg.backgroundColor = [UIColor whiteColor];
        oneImg.clipsToBounds = YES;
        oneImg.contentMode = UIViewContentModeScaleAspectFill;
        [oneImg sd_setImageWithURL:[NSURL URLWithString:[imgUrls getQiNiuImgWithWidth:SCREENWIDTH*2]]];
        [backScrollView addSubview:oneImg];
        currentpoint_y = oneImg.bottom+10;
        
        if (i==0) {
            oneImg.tag = 36;
            productInfoView = [[ProductAndCommodityInfoView alloc]initWithFrame:CGRectMake(0, currentpoint_y-10, SCREENWIDTH, 200) target:self];
            [productInfoView setValueFrom:_currentModel];
            [backScrollView addSubview:productInfoView];
            currentpoint_y = productInfoView.bottom;
        }

    }
    backScrollView.contentSize = CGSizeMake(SCREENWIDTH, currentpoint_y+10);
}

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
