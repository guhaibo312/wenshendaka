//
//  CitySelectedViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/13.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CitySelectedViewController.h"
#import "pinyin.h"
#import "UserHomeBtn.h"
#import "ThirdAreaView.h"
#import <CoreLocation/CoreLocation.h>
#import "JWLocationManager.h"

@class CityObject,CurrentLocationCity;

@interface CitySelectedViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *listTable;
    CurrentLocationCity *topView;
}
@property (nonatomic, strong) NSArray *firstletterarray;
@property (nonatomic, strong)NSMutableDictionary *citydict;

@end

@implementation CitySelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择城市";
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setImage:[UIImage imageNamed:@"icon_city_close.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];

    _firstletterarray =@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z"];
    _citydict = [[NSMutableDictionary alloc]init];
     for (int i = 0; i < _firstletterarray.count; i++) {[_citydict setObject:[NSMutableArray array] forKey:[_firstletterarray objectAtIndex:i]];}
    
    if ([JudgeMethods defaultJudgeMethods].cityListDict) {
        NSMutableDictionary *dict =  [JudgeMethods defaultJudgeMethods].cityListDict;
        NSArray *keyArray = [JudgeMethods defaultJudgeMethods].cityListDict.allKeys;
        for (int i = 0 ; i< keyArray.count; i++) {
            NSString *key = [keyArray objectAtIndex:i];
            NSDictionary *value = [dict objectForKey:key];
            NSArray *secondKeyArry = value.allKeys;
            for (int j = 0 ; j<secondKeyArry.count; j++) {
                CityObject *oneCity = [[CityObject alloc]init];
                oneCity.cityCode = [secondKeyArry objectAtIndex:j];
                oneCity.cityName = [value objectForKey:secondKeyArry[j]];
                oneCity.provinceCode = [NSString stringWithFormat:@"%@",key];
                if (oneCity.cityName) {
                    
//                    NSMutableString *pinyin = [oneCity.cityName mutableCopy];
//                    
//                    CFMutableStringRef objCF1 = CFStringCreateMutableCopy(NULL, 0, (__bridge CFStringRef)oneCity.cityName);
//                    CFStringTransform(objCF1, NULL, kCFStringTransformStripDiacritics, NO);
//                    
//                    NSString *string = (__bridge NSString *)objCF1;
//                    if (string) {
//                        string = [string uppercaseString];
//                        NSString *codeString = [NSString stringWithFormat:@"%c",[pinyin characterAtIndex:0]];
//                        if ([_citydict.allKeys containsObject:codeString]) {
//                            [[_citydict objectForKey:codeString]addObject:oneCity];
//                        }
//                    }
//                    CFRelease(objCF1);
                    NSString *personname = oneCity.cityName;
                    char first=pinyinFirstLetter([personname characterAtIndex:0]);
                    NSString *sectionName;
                    if ((first>='a'&&first<='z')||(first>='A'&&first<='Z')) {
                        if([self searchResult:personname searchText:@"曾"])
                            sectionName = @"Z";
                        else if([self searchResult:personname searchText:@"解"])
                            sectionName = @"X";
                        else if([self searchResult:personname searchText:@"仇"])
                            sectionName = @"Q";
                        else if([self searchResult:personname searchText:@"朴"])
                            sectionName = @"P";
                        else if([self searchResult:personname searchText:@"查"])
                            sectionName = @"Z";
                        else if([self searchResult:personname searchText:@"能"])
                            sectionName = @"N";
                        else if([self searchResult:personname searchText:@"乐"])
                            sectionName = @"Y";
                        else if([self searchResult:personname searchText:@"单"])
                            sectionName = @"S";
                        else if ([self searchResult:personname searchText:@"长"] || [self searchResult:personname searchText:@"重"]){
                            sectionName = @"C";
                        }else
                            sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([personname characterAtIndex:0])] uppercaseString];
                    }
                    else {
                        sectionName=[[NSString stringWithFormat:@"%c",'#'] uppercaseString];
                    }
                    if ([_citydict.allKeys containsObject:sectionName]) {
                        [[_citydict objectForKey:sectionName]addObject:oneCity];
                    }
                }
            }
        }
    }
    
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    listTable.backgroundColor = [UIColor whiteColor];
    listTable.dataSource = self;
    listTable.delegate = self;
    listTable.showsHorizontalScrollIndicator= NO;
    listTable.showsVerticalScrollIndicator = NO;
    topView = [[CurrentLocationCity alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    [topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedUserCurrentLocation)]];
    listTable.tableHeaderView = topView;
    [topView startLocation];
    [self.view addSubview:listTable];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _firstletterarray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >=0 && section<= _firstletterarray.count) {
        return [[_citydict objectForKey:[_firstletterarray objectAtIndex:section]]count];
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section >=0 && section<= _firstletterarray.count) {
        return [_firstletterarray objectAtIndex:section];
    }
    return nil;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _firstletterarray;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return  [_firstletterarray indexOfObject:title];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *listCell = @"listcellidenitier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
    if (cell == NULL) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listCell];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    CityObject *object = [[_citydict objectForKey:_firstletterarray[indexPath.section]] objectAtIndex:indexPath.row];
    if (object) {
        cell.textLabel.text = object.cityName;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityObject *object = [[_citydict objectForKey:_firstletterarray[indexPath.section]] objectAtIndex:indexPath.row];
    
    if (object) {
        ThirdAreaView *area = [[ThirdAreaView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) cityObject:object];
        
        __weak __typeof (self)weakSelf = self;
        
        area.completeBlock = ^(CityObject *object, BOOL isback){
            
            if (isback) {
                if (object && _block) {
                    _block(object);
                    _block = NULL;
                }
                [weakSelf dismissViewControllerAnimated:YES completion:NULL];
            }
        };
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.duration = 0.25f;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [area.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        [self.view addSubview:area];
    }
}

- (void)selectedUserCurrentLocation
{
    if (topView.cityCode && topView.cityName && topView.provinceCode) {
        CityObject *object = [[CityObject alloc]init];
        object.cityName = topView.cityName;
        object.cityCode = topView.cityCode;
        object.provinceCode = topView.provinceCode;
        
        ThirdAreaView *area = [[ThirdAreaView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) cityObject:object];
        
        __weak __typeof (self)weakSelf = self;
        
        area.completeBlock = ^(CityObject *object, BOOL isback){
            
            if (isback) {
                if (object && _block) {
                    _block(object);
                    _block = NULL;
                }
                [weakSelf dismissViewControllerAnimated:YES completion:NULL];
            }
        };
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.duration = 0.25f;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [area.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        [self.view addSubview:area];
     
    }
}


- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
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

@implementation CityObject


@end

@interface CurrentLocationCity ()

@end

@implementation CurrentLocationCity

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *atitleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 44)];
        atitleLable.text = @"定位城市";
        atitleLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:atitleLable];
        
        self.cityNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width-120, 0, 100, 44)];
        self.cityNameLabel.textAlignment = NSTextAlignmentRight;
        self.cityNameLabel.font = [UIFont systemFontOfSize:14];
        _cityNameLabel.textColor = [UIColor blueColor];
        [self addSubview:_cityNameLabel];
        
        _failseButton = [[UserHomeBtn alloc]initWithFrame:CGRectMake(self.width-120, 0, 120, 44) text:@"定位失败" imageName:@"icon_city_false.png"];
        _failseButton.nameLabel.font = [UIFont systemFontOfSize:14];
        _failseButton.nameLabel.frame = CGRectMake(0, 0, 60, 44);
        _failseButton.desIamgeView.frame = CGRectMake(70, 12, 20, 20);
        [_failseButton addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_failseButton];
        
        _actionvityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.width-45, 7, 30, 30)];
        _actionvityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:_actionvityView];
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        
    }
    return self;
}

