//
//  SameCityListView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/13.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SameCityListView.h"
#import "Configurations.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+JWRefresh.h"
#import "SquareUserPageViewController.h"
#import "RealNameAuthenticationViewController.h"
#import "NSString+Extension.h"
#import "CompanyInfoItem.h"
#import "ShopProductListViewController.h"
#import "ShopDetailController.h"


@class SameCityListobject;
@class SameCityListCell;


@interface SameCityListView ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isrefresh;
    BOOL isNothingMore;
}
@property (nonatomic, weak) UIViewController *ownerController;
@property (nonatomic, strong) NSMutableDictionary *parm;

@end

@implementation SameCityListView

- (instancetype)initWithFrame:(CGRect)frame ownerController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemType = SameCityItemTypeTattoo;
        self.listArray = [[NSMutableArray alloc]init];
        _ownerController = controller;
        self.dataSource= self;
        self.delegate = self;
        self.rowHeight = 88;
        UIView *footView = [[UIView alloc]init];
        self.tableFooterView = footView;
        self.separatorInset = UIEdgeInsetsMake(0,0,0,0);
        self.backgroundColor = VIEWBACKGROUNDCOLOR;
    }
    
    return self;
}

#pragma mark  ----------------------- 设置 进入时的刷新状态----------------------------------
- (void)setupRefresh
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    
    [self addFooterWithCallback:^{
        if (vc) {
            [vc footerRereshing];
        }
    }];
    
    [self addHeaderWithCallback:^{
        if (vc) {
            [vc headerRereshing];
        }
    }];
    
    [self headerBeginRefreshing];

}

#pragma mark ----------------------------- 刷新数据 ---------------------------------------------

- (void)headerRereshing
{
    [LoadingView show:@"刷新中..."];
    isrefresh = YES;
    isNothingMore = NO;
    _parm = [[NSMutableDictionary alloc]init];
    [_parm setObject:@"20" forKey:@"limit"];
    [_parm setObject:@"0" forKey:@"index"];

    
    if (self.location) {
        [_parm setObject:self.location forKey:@"location"];
    }else{
        [_parm setObject:[NSString stringWithFormat:@"%@",[User defaultUser].item.city] forKey:@"city"];
        [_parm setObject:[NSString stringWithFormat:@"%@",[User defaultUser].item.province] forKey:@"province"];
    }
    [self requeststoreAction];
    self.userInteractionEnabled = NO;
    

}

- (void)requeststoreAction
{
    __weak __typeof (self) weakself = self;
    
    NSString *apiString = @"User/list";
    if (self.itemType == SameCityItemTypeShop) {
        apiString = @"Company/list";
    }
    if (!_location && self.itemType == SameCityItemTypeTattoo) {
        apiString = @"Store/list";
    }
    
    [[JWNetClient defaultJWNetClient]getNetClient:apiString requestParm:_parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!weakself) return ;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
            [weakself requestFinish:nil];
        }else{
            [weakself requestFinish:responObject];
        }
        
    }];
}

- (void)requestFinish:(NSDictionary *)responObject
{
    
    self.userInteractionEnabled = YES;
    if (responObject) {
        NSArray *resultArray = responObject[@"data"][@"list"];
        NSMutableArray *tempArray  = [[NSMutableArray alloc]init];
        
        if (resultArray) {
            for (int i = 0 ; i< resultArray.count; i++) {
                if (self.itemType == SameCityItemTypeTattoo) {
                    SameCityListobject *one = [[SameCityListobject alloc]initWithDict:resultArray[i]];
                    [tempArray addObject:one];
                }else{
                    CompanyInfoItem *one = [[CompanyInfoItem alloc]initWithParm:resultArray[i]];
                    [tempArray addObject:one];

                }
            }
        }
        if (isrefresh) {
            _listArray = [NSMutableArray arrayWithArray:tempArray];
        }else{
            [_listArray addObjectsFromArray:tempArray];
        }
        if (tempArray.count < 20) {
            isNothingMore = YES;
        }
    }
    [self reloadData];
    [self headerEndRefreshing];
    [self footerEndRefreshing];
    self.userInteractionEnabled = YES;
    
}

