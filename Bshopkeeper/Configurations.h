//
//  Configurations.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#ifndef Bshopkeeper_Configurations_h
#define Bshopkeeper_Configurations_h

#import "UIUtils.h"
#import "NSString+URLEncoding.h"
#import "UIViewExt.h"
#import "UILabel+sunny.h"
#import "FilledColorButton.h"
#import "NSObject+JWObjectNull.h"
#import "NSString+BG.h"
#import "Utility.h"
#import "LoadingView.h"
#import "JWNetClient.h"
#import "JWhttpRequestSerializer.h"
#import "NSDataAdditions.h"
#import "SFHFKeychainUtils.h"
#import "NIPreprocessorMacros.h"
#import "JudgeMethods.h"
#import "SBJson.h"
#import "JSONKit.h"
#import "TTTAttributedLabel.h"
#import "TitleImageButton.h"
#import "DataBaseObject.h"
#import "TJWOperationDB.h"
#import "SVProgressHUD.h"
#import "UserInfoItem.h"
#import "JWTextField.h"
#import "IQKeyboardManager.h"
#import "UploadManager.h"
#import "UIImage+Orientation.h"
#import "JWShardManager.h"
#import "JWShareView.h"
#import "UIView+Extension.h"

//导航 和主题颜色 0--0-------------------------------------------------------------------
#define NAVIGATIONCOLOR RGBCOLOR_HEX(0x383431)

#define SEGMENTNORMAL RGBCOLOR_HEX(0x4D4945)

#define SEGMENTSELECT RGBCOLOR_HEX(0xf0b270)

#define SMALLBUTTONCOLOR RGBCOLOR_HEX(0xa26b61)

#define SCHEMOCOLOR RGBCOLOR_HEX(0xf0533e)

#define SCHEMOCOLORSELECT RGBCOLOR_HEX(0xe54f3c)

#define TABSELECTEDCOLOR RGBCOLOR_HEX(0xffbb77)

//删除 下架的边框
#define DeleteLayerBoderColor RGBCOLOR_HEX(0x4b4642)

// 消息红点颜色
#define MessageBackColor RGBCOLOR_HEX(0xec6941)

//背景灰色
#define VIEWBACKGROUNDCOLOR RGBCOLOR_HEX(0xf3f3f3)

#define LINECOLOR RGBCOLOR_HEX(0xd8d8d8)

//字体颜色 辅助颜色
#define CUSTOMTEXTCOLOR RGBCOLOR_HEX(0x666666)

#define GRAYTEXTCOLOR RGBCOLOR_HEX(0x7b7b7b)

#define TABBOTTOMTEXTCOLOR RGBCOLOR_HEX(0x888888)

#define GrayBackColor RGBCOLOR_HEX(0xd8d8d8)

#define HBRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


//选择标签的颜色
#define TAGSCOLORONE RGBCOLOR_HEX(0xa59390)

#define TAGSCOLORTWO RGBCOLOR_HEX(0x927772)

#define TAGSCOLORTHREE RGBCOLOR_HEX(0x825d5b)

#define TAGSCOLORFORE RGBCOLOR_HEX(0x6f5f5c)

#define TAGBODLECOLOR RGBCOLOR_HEX(0xf0e9dc)


//广场的各种颜色配置
#define SquareLeftLineColor RGBCOLOR_HEX(0xbddecd)

#define SquareTextColor RGBCOLOR_HEX(0x83b59b)

#define SquareLikedColor RGBCOLOR_HEX(0xfec418)

#define SquareLinkColor RGBCOLOR_HEX(0x6ba0bb)

// 屏幕的宽度和高度------------------------------------------------------------------------
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

#define IOS7_STATUS_BAR_HEGHT (IS_IOS7 ? 20.0f : 0.0f)

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define PI 3.14159265358979323846



//本地存储的 用户信息
#define CURRENTLOGININFO @"currentLogInInfo"     //登录的方式

#define CURRENTLOGINSTATUS @"currentlogInStatus" //当前的登录状态

#define App_frist @"app_first"

//文字大小
#define NavigationTitleFont [UIFont systemFontOfSize:18.0f]

#define SegmentTitleFont [UIFont systemFontOfSize:16.0f]

#define ContentTitleFont [UIFont systemFontOfSize:14.0f]

