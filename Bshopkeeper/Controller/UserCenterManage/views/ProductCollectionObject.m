//
//  ProductCollectionObject.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ProductCollectionObject.h"
#import "JWWaterLayout.h"
#import "Configurations.h"
#import "UIImageView+WebCache.h"
#import "NSString+BG.h"
#import "WaterFallHeader.h"
#import "AddCollectionViewCell.h"
#import "AddOrProductViewController.h"
#import "ProductDetailViewController.h"
#import "UIScrollView+JWRefresh.h"
#import "ShopProductModelObject.h"
#import "ShopEditProcductViewController.h"
#import "H5PreviewManageViewController.h"




@interface ProductCollectionObject ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_dataListArray;
    JWWaterLayout *layout;
    NSArray *loadBackImgColor;
}


@end

static NSString  * productIdentifier  = @"productCollectionCell";
static NSString  *firstProductIdentifier = @"firstProductIdentifier";

@implementation ProductCollectionObject


- (instancetype)initWithFrame:(CGRect)frame ownerController:(UIViewController *)vc
{
    self = [super init];
    if (self) {
        
        self.productType = 0;
        self.canEdit = YES;
        loadBackImgColor = [NSArray arrayWithObjects:@(0x8c946b),@(0xf2e6bc),@(0xa56452),@(0xc2c2c2),@(0x837467),@(0xe5bbbc),@(0xcbb7a6),@(0xbddecd),@(0xffffff),@(0x000f05),@(0x637b7b),@(0x7c201f), nil];
        _supController = vc;
        _dataListArray = [[NSMutableArray alloc]init];
        layout = [[JWWaterLayout alloc]init];
        
        _productCollection = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
        [_productCollection registerClass:[ProductCollectionCell class] forCellWithReuseIdentifier:productIdentifier];
        
        [_productCollection registerClass:[AddCollectionViewCell class] forCellWithReuseIdentifier:firstProductIdentifier];
        
        [_productCollection registerClass:[WaterFallHeader class]  forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"WaterFallSectionHeader"];
        _productCollection.dataSource = self;
        _productCollection.delegate = self;
        _productCollection.backgroundColor = VIEWBACKGROUNDCOLOR;
       
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setupRefreshProduct) name:wgwProductChangedNotice object:nil];
        
    }
    
    return self;
   
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.canEdit) {
        return _dataListArray.count+1;
    }
    return _dataListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.canEdit) {
        AddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:firstProductIdentifier forIndexPath:indexPath];
        [cell loadWithTitle:@"添加作品"];
        return cell;
    }else{
        ProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:productIdentifier forIndexPath:indexPath];
        id item ;
        if (self.canEdit) {
             item = _dataListArray[indexPath.row-1];
        }else{
            item = _dataListArray[indexPath.row];
        }
        int color = [[loadBackImgColor objectAtIndex:indexPath.row%12] intValue];
        if (item) {
            [cell setvalueFrom:item withColor:RGBCOLOR_HEX(color)];
        }
        [cell settextColor:TAGBODLECOLOR backColor:TAGSCOLORFORE];
        return cell;
        
    }

   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.canEdit) {
        
        return CGSizeMake(SCREENWIDTH/2, SCREENWIDTH/2);
    }
    if (self.productType == productManageNormal) {
        
        ProductModel *item;
        if (self.canEdit) {
             item = [_dataListArray objectAtIndex:indexPath.row-1];
        }else{
            item = [_dataListArray objectAtIndex:indexPath.row];
        }
        
        return CGSizeMake(SCREENWIDTH/2, item.productCollectionListHeight);
        
    }else{
        ShopProductModelObject *item;
        if (_canEdit) {
             item = [_dataListArray objectAtIndex:indexPath.row-1];
        }else{
            item = [_dataListArray objectAtIndex:indexPath.row];

        }
        return CGSizeMake(SCREENWIDTH/2, item.productCollectionListHeight);
    }
  
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_supController) return;
    
    if (indexPath.row == 0 && _canEdit) {
        
        if (_productType == productManageNormal) {
            AddOrProductViewController *addVC = [[AddOrProductViewController alloc]initWithQuery:@{@"isAdd":@YES}];
            [_supController.navigationController pushViewController:addVC animated:YES];

        }else{
            ShopEditProcductViewController *addVC = [[ShopEditProcductViewController alloc]initWithQuery:@{@"isAdd":@YES,@"companyId":_companyId?_companyId:@""}];
            [_supController.navigationController pushViewController:addVC animated:YES];
        }
    }else{
        
        if (_productType == productManageNormal) {

            ProductModel *item = (ProductModel *)[_dataListArray objectAtIndex:_canEdit?indexPath.row-1:indexPath.row];
            
            ProductDetailViewController *detailViewController = [[ProductDetailViewController alloc]initWithQuery:@{@"item":item}];
            [_supController.navigationController pushViewController:detailViewController animated:YES];
        }else{

            ShopProductModelObject *item = (ShopProductModelObject *)[_dataListArray objectAtIndex:_canEdit? indexPath.row-1 :indexPath.row];

            
            if (_canEdit) {
                ShopEditProcductViewController *detailViewController = [[ShopEditProcductViewController alloc]initWithQuery:@{@"item":item,@"companyId":_companyId?_companyId:@""}];
                [_supController.navigationController pushViewController:detailViewController animated:YES];
            }else{
                H5PreviewManageViewController *hotVC = [[H5PreviewManageViewController alloc]initWithQuery:@{@"urlStr":Shop_Product_detatil(item._id) ,@"title":item.title?item.title:@""}];
                [_supController.navigationController pushViewController:hotVC animated:YES];
            }
        }
       
    }
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    if (_headView) {
        return _headView.height;
    }
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    if (!_headView) {
        return nil;
    }
    
    UICollectionReusableView *reusableView = nil;
    
    reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind                                                          withReuseIdentifier:@"WaterFallSectionHeader" forIndexPath:indexPath];
        WaterFallHeader* header = [[WaterFallHeader alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, _headView.height) withSubView:_headView];
        [reusableView addSubview:header];
    
    return reusableView;
    
}