- (void)startLocation
{
    _cityNameLabel.hidden = YES;
    _failseButton.hidden = YES;
    [_actionvityView startAnimating];
    
    JWLocationManager *manager = [JWLocationManager shareManager];
    manager.mangerBlock = NULL;
    __weak __typeof (self)weakSelf = self;
    if (manager.currentCityName && manager.currentCityCode && manager.currentProvinceCode) {
        [self locationFinishAciton:manager.currentCityName code:manager.currentCityCode provinceCode:manager.currentProvinceCode];
        return;
    }
    manager.cityBlock = ^(NSString *cityName,NSString *cityCode,NSString *provinceCode){
        if (weakSelf) {
            [weakSelf locationFinishAciton:cityName code:cityCode provinceCode:provinceCode];
        }
    };
    [manager startLocation];
}

- (void)locationFinishAciton:(NSString *)cityN code:(NSString *)cityC provinceCode:(NSString *)provinceC
{
    if (!cityN || !cityC || !provinceC ) {
        if ([_actionvityView isAnimating]) {
            [_actionvityView stopAnimating];
        }
        _failseButton.hidden = NO;
        _cityNameLabel.hidden = YES;
        
    }else{
        _cityName = cityN;
        _cityCode = cityC;
        _provinceCode = provinceC;
        _cityNameLabel.text = cityN;
        
        _cityNameLabel.hidden = NO;
        _failseButton.hidden = YES;
        if ([_actionvityView isAnimating]) {
            [_actionvityView stopAnimating];
        }
        
    }

}



@end