#define ContentSubFont [UIFont systemFontOfSize:12.0f]


#ifdef DEBUG
////host  测试------------------------------------------------------------------------------
#define API_HOST "http://123.57.42.13/WenShen/V2.0.0"


//#define API_HOST "http://192.168.199.105/WenShen/V2.0.0"

#define API_SquareHost "http://123.57.42.13:3366"

//#define API_SquareHost "http://192.168.199.154:3366"

#define API_SHAREURL_STORE(storeId) [NSString stringWithFormat:@"http://123.57.42.13:8088/?storeId=%@#page_detail",storeId]

#define API_SHAREUR_PRODUCT(storeId,productId) [NSString stringWithFormat:@"http://123.57.42.13:8088/?storeId=%@#page_pdetail/%@",storeId,productId]

#define API_SHAREURL_ORDER(storeId,orderId) [NSString stringWithFormat:@"http://m.meizhanggui.cc/wxtest/?storeId=%@#page_invite/%@",storeId,orderId]

#define API_SHAREURL_SHOP(companyId) [NSString stringWithFormat:@"http://n.wenshendaka.com/test/joinCompany/?_id=%@",companyId]

#define API_ORDER_RECEIVE(storeId,billId) [NSString stringWithFormat:@"http://m.meizhanggui.cc/wsdk/?storeId=%@#!/bill/?code=%@",storeId,billId]

#define API_SHAREURL_COMMODICTY(storeId, commodityId) [NSString stringWithFormat:@"http://123.57.42.13:8088/?storeId=%@#page_fwdetail/%@",storeId,commodityId]

#define API_SHAREURL_FEED(feedId) [NSString stringWithFormat:@"http://123.57.42.13:8088/share/?feed_id=%@",feedId]

#define Shop_Product_detatil(productId) [NSString stringWithFormat:@"http://n.wenshendaka.com/test/companyProductDetail/?id=%@",productId]

#define Socket_Host @"123.57.42.13"
//#define Socket_Host @"192.168.199.133"

#define Socket_Port (4477)

#else

#define API_HOST "http://api.meizhanggui.cc/WenShen/V2.0.0"

#define API_SquareHost "http://api.meizhanggui.cc:3366"

#define API_SHAREURL_STORE(storeId) [NSString stringWithFormat:@"http://m.meizhanggui.cc/wsdk/?storeId=%@#!/home/",storeId]

#define API_SHAREUR_PRODUCT(storeId,productId) [NSString stringWithFormat:@"http://m.meizhanggui.cc/wsdk/?storeId=%@#!/pdetail?code=%@",storeId,productId]

#define API_SHAREURL_ORDER(storeId,orderId) [NSString stringWithFormat:@"http://m.meizhanggui.cc/?storeId=%@&wsdk=1#page_invite/%@",storeId,orderId]

#define API_ORDER_RECEIVE(storeId,billId) [NSString stringWithFormat:@"http://m.meizhanggui.cc/wsdk/?storeId=%@#!/bill/?code=%@",storeId,billId]

#define API_SHAREURL_COMMODICTY(storeId,commodityId) [NSString stringWithFormat:@"http://m.meizhanggui.cc/?storeId=%@#page_fwdetail/%@",storeId,commodityId]

#define API_SHAREURL_FEED(feedId) [NSString stringWithFormat:@"http://www.meizhanggui.cc/share/?feed_id=%@",feedId]

#define API_SHAREURL_SHOP(companyId) [NSString stringWithFormat:@"http://n.wenshendaka.com/joinCompany/?_id=%@",companyId]

#define Shop_Product_detatil(productId) [NSString stringWithFormat:@"http://n.wenshendaka.com/companyProductDetail/?id=%@",productId]


#define Socket_Host @"api.meizhanggui.cc"

#define Socket_Port (4477)

#endif


#ifdef DEBUG // 处于开发阶段
#define HBLog(...) NSLog(__VA_ARGS__)
#else // 出去发布阶段
#define HBLog(...)
#endif


//融云sdk
#ifdef DEBUG
//开发环境 @"vnroth0krczzo"
#define RONGCLOUD_IM_APPKEY @"vnroth0krczzo"
#else
//生产环境 @"m7ua80gbufqqm" >
#define RONGCLOUD_IM_APPKEY @"m7ua80gbufqqm"
#endif

//--------------------------------------------------------------------------------------------------------------

