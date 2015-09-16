//
//  UserInfoItem.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "UserInfoItem.h"
#import "Configurations.h"
#import "CustomerModel.h"
#import "ProductModel.h"
#import "OrderModel.h"
#import "CommodityModel.h"
#import "GeTuiSdk.h"
#import "MKAnnotationView+WebCache.h"
#import "JWChatDataManager.h"
#import "JWSocketManage.h"
#import "JWLocationManager.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>



@implementation UserInfoItem

//默认的初始化
- (void)initWithParm:(NSDictionary *)dict
{
    if (dict) {
        NSDictionary *temp = [NSDictionary dictionaryWithDictionary:[UIUtils filtrationEmptyString:dict]];
        [self setValuesForKeysWithDictionary:temp];
        if (temp[@"company"]) {
            self.company = [dict objectForKey:@"company"];
        }
        if (temp[@"bankcard"]) {
            self.bankcard = [dict objectForKey:@"bankcard"];
        }
        if ([NSObject nulldata:_city]) {
            if ([_city integerValue] == 0) {
                _city = nil;
            }
        }
        if ([NSObject nulldata:_province]) {
            if ([_province integerValue] == 0) {
                _province = nil;
            }
        }
        if ([NSObject nulldata:_area]) {
            if ([_area integerValue] == 0) {
                _area = nil;
            }
        }
        if ([NSObject nulldata:_companyId]) {
            if ([_companyId integerValue] == 0) {
                _companyId = nil;
            }
        }
        
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    HBLog(@"%@",key);
}

@end



@interface User ()<RCIMUserInfoDataSource,RCIMReceiveMessageDelegate>

@end

@implementation User




//修改数据后对应的item也应该修改
- (void)changeUserInfo:(NSDictionary *)idict storeInf:(NSDictionary *)sdict
{
    if (idict) {
        if ([idict.allKeys containsObject:@"nickname"]) {
            self.item.nickname = idict[@"nickname"];
        }
        
        if ([idict.allKeys containsObject:@"faith"]) {
            self.item.faith = idict[@"faith"];
        }
        
        if ([idict.allKeys containsObject:@"birthYear"]) {
            self.item.birthYear =[NSString stringWithFormat:@"%@",idict[@"birthYear"]];
        }
        if ([idict.allKeys containsObject:@"birthMonth"]) {
            self.item.birthMonth =[NSString stringWithFormat:@"%@",idict[@"birthMonth"]];
        }
        if ([idict.allKeys containsObject:@"birthDay"]) {
            self.item.birthDay =[NSString stringWithFormat:@"%@",idict[@"birthDay"]];
        }
        if ([idict.allKeys containsObject:@"avatar"]) {
            self.item.avatar = idict[@"avatar"];
        }
        if ([idict.allKeys containsObject:@"wxNum"]) {
            self.item.wxNum = idict[@"wxNum"];
        }
        
        if ([idict.allKeys containsObject:@"gender"]) {
            self.item.gender = idict[@"gender"];
        }
        if ([idict.allKeys containsObject:@"company"]) {
            self.item.company = idict[@"company"];
        }
        if ([idict.allKeys containsObject:@"city"]) {
            self.storeItem.city = idict[@"city"];
            self.item.city = idict[@"city"];
        }
        if ([idict.allKeys containsObject:@"province"]) {
            self.storeItem.province = idict[@"province"];
            self.item.province = idict[@"province"];
        }
        if ([idict.allKeys containsObject:@"area"]) {
            self.storeItem.area= idict[@"area"];
            self.item.area = idict[@"area"];
        }
    }
    if (sdict) {
        
        if ([sdict.allKeys containsObject:@"city"]) {
            self.storeItem.city = sdict[@"city"];
            self.item.city = sdict[@"city"];
        }
        if ([sdict.allKeys containsObject:@"province"]) {
            self.storeItem.province = sdict[@"province"];
            self.item.province = sdict[@"province"];
        }
        
        if ([sdict.allKeys containsObject:@"area"]) {
            self.storeItem.area= sdict[@"area"];
            self.item.area = sdict[@"area"];
        }

        if ([sdict.allKeys containsObject:@"orderNotice"]) {
            self.storeItem.orderNotice = sdict[@"orderNotice"];
        }
        
        if ([sdict.allKeys containsObject:@"openTime"]) {
            self.storeItem.openTime = sdict[@"openTime"];
        }

        
        if ([sdict.allKeys containsObject:@"storeName"]) {
            self.storeItem.storeName = sdict[@"storeName"];
        }
        
         if ([sdict.allKeys containsObject:@"serviceArea"]) {
            self.storeItem.serviceArea = sdict[@"serviceArea"];
        }
        
        int num = [sdict[@"serviceToHome"]intValue];
        
        if ([[sdict allKeys]containsObject:@"serviceToHome"]) {
            
            self.storeItem.serviceToHome = (num == 1?@"1":@"0");
        }
        
        num = [sdict[@"serviceInStore"]intValue];
        if ([[sdict allKeys]containsObject:@"serviceInStore"]) {
            
            self.storeItem.serviceInStore = (num == 1?@"1":@"0");
        }
        if ([[sdict allKeys]containsObject:@"topBanner"]) {
            self.storeItem.topBanner = sdict[@"topBanner"];
        }
    }

}

+ (instancetype)defaultUser
{
    static User *currentuser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentuser = [[User alloc]init];
        currentuser.followingDict = [[NSMutableDictionary alloc]init];
    });
    return currentuser;
}