- (void)setupRefreshProduct
{

    User *currentUser = [User defaultUser];
    if (!currentUser.item.userId) {
        return;
    }
    NSString *requestLastUpTime = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",PRODUCTNAME,currentUser.item.userId]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if (currentUser.storeItem.storeId) {
        [parm setObject:currentUser.storeItem.storeId forKey:@"storeId"];
        [parm setObject:@"true" forKey:@"new"];
        
    }
    if (requestLastUpTime) {
        //存在拉取上次以后的增量
        [parm setObject:requestLastUpTime forKey:@"updateTime"];
    }
   
    __weak __typeof(self) weakself = self;

    [[JWNetClient defaultJWNetClient]getNetClient:@"Product/list" requestParm:parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!weakself) return ;
        if (errmsg) {
            [weakself requestFinished:nil type:YES ];
            
        }else{
            [weakself requestFinished:responObject type:YES];
        }
    }];
}



- (void)requestFinished:(id)result type:(BOOL)isNormar
{
    if (!_supController) return ;
    if (_supController == NULL) return;
    
    User *currentUser = [User defaultUser];
    TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",currentUser.item.userId]];
    //普通作品 和纹身店铺作品
    NSString *tableName;
    if (isNormar) {
        tableName = [NSString stringWithFormat:@"%@%@",PRODUCTNAME,currentUser.item.userId];
    }else{
//        tableName =[NSString stringWithFormat:@"%@%@",ShopProductTableName,currentUser.item.userId];
    }

    NSMutableArray *shopTempArray = [[NSMutableArray alloc]init];
    if (result) {
        NSArray *tempArray = [NSArray arrayWithArray:result[@"data"][@"list"]];
        if (isNormar) {
            if (tempArray.count > 0 ) {
                for (int i = 0 ; i< tempArray.count; i++){
                    NSDictionary *tempD = [tempArray objectAtIndex:i];
                    if ([tempD[@"deletedTime"] compare:[NSNumber numberWithInt:1]]  == NSOrderedDescending) {
                        [operationDB delegateObjectFromeTable:tempD[@"_id"]fromeTable:tableName];
                    }else{
                        //判断数据库有数据就更新 没有就添加
                        id model;
//                        if (isNormar) {
                            model = [[ProductModel alloc]initWithDictionary:tempD];
//                        }else{
//                            model = [[ShopProductModelObject alloc]initWithDictionary:tempD];
//                        }
                        
                        if ([operationDB theTableIsHavetheData:[model valueForKeyPath:@"_id"] fromeTable:tableName]) {
                            [operationDB upDataObjectInfo:model fromTable:tableName];
                        }else{
                            [operationDB insertObjectObject:model fromeTable:tableName];
                        }
                    }
                    if (i == tempArray.count-1) {
                        NSString *upDataTime = tempD[@"updateTime"];
                        if (upDataTime) {
                            // 存储拉取新的时间
                            [[NSUserDefaults standardUserDefaults] setObject:upDataTime forKey:tableName];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            
                        }
                    }
                }
            }
            
            
        }else{
            for ( int i = 0; i< tempArray.count; i++) {
                NSDictionary *oneDict = tempArray[i];
                if ([[oneDict objectForKey:@"deletedTime"]compare:[NSNumber numberWithInt:1]] == NSOrderedAscending) {
                    ShopProductModelObject *object = [[ShopProductModelObject alloc]initWithDictionary:tempArray[i]];
                    [object judgeProductHeight];
                    [shopTempArray addObject:object];
                }
            }
        }
    }
    
    
    
    NSArray *searchList;
    if (isNormar) {
       searchList  =  [operationDB findAllFromType:5 fromeTable:tableName];
    }else{
        searchList = shopTempArray;
    }
    
    if (searchList) {
        _dataListArray = [NSMutableArray arrayWithArray:searchList];
    }
    [_productCollection reloadData];
}

