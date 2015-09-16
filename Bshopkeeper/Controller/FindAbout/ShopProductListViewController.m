//
//  ShopProductListViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/9/7.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ShopProductListViewController.h"
#import "ProductCollectionObject.h"


@interface ShopProductListViewController ()
{
    ProductCollectionObject *productManage;
}

@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, assign) BOOL canEdit;


@end

@implementation ShopProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"店铺作品";
    
    [self initsubviews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setupRefreshShopProduct) name:shopProductChangedNotice object:nil];
}

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        
        if (query) {
            self.companyId = [NSString stringWithFormat:@"%@",query[@"companyId"]];
            self.canEdit = [query[@"editable"] boolValue];
        }
    }
    
    return self;
}

-(void)initsubviews
{
    productManage = [[ProductCollectionObject alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) ownerController:self];
    productManage.productCollection.backgroundColor = TAGBODLECOLOR;
    productManage.productType = productManageShop;
    productManage.canEdit = self.canEdit;
    [self.view addSubview:productManage.productCollection];
    [productManage getShopListProduct:self.companyId];

}

- (void)setupRefreshShopProduct
{
    if (productManage) {
        [productManage getShopListProduct:_companyId];
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
