//
//  InstitutionSelectedViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/17.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "InstitutionSelectedViewController.h"
#import "CompanyLocationCell.h"
#import <BaiduMapAPI/BMapKit.h>

@interface InstitutionSelectedViewController ()<UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,UITextFieldDelegate>
{
    UILabel *currentLocalLabel;            //当前位置
    UITableView *table;                    //列表
    UIView *_toolBar;                      //输入视图
    UITextField *inputField;               //输入框
    NSMutableArray *dataArray;             //数据源
    NSString *keyStr ;                     //搜索关键字
    NSString *currentCity;                 //当前城市
    
    BMKLocationService *locationService;   //定位服务
    
    BMKReverseGeoCodeOption *reverseGeoCode;
    BMKGeoCodeSearch *geoCode;
    BMKGeoCodeSearchOption * positioningOption;
    BMKPoiSearch* poisearch;
    
    
    CLLocationCoordinate2D currentLocation2d;        //当前位置
}


@end

@implementation InstitutionSelectedViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    locationService.delegate = self;
    geoCode.delegate = self;
    poisearch.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    locationService.delegate = nil;
    geoCode.delegate = nil;
    poisearch.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"店铺地址";
    UIBarButtonItem *searchBar =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(clickSearchAction:)];
    searchBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = searchBar;
    
    UIImageView *locationImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 11, 16)];
    locationImg.image = [UIImage imageNamed:@"icon_currentLocation.png"];
    [self.view addSubview:locationImg];
    
    
    NSString *type = [User defaultUser].item.sector;
    
    keyStr = [UIUtils findTypeFrom:@{@"sector":type?type:@"10"}];
    
    
    currentLocalLabel = [UILabel labelWithFrame:CGRectMake(locationImg.right +20, 0, SCREENWIDTH- 40-locationImg.right, 50) fontSize:14 fontColor:GRAYTEXTCOLOR text:@"定位中..."];
    [self.view addSubview:currentLocalLabel];
    
    
    dataArray = [[NSMutableArray alloc]init];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, currentLocalLabel.bottom, SCREENWIDTH, SCREENHEIGHT - 50- 64)];
    table.delegate = self;
    table.rowHeight = 66;
    table.dataSource = self;
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    table.tableFooterView = footView;
    [self.view addSubview:table];
    
    
    reverseGeoCode = [[BMKReverseGeoCodeOption alloc]init];
    geoCode = [[BMKGeoCodeSearch alloc]init];
    positioningOption = [[BMKGeoCodeSearchOption alloc]init];
    locationService = [[BMKLocationService alloc]init];
    locationService.delegate = self;
    poisearch = [[BMKPoiSearch alloc]init];
    poisearch.delegate = self;
    [locationService startUserLocationService];
    
    //添加工具栏
    [self addToolBar];
}
/**
 *  添加工具栏
 */
- (void)addToolBar
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0,SCREENHEIGHT, SCREENWIDTH, 44);
    bgView.image = [UIImage imageNamed:@"chat_bottom_bg"];
    bgView.userInteractionEnabled = YES;
    _toolBar = bgView;
    [self.view addSubview:bgView];
    

    UITextField *textField = [[UITextField alloc] init];
    textField.returnKeyType = UIReturnKeySearch;
    textField.enablesReturnKeyAutomatically = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.frame = CGRectMake(20, 7, SCREENWIDTH-40, 30);
    textField.background = [UIImage imageNamed:@"chat_bottom_textfield"];
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:14];
    textField.placeholder = @"请输入店铺名称/店铺位置";
    inputField = textField;
    [bgView addSubview:textField];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}



#pragma mark ---------------- 百度定位
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //当前位置与地图中心点重合
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.2;
    region.span.longitudeDelta = 0.2;
    reverseGeoCode.reverseGeoPoint = region.center;
    currentLocation2d = userLocation.location.coordinate;
    BOOL result = [geoCode reverseGeoCode:reverseGeoCode];  //返回值为Bool类型，标记成功或
    if (result == NO) {
        NSLog(@"获取地理位置失败");
    }
    [locationService stopUserLocationService];
    //开始检索
    [LoadingView show:@"加载中..."];
    [self startSearchAboutCompanyLocation];
}

#pragma mark ----------------------------- 点击搜索按钮
- (void)clickSearchAction:(id )sender
{
    if ([inputField isFirstResponder]) {
        if (inputField.text.length >0) {
            [self startPoiSearchFromLocation:inputField.text];
        }
        inputField.text = @"";
        [inputField resignFirstResponder];
    }else{
        [inputField becomeFirstResponder];
    }
}

#pragma mark ------------------------------  UITableView Delegate
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"institutionIdentifier";
    CompanyLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[CompanyLocationCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    }
    BMKPoiInfo *info =  [dataArray objectAtIndex:indexPath.row];
    [cell changeDataFrom:info withCenter:currentLocation2d];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *info =  [dataArray objectAtIndex:indexPath.row];
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    if (info.name) {
        [resultDict setObject:info.name forKey:@"name"];
    }
    if (info.address) {
        [resultDict setObject:info.address forKey:@"address"];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectedInstitution:)]) {
        [_delegate selectedInstitution:resultDict];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}


// 根据位置着 坐标
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
}

//根据 坐标找位置
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMKErrorOk) {
        currentLocalLabel.text = result.address;
        currentCity = result.addressDetail.city;
    }else{
        currentLocalLabel.text = @"获取位置信息失败";
    }
}


#pragma mark ---------------------------- 开启周边检索
- (void)startSearchAboutCompanyLocation
{
    if (currentLocation2d.latitude) {
        
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
        option.location = currentLocation2d;
        option.sortType = BMK_POI_SORT_BY_DISTANCE;
        option.radius = 2000;
        option.pageCapacity = 50;
        option.keyword = keyStr;
        [poisearch poiSearchNearBy:option];
    }
}
#pragma mark -----------------------------  poi检索回调
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [LoadingView dismiss];
        if (errorCode == BMK_SEARCH_NO_ERROR) {
            
            if (poiResult.poiInfoList.count >0) {
                dataArray = [NSMutableArray arrayWithArray:poiResult.poiInfoList];
            }else{
                [dataArray removeAllObjects];
                [SVProgressHUD showErrorWithStatus:@"未搜索到相关店铺"];
            }
            [table reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"未搜索到相关店铺"];
        }
    });
    
}

/*
 * 根据地址去搜索
 **/
- (void)startPoiSearchFromLocation:(NSString *)keyWord
{
    [LoadingView show:@"搜索中..."];
    dispatch_async(dispatch_queue_create("com.poiSearch", DISPATCH_QUEUE_CONCURRENT), ^{
        BMKCitySearchOption *option = [[BMKCitySearchOption alloc]init];
        option.city = currentCity?currentCity:@"北京";
        option.keyword = keyWord;
        option.pageCapacity = 50;
        [poisearch poiSearchInCity:option];

    });
   
}

/**
 *  键盘发生改变执行
 */
- (void)keyboardWillChanged:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y -64-44;
    
    if (keyFrame.origin.y>=SCREENHEIGHT-64) {
        moveY=  SCREENHEIGHT;
    }
    
    [UIView animateWithDuration:duration animations:^{
        _toolBar.frame = CGRectMake(0, moveY, SCREENWIDTH, 44);

    } completion:^(BOOL finished) {
        if (finished) {
            _toolBar.frame = CGRectMake(0, moveY, SCREENWIDTH, 44);
        }
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _toolBar.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 44);
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 1) {
        [self startPoiSearchFromLocation:textField.text];
    }
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
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