/**初始化登录负值
 */
- (void)logInSucessSaveInfo:(NSDictionary *)result
{
    if (!result && !self) return;
    NSDictionary *userInfo = [[result objectForKey:@"data"]objectForKey:@"userInfo"];
    
    HBLog(@"recommendationSetting----------%@",[[result objectForKey:@"data"]objectForKey:@"recommendationSetting"]);
    
    NSDictionary *storeInfo = [[result objectForKey:@"data"]objectForKey:@"storeInfo"];
    UserInfoItem *userItem = [[UserInfoItem alloc]init];
    [userItem initWithParm:userInfo];
    StoryInfoItem *storeitem = [[StoryInfoItem alloc]init];
    [storeitem setValuesForSlef:storeInfo];
     
    self.item = userItem;
    self.isLogIn = YES;
    self.storeItem = storeitem;
    
    BOOL isFirst = [[NSUserDefaults standardUserDefaults]boolForKey:App_frist];
    if (!isFirst) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:App_frist];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [JudgeMethods defaultJudgeMethods].showSquareNotice = YES;
        [JudgeMethods defaultJudgeMethods].showimageNotice = YES;
    }

    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:CURRENTLOGINSTATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSDictionary *setting = [[result objectForKey:@"data"]objectForKey:@"setting"];
    if (setting) {
        self.kefuNum = setting[@"kefuNum"];
        self.galleryBanner = setting[@"galleryBanner"];
        self.squareBanner = setting[@"squareBanner"];
        self.cannotChat = [setting[@"canNotChat"] boolValue];
        self.cannotChat = NO;
        
        self.kefuNum = setting[@"kefuNum"];
        self.rongcloudToken =[NSString stringWithFormat:@"%@",setting[@"rongyunToken"]];
        if (self.kefuNum) {
            [[JWNetClient defaultJWNetClient]squareGet:@"/users" requestParm:@{@"userId":self.kefuNum} result:^(id responObject, NSString *errmsg) {
                if (!self) return ;
                if (responObject) {
                    NSDictionary *userInfo = [responObject objectForKey:@"data"];
                    if (userInfo) {
                        self.kefuHeadURL = userInfo[@"avatar"];
                        self.kefuName = userInfo[@"nickname"];
                    }
                }
            }];
        }

    }
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate) {
        NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:kPushToken];
        if (tokenStr) {
            [appdelegate setGeTuiToken:tokenStr];
        }
        NSString *sector = [NSString stringWithFormat:@"sector_%@",self.item.sector];
        [appdelegate bindGeTuiAlisa:[NSString stringWithFormat:@"%@",self.item.userId]];
        [appdelegate setGeTuiTag:@[sector]];
        [appdelegate openGetui:YES];
        [GeTuiSdk resume];
    }
    
    
    
    [[RCIM sharedRCIM]setUserInfoDataSource:self];
    [[RCIM sharedRCIM]setReceiveMessageDelegate:self];
    
    self.supportRongyun = NO;
    if ([NSObject nulldata:self.rongcloudToken]) {
        [[RCIM sharedRCIM] connectWithToken:self.rongcloudToken success:^(NSString *userId) {
            // Connect 成功
            HBLog(@"容云登录成功");
            self.supportRongyun = YES;
        }error:^(RCConnectErrorCode status) {
            // Connect 失败
            HBLog(@"容云登录失败");

        }tokenIncorrect:^() {
            // Token 失效的状态处理、
            HBLog(@"容云token失效");

        }];
    }


    JWLocationManager *locaitonManage = [JWLocationManager shareManager];
    locaitonManage.cityBlock = NULL;
    locaitonManage.mangerBlock =  ^(CLLocation *location){
        if (location) {
            if (location.coordinate.latitude >0 && location.coordinate.longitude >0) {
                self.item.lat = location.coordinate.latitude;
                self.item.lon = location.coordinate.longitude;
            }
        }
    };
    
    
    [self performSelectorInBackground:@selector(getSelfFuns:) withObject:self.item.userId];
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    [JudgeMethods defaultJudgeMethods].showKefuMessage = YES;
    [JudgeMethods defaultJudgeMethods].kefuMessageCount++;
    [[NSNotificationCenter defaultCenter]postNotificationName:kPushNotication object:nil];
}


- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    
    [[JWNetClient defaultJWNetClient]squareGet:@"/users" requestParm:@{@"userId":userId} result:^(id responObject, NSString *errmsg) {
        if (!self) return ;
        if (responObject) {
            NSDictionary *userInfo = [responObject objectForKey:@"data"];
            if (userInfo) {
                RCUserInfo *_currentUserInfo =
                [[RCUserInfo alloc] initWithUserId:userId
                                              name:userInfo[@"nickname"]
                                          portrait:userInfo[@"avatar"]];
                completion(_currentUserInfo);
            }
        }
    }];
    
}


- (void)getSelfFuns:(NSString *)userId
{
    __weak __typeof(self)weakSelf = self;
    [[JWNetClient defaultJWNetClient]squareGet:@"/follows/followings" requestParm:@{} result:^(id responObject, NSString *errmsg) {
        if (!errmsg) {
            NSArray *data = responObject[@"data"];
            if (weakSelf && data) {
                NSMutableDictionary *focusDict = [[NSMutableDictionary alloc]init];
                int count = (int)data.count;
                for (int i = 0 ; i< count; i++) {
                    NSDictionary *one = [data objectAtIndex:i];
                    NSString *key = [NSString stringWithFormat:@"%@",one[@"userId"]];
                    if ([NSObject nulldata:key]) {
                        [focusDict setObject:one forKey:key];
                    }
                }
                weakSelf.followingDict = focusDict;
            }
        }
    }];


}


//登录成功获取新增数据
- (void)getNewDataFromServer
{
    
    //先更新本地浏览记录
    [[JWChatDataManager sharedManager]onceLoadLocalToCache];
    
    
    //作品
    NSString *productLastUpTime = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",PRODUCTNAME,self.item.userId]];
    if (!productLastUpTime) {
        productLastUpTime = @"0";
    }

    //订单
    NSString *orderLastUpTime = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,self.item.userId]];
    if (!orderLastUpTime) {
        orderLastUpTime = @"0";
    }
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    UIActivityIndicatorView * actiview = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actiview.center = backView.center;
    [backView addSubview:actiview];
    [actiview startAnimating];
    backView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    backView.tag = 508;
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    
    __weak __typeof (self)weakSelf = self;
    
    [[JWNetClient defaultJWNetClient]getNetClient:@"Update/list" requestParm:@{@"Product":productLastUpTime,@"Order":orderLastUpTime} result:^(id responObject, NSString *errmsg) {
        if (!weakSelf) return ;
        if (errmsg) {
            [weakSelf requestFinished:nil];
        }else{
            [weakSelf requestFinished:responObject];
        }
    }];
    
}