#pragma mark ---------------------- 加载数据 ---------------------------------------------
- (void)footerRereshing
{
    if (isNothingMore) {
        [SVProgressHUD showErrorWithStatus:@"已经没有更多数据了！"];
        [self headerEndRefreshing];
        [self footerEndRefreshing];
        return;
    }
    [LoadingView show:@"加载中...."];
    isrefresh = NO;
    [_parm setObject:@(_listArray.count) forKey:@"index"];
    self.userInteractionEnabled = NO;
    [self requeststoreAction];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.sectionView) {
        return self.sectionView.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.sectionView) {
        return self.sectionView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_itemType == SameCityItemTypeTattoo) {
        static NSString *cellidentifier = @"cellidentifier";
        SameCityListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (!cell ) {
            cell = [[SameCityListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier
                    ];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SameCityListobject *one = [_listArray objectAtIndex:indexPath.row];
        [cell refreshFrom:one ];
        return cell;

    }else{
        static NSString *cellidentifier = @"samecellidentifier";
        SameCityStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (!cell ) {
            cell = [[SameCityStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier
                    ];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CompanyInfoItem *one = [_listArray objectAtIndex:indexPath.row];
        [cell refreshFrom:one ];
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_itemType == SameCityItemTypeTattoo) {
        SameCityListobject *one = [_listArray objectAtIndex:indexPath.row];
        if (one.storeId && _ownerController) {
            SquareUserPageViewController *userPageVC = [[SquareUserPageViewController alloc]initWithQuery:@{@"userId":one.storeId}];
            [_ownerController.navigationController pushViewController:userPageVC animated:YES];
        }

    }else{
        CompanyInfoItem *one = [_listArray objectAtIndex:indexPath.row];
        if (one && _ownerController) {
            ShopDetailController *shopVc = [[ShopDetailController alloc] init];
            shopVc.companyInfo = one;
            [_ownerController.navigationController pushViewController:shopVc animated:YES];
        }
    }
}


- (void)dealloc
{
    if (_parm) {
        _parm = nil;
    }
    if (_ownerController) {
        _ownerController = nil;
    }
    if (_listArray) {
        _listArray = NULL;
    }
}

@end


@implementation SameCityListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        nameLabel = [UILabel labelWithFrame:CGRectMake(86, 15,20, 20) fontSize:16 fontColor:SquareLinkColor text:@""];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        
        vSignView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15+4, 13, 12)];
        vSignView.image = [UIImage imageNamed:@"icon_mine_v.png"];
        [self.contentView addSubview:vSignView];
        
            
        
        headView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 66, 66)];
        headView.backgroundColor = [UIColor clearColor];
        headView.clipsToBounds = YES;
        headView.layer.cornerRadius = 33;
        headView.layer.borderColor = SMALLBUTTONCOLOR.CGColor;
        headView.layer.borderWidth = 2;
        [self.contentView addSubview:headView];
        
        desLabel = [UILabel labelWithFrame:CGRectMake(100, 15, SCREENWIDTH/2-100, 20) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        [self.contentView addSubview:desLabel];
        
        productLabel = [UILabel labelWithFrame:CGRectMake(86, 60, SCREENWIDTH-96, 20) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
        [self.contentView addSubview:productLabel];
        
        
        hotLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-150, 88/2, 140 , 20)];
        NSMutableDictionary *mutableLinkAttributes3 = [NSMutableDictionary dictionary];
        [mutableLinkAttributes3 setValue:(id)[SEGMENTSELECT CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
        [mutableLinkAttributes3 setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        hotLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes3];
        hotLabel.font = [UIFont systemFontOfSize:12];
        hotLabel.leading = 10;
        hotLabel.numberOfLines = 0;
        hotLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:hotLabel];
        
        self.contentView.backgroundColor = VIEWBACKGROUNDCOLOR;
        
    }
    return self;
}