#pragma mark --- 获取商户作品列表
- (void)getShopListProduct:(NSString *)companyId
{
    
    self.companyId = companyId;
    
//    User *currentUser = [User defaultUser];
//    if (!currentUser.item.userId) {
//        return;
//    }
//    NSString *requestLastUpTime = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",ShopProductTableName,currentUser.item.userId]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
//
//    
//    if (requestLastUpTime) {
//        //存在拉取上次以后的增量
//        [parm setObject:requestLastUpTime forKey:@"updateTime"];
//    }else {
        [parm setObject:@"ture" forKey:@"new"];
//    }
    [parm setObject:companyId forKey:@"companyId"];
    

    __weak __typeof (self) weakSelf = self;
    
    [[JWNetClient defaultJWNetClient]getNetClient:@"CompanyProduct/list" requestParm:parm result:^(id responObject, NSString *errmsg) {
        if (!weakSelf) return ;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
            [weakSelf requestFinished:nil type:NO];
        }else{
            [weakSelf requestFinished:responObject type:NO];
        }
    }];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _supController = NULL;
    _productCollection = nil;
    if (_productCollection) {
        [_productCollection removeFromSuperview];
        _productCollection = nil;
    }
    
}



@end

@implementation ProductCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    bigImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bigImageView.layer.masksToBounds = YES;
    bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    bigImageView.clipsToBounds = YES;
    bigImageView.backgroundColor = [UIColor whiteColor];
    
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    [self addSubview:bigImageView];
    
    productTitleLabel = [UILabel labelWithFrame:CGRectZero fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
    productTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:productTitleLabel];
    
    countLabel = [UILabel labelWithFrame:CGRectZero fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
    countLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:countLabel];
}

- (void)settextColor:(UIColor *)color backColor:(UIColor *)bColor
{
    productTitleLabel.textColor = color;
    countLabel.textColor = color;
    self.layer.backgroundColor = bColor.CGColor;

}

- (void)setvalueFrom:(id)sourcemodel withColor:(UIColor *)color
{
    if (sourcemodel) {
        if (_dataModel) {
            if (_dataModel == sourcemodel ) {
                return;
            }
        }
        
        
        _dataModel = sourcemodel;
        
        bigImageView.frame = CGRectMake(0, 0,SCREENWIDTH/2-12,[[sourcemodel valueForKeyPath:@"productCollectionListHeight"]floatValue]-26);
        NSString *imgUrl = [[sourcemodel valueForKeyPath:@"images"] firstObject];
        if (imgUrl) {
            [bigImageView sd_setImageWithURL:[NSURL URLWithString:[imgUrl getQiNiuThunbImage]] placeholderImage:[UIUtils imageFromColor:color?color:[UIColor grayColor]]];
        }
        productTitleLabel.frame = CGRectMake(8, bigImageView.bottom, SCREENWIDTH/2-70, 25);
        productTitleLabel.text = [sourcemodel valueForKeyPath:@"title"];
        countLabel.frame = CGRectMake(SCREENWIDTH/2-12-50, bigImageView.bottom, 40, 25);
        countLabel.text = [NSString stringWithFormat:@"%d张",(int)[[sourcemodel valueForKeyPath:@"images"]count]];
    }
}

@end