- (void)requestFinished:(id)responseObject
{
    if (!responseObject) {
        
        dispatch_main_async_safe(^{
            UIView *loadBackView = [[UIApplication sharedApplication].keyWindow viewWithTag:508];
            if (loadBackView ) {
                [loadBackView removeFromSuperview];
            }
            [[AppDelegate appDelegate]pushToLogInControllor:NO];
//            //启动socket
//            [[JWSocketManage shareManage]startConnect];

        });
        return;
    }else{
            NSDictionary *newDict = [responseObject objectForKey:@"data"];
            if (newDict) {
                NSArray *customerArray = [newDict objectForKey:@"Customer"];
                TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",self.item.userId]];
                
                
                //刷新作品
                customerArray = [newDict objectForKey:@"Product"];
                if (customerArray.count >0) {
                    for (int i = 0 ; i< customerArray.count; i++) {
                        NSDictionary *tempD = [customerArray objectAtIndex:i];
                        //判断数据库有数据就更新 没有就添加
                        ProductModel *model = [[ProductModel alloc]initWithDictionary:tempD];
                        if ([operationDB theTableIsHavetheData:model._id fromeTable:[NSString stringWithFormat:@"%@%@",PRODUCTNAME,self.item.userId]]) {
                            
                            if ([tempD[@"deletedTime"]doubleValue] >0 ) {
                                [operationDB delegateObjectFromeTable:tempD[@"_id"]fromeTable:[NSString stringWithFormat:@"%@%@",PRODUCTNAME,self.item.userId]];
                            }else{
                                [operationDB upDataObjectInfo:model fromTable:[NSString stringWithFormat:@"%@%@",PRODUCTNAME,self.item.userId]];
                            }
                        }else{
                            if ([tempD[@"deletedTime"] doubleValue] < 1) {
                                [operationDB insertObjectObject:model fromeTable:[NSString stringWithFormat:@"%@%@",PRODUCTNAME,self.item.userId]];
                            }
                            
                        }
                        
                        if (i == customerArray.count-1) {
                            NSString *upDataTime = tempD[@"updateTime"];
                            if (upDataTime) {
                                // 存储拉取新的时间
                                [[NSUserDefaults standardUserDefaults] setObject:upDataTime forKey:[NSString stringWithFormat:@"%@%@",PRODUCTNAME,self.item.userId]];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                                
                            }
                        }
                    }
                    
                }
                
                //刷新登记
                customerArray = [newDict objectForKey:@"Order"];
                if (customerArray.count >0) {
                    for (int i = 0 ; i< customerArray.count; i++) {
                        NSDictionary *tempD = [customerArray objectAtIndex:i];
                        OrderModel *model = [[OrderModel alloc]initWithDictionary:tempD];
                        
                        if ([tempD[@"deletedTime"] doubleValue] >1) {
                            if ([operationDB theTableIsHavetheData:model._id fromeTable:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,self.item.userId]]) {
                                [operationDB delegateObjectFromeTable:tempD[@"_id"] fromeTable:ORDERTABNAME];
                            }
                        }else{
                            //判断数据库有数据就更新 没有就添加
                            if ([operationDB theTableIsHavetheData:model._id fromeTable:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,self.item.userId]]) {
                                [operationDB upDataObjectInfo:model fromTable:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,self.item.userId]];
                            }else{
                                [operationDB insertObjectObject:model fromeTable:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,self.item.userId]];
                            }
                        }
                        if (i == customerArray.count-1) {
                            NSString *upDataTime = tempD[@"updateTime"];
                            if (upDataTime) {
                                // 存储拉取新的时间
                                [[NSUserDefaults standardUserDefaults] setObject:upDataTime forKey:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,self.item.userId]];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                            }
                        }
                    }
                }
            }
        dispatch_main_async_safe(^{
            UIView *loadBackView = [[UIApplication sharedApplication].keyWindow viewWithTag:508];
            if (loadBackView ) {
                [loadBackView removeFromSuperview];
            }
            [[AppDelegate appDelegate]pushToLogInControllor:NO];
            //启动socket
//            [[JWSocketManage shareManage]startConnect];
        });
    }
}

@end