//数据库相关
#define CUSTOMERTABLENAME @"customerTableName"                              //客户资料的表名

#define RECORDACCOUNTNAME @"recordAccountName"                              //账单表名

#define ORDERTABNAME @"orderName"                                           //订单的表名

#define COMMODITYNAME @"commodityName"                                      //商品的表

#define PRODUCTNAME @"productName"                                          //作品名

#define COUPONTEMPLATENAME @"couponTemplateName"                            //优惠卷模版

#define COUPONCOLLECTIONNAME @"couponCollectionName"                        //优惠卷集合

#define COUPONNAME @"couponName"                                            //单个优惠卷

#define MESSAGECENTERNAME @"messagecenterName"                              //消息中心

#define ChatDataTableName @"chatDataTableName"                              //聊天记录的表

#define ChatManageTableName @"ChatManageTableName"                          //浏览过其他人的信息库

#define ShopProductTableName @"ShopProductTableName"                        //店铺作品的表

// weiXin
#define kWeChatAppId (@"wx23cfd15e1a422bca")

#define kWeChatAppSecret (@"d36c5b9bf11fdfe52cd888dc04348f14")

// Sina
#define kSinaAppKey (@"3656025725")

#define kSinaAppSecret (@"aa4861042ce78226fdf66d4856439778")

// QQ  转换后url QQ41d8544b
#define kQQAppId (@"1104696395")

#define kQQAppKey (@"xHDecO0zYWc2EBqp")

//百度地图key
#define kBaiDuKey (@"53YI8aojdut8R3w3KEm2pjfN")

// 友盟
#define kUMAnalyKey (@"55a7806367e58e993b001016")

//个推推送
#define kGetuiAppId           @"GcC3BQaAle9I63iOgjn0y5"

#define kGetuiAppKey          @"qQWpaShrIK7ILxliQO0Zj6"

#define kGetuiAppSecret       @"4w7XKYOn7G8rVMHtmH3Y77"

//------------------------------------------------------------------------------------------------

#define kPushToken @"kPushToken"                                            //注册信鸽推送时的手机信息 保存在本地

#define kPushNotication @"kPushNotication"                                  // 获取推送后发送 推送通知

#define kEDITUSERINFOSUCESS @"editUserInfoSucess"                           //修改用户数据成功 推出的通知

#define kEditOrderSucessNotice @"editOrderSucess"                           //修改订单成功 后通知

#define SquareLikeOrcommentChangedNotice @"squarelikeOrcommentchangenotice" //点赞和评论的通知

#define SquareFeedDelegateNotice  @"squarefeeddelegatenotice"               //删除feed的通知

#define SquareFeedReleaseNotice @"squarefeedreleasenotice"                  //发布feed的通知

#define wgwProductChangedNotice @"wgwproductchangednotice"                  //作品变动通知

#define wgwCommodityChangedNotice @"wgwcommoditychangednotice"              //服务报价变动通知

#define shopProductChangedNotice @"shopProductChangedNotice"                //店铺作品变动的通知

//聊天系统
#define ChatSystemConnectSucessNotice @"ChatSystemConnectSucessNotice"      //聊天系统连接成功的通知

#define ChatSytemConnectFailNotice @"ChatSytemConnectFailNotice"           //聊天系统连接失败的通知

#define ChatMessageSendSucessNotice @"chatMessageSendsucessNotice"          //聊天发送成功的通知

#define ChatMessageReceiveNotive   @"chatMessageReceiveNotive"              //聊天收到通知

#define ChatMessageHistoreRecordChangedNotice @"ChatMessageHistoreRecordChangedNotice"//聊天记录的通知

#define ChatReceivedMessageListNotice @"ChatReceivedMessageListNotice"      //聊天列表获取通知


//------------------------------------------------------------------------------------------------

#define ORDERNEEDPROMPT @"orderneedPrompt"                                  //订单的是否需要提示

#define SquareReleaseAnimation @"squarereleaseanimation"                    //广场的提示动画

#define homeLastMessageCreated @"homelastmessagecreated"                    //拉去新消息

#define StringFormat(string)     [NSString stringWithFormat:@"%@",string]

#define HBNotificationCenter [NSNotificationCenter defaultCenter]

#define ShopUserNocificationKey @"shopUserNocificationKey" 

#endif