- (void)refreshFrom:(SameCityListobject *)object
{
    if(object == NULL)return;
    _dataSource = object;
    headView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
    headView.layer.borderColor = SEGMENTSELECT.CGColor;
    nameLabel.left = 86;
    
    if (object.userInfo){
        NSString *string = object.userInfo[@"nickname"];
        if ([NSObject nulldata:string]) {
            
            float nameWidth = [string sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(1000, 20)].width;
            if (nameWidth >= 80 ) {
                nameWidth = 80;
            }
            nameLabel.width = nameWidth;
            nameLabel.text = string;
        }
        
        
        if ([object.v boolValue]) {
            vSignView.hidden = NO;
            vSignView.left = nameLabel.right+5;
        }else{
            vSignView.hidden = YES;
        }

        NSDictionary *company = object.userInfo[@"company"];
        if ([NSObject nulldata:company]) {
            if ([NSObject nulldata:company[@"name"]]) {
                desLabel.left = vSignView.hidden?nameLabel.right+2:vSignView.right+5;
                desLabel.width = SCREENWIDTH-desLabel.left-10;
                desLabel.text = [NSString stringWithFormat:@"| %@",company[@"name"]];
            }
        }
        
        if ([NSObject nulldata:object.userInfo[@"avatar"]]) {
            [headView sd_setImageWithURL:[NSURL URLWithString:object.userInfo[@"avatar"]]];
        }

    }
    
    
    if (object.hot) {
        NSString *hotString = [NSString stringWithFormat:@"%@ 人气",object.hot];
        hotLabel.text = hotString;
        [hotLabel addLinkToPhoneNumber:[NSString stringWithFormat:@"%@",object.hot] withRange:[hotString rangeOfString:[NSString stringWithFormat:@"%@",object.hot]]];
    }
    
    productLabel.text = [NSString stringWithFormat:@"作品: %d",object.productNum];

    if ([[User defaultUser].item.sector integerValue] != 30) {
        headView.layer.borderColor = SEGMENTSELECT.CGColor;
    }else{
        headView.layer.borderColor = SMALLBUTTONCOLOR.CGColor;
    }
    
}


- (void)prepareForReuse
{
    headView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
    nameLabel.text = nil;
    desLabel.text = nil;
    vSignView.hidden = YES;
    
}
@end






@implementation SameCityStoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        headView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 48, 48)];
        headView.backgroundColor = [UIColor clearColor];
        headView.clipsToBounds = YES;
        headView.layer.cornerRadius = 24;
        headView.layer.borderColor = SMALLBUTTONCOLOR.CGColor;
        headView.layer.borderWidth = 2;
        [self.contentView addSubview:headView];
        
        
        homeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(78, 44-21, 16, 16)];
        homeImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_samecity_store" ofType:@"png"]];
        [self.contentView addSubview:homeImageView];
        
        locationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(78, 44+5+4, 16, 16)];
        locationImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_samecity_location" ofType:@"png"]];
        [self.contentView addSubview:locationImageView];
        
        homeLabel = [UILabel labelWithFrame:CGRectMake(homeImageView.right+5, 44-25, SCREENWIDTH-homeImageView.right-15, 20) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        homeLabel.textAlignment = 0;
        [self.contentView addSubview:homeLabel];
        
        
        locationLabel = [UILabel labelWithFrame:CGRectMake(locationImageView.right+5, 44+5, SCREENWIDTH-locationLabel.right-15, 20) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        locationLabel.textAlignment = 0;
        [self.contentView addSubview:locationLabel];
        
    }
    return self;
}

- (void)refreshFrom:(CompanyInfoItem *)object
{
    if (object) {
        _dataSource = object;
        
        if ([NSObject nulldata:object.name]) {
            homeLabel.text = object.name;
        }
        
        if ([NSObject nulldata:object.address]) {
            locationLabel.text = object.address;
        }
        if ([NSObject nulldata:object.logo]) {
            [headView sd_setImageWithURL:[NSURL URLWithString:object.logo] placeholderImage:[UIImage imageNamed:@"icon-60@2x.png"]];
        }else{
            headView.image = [UIImage imageNamed:@"icon-60@2x.png"];
        }
    }
}

- (void)prepareForReuse
{
    locationLabel.text = nil;
    homeLabel.text = nil;
    headView.image = [UIImage imageNamed:@"icon-60@2x.png"];
}

@end









@implementation SameCityListobject

- (instancetype)initWithDict:(NSMutableDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict) {
            [self setValuesForKeysWithDictionary:dict];
            _productNum = [dict[@"productNum"] integerValue];
        }else{
            _productNum = 0;
            _userInfo = nil;
        }
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}


@end


