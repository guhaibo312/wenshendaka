//
//  Finelist.m
//  Bshopkeeper
//
//  Created by jinwei on 15/5/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "Finelist.h"
#import "JWCollectionViewCell.h"
#import "JWPreviewPhotoController.h"
#import "JWRefresh.h"
#import "JWSquarePhotoViewController.h"
#import "WaterFallHeader.h"
#import "ImageFeedInfoDetailViewController.h"
#import "MobClick.h"
#import "JWEvent.h"

@interface Finelist ()<JWWaterLayoutDelegate,UICollectionViewDataSource>
{
  
    BOOL _isRefresh;
    NSArray *loadBackImgColor;
    BOOL _isNothingMore;
    
    NSString *currentUpdated;
    
}
@property (nonatomic, strong) NSMutableArray *dataListArray;
@property (nonatomic, strong) UIImageView *currentImg;
@property (nonatomic,  strong) NSMutableDictionary *parm;

@end


@implementation Finelist

- (void)clearMemoryCache
{
    _listCollection.delegate = nil;
    _listCollection.dataSource = nil;
    _listCollection = nil;
    _dataListArray = nil;
    _parm = nil;
    _superVc = nil;
}

- (instancetype)initWithFrame:(CGRect)frame ownerController:(UIViewController *)viewcontroller supView:(UIView *)supView
{
    self = [super init];
    if (self) {
        [JWEvent defaultJWEvent].hobbyGalleryTimesOfOnce = 0;
        [JWEvent defaultJWEvent].tattooGalleryTimesOfOnce = 0;
        loadBackImgColor = [NSArray arrayWithObjects:@(0x8c946b),@(0xf2e6bc),@(0xa56452),@(0xc2c2c2),@(0x837467),@(0xe5bbbc),@(0xcbb7a6),@(0xbddecd),@(0xffffff),@(0x000f05),@(0x637b7b),@(0x7c201f), nil];
        _superVc = viewcontroller;
        _dataListArray = [[NSMutableArray alloc]init];
        layout = [[JWWaterLayout alloc]init];
        
        _parm = [[NSMutableDictionary alloc]init];
        [_parm setObject:@(20) forKey:@"limit"];
        
        _listCollection = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
        [_listCollection registerClass:[WaterFallHeader class]  forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"WaterFallSectionHeader"];

        [_listCollection registerClass:[JWCollectionViewCell class] forCellWithReuseIdentifier:@"squareListcell"];
        _listCollection.dataSource = self;
        _listCollection.delegate = self;
        _listCollection.backgroundColor = VIEWBACKGROUNDCOLOR;
        [supView addSubview:_listCollection];
        currentUpdated = nil;
    
    }
    return self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"squareListcell";
    JWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    JWCollectionItem *item = _dataListArray[indexPath.row];
    int color = [[loadBackImgColor objectAtIndex:indexPath.row%12] intValue];
    if (item) {
        [cell setDataItem:_dataListArray[indexPath.row] withColor:RGBCOLOR_HEX(color)];
    }
    return cell;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JWCollectionItem *item = [_dataListArray objectAtIndex:indexPath.row];

    return item.squareListSize;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[User defaultUser].item.sector integerValue] == 30) {
        [JWEvent defaultJWEvent].tattooGalleryTimesOfOnce++;
    }else{
        [JWEvent defaultJWEvent].hobbyGalleryTimesOfOnce++;
    }

    if ([collectionView isHeaderRefreshing] || [collectionView isFooterRefreshing])return;
    JWCollectionItem *item = (JWCollectionItem *)[_dataListArray objectAtIndex:indexPath.row];
    
    if (!item._id || !_superVc) {
        return;
    }
    ImageFeedInfoDetailViewController *detailVC = [[ImageFeedInfoDetailViewController alloc]initWithQuery:@{@"feedId":item._id,@"iscircle":@(YES)}];
    [_superVc.navigationController pushViewController:detailVC animated:YES];
    
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    if (_headView) {
       return  _headView.height;
    }
    return 0;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;

    if ([kind isEqualToString:WaterFallSectionHeader] && _headView)
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind                                                          withReuseIdentifier:@"WaterFallSectionHeader" forIndexPath:indexPath];
        WaterFallHeader* header = [[WaterFallHeader alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, _headView.height) withSubView:_headView];
        [reusableView addSubview:header];
        return reusableView;
    }
    return nil;
}


- (void)setupRefresh
{
    __unsafe_unretained typeof(self) vc = self;
     //添加下拉刷新头部控件
    [_listCollection addHeaderWithCallback:^{
        if (vc) {
            [vc headerRereshing];
        }
    }];
    
    [_listCollection addFooterWithCallback:^{
        if (vc) {
            [vc footerRereshing];
        }
    }];
    
    [vc headerRereshing];

    
}
- (void)headerRereshing
{
    [LoadingView show:@"刷新中..."];
    _isRefresh = YES;
    if (_parm) {
        [_parm removeAllObjects];
        [_parm setObject:@(20) forKey:@"limit"];
    }
    if (_sector) {
        [_parm setObject:@(30) forKey:@"sector"];
    }
    if (_tagStr) {
        [_parm setObject:_tagStr forKey:@"tag"];
    }
    [self requestAction];
    
}

- (void)requestAction
{
    
    __weak __typeof (self)weakSelf = self;
    
    @synchronized(_listCollection) {
        
        [[JWNetClient defaultJWNetClient]squareGet:@"/feeds/recommend/" requestParm:_parm result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if (!weakSelf) return ;
            if (errmsg || !responObject) {
                [SVProgressHUD showErrorWithStatus:errmsg];
                [weakSelf requestFinish:nil];
            }else {
                [weakSelf requestFinish:responObject];
            }
        }];
        return;
    }
    
}


- (void)requestFinish:(NSDictionary *)responObject
{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    if (responObject) {
        NSArray *list = [responObject objectForKey:@"data"];
        if (list.count < 20) {
            _isNothingMore = YES;
        }else{
            _isNothingMore = NO;
        }
        if (list) {
            for (int i = 0; i< list.count; i++) {
                JWCollectionItem *item = [[JWCollectionItem alloc]initWithDictionary:list[i]];
                if (item.image_urls) {
                    if (item.image_urls.count >=1) {
                        [tempArray addObject:item];
                    }
                }
            }
        }
    }
    
    if (_isRefresh) {
        _dataListArray =  [NSMutableArray arrayWithArray:tempArray];
    }else{
        [_dataListArray addObjectsFromArray:tempArray];
    }
    
    
    [_listCollection reloadData];
    [_listCollection headerEndRefreshing];
    [_listCollection footerEndRefreshing];
    
}

- (void)footerRereshing
{
    if (_isNothingMore) {
        [SVProgressHUD showErrorWithStatus:@"已经没有更多数据了！"];
        [_listCollection headerEndRefreshing];
        [_listCollection footerEndRefreshing];
        return;
    }
    [LoadingView show:@"加载中...."];
    _isRefresh = NO;
    JWCollectionItem *item = (JWCollectionItem *)[_dataListArray lastObject];
    if (item) {
        if (item.updated) {
            [_parm setObject:item.updated forKey:@"updated"];
        }
    }
    [self requestAction];
}

- (void)dealloc{
    NSLog(@"图库挂了");
}

@end
