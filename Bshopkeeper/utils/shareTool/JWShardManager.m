//
//  JWShardManager.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWShardManager.h"
#import "Configurations.h"
#import "UMSocialQQHandler.h"

@implementation SharedItem

@end

@interface JWShardManager ()<UMSocialUIDelegate>

@end

@implementation JWShardManager

+ (instancetype)defaultJWShardManager {
    static dispatch_once_t onceToken;
    static JWShardManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[JWShardManager alloc] init];
    });
    return sharedManager;
}

- (void)startShareWithItem:(SharedItem*)item controller:(UIViewController*)controller withImage:(UIImage *)shareImg{
      
    self.sitem = item;
    self.controller = controller;

    
    
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:kUMAnalyKey
                                      shareText:item.content
                                     shareImage:shareImg
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToSms,nil]
                                       delegate:self];
    
  
}
/**
 点击分享列表页面，之后的回调方法，你可以通过判断不同的分享平台，来设置分享内容。
 @param platformName 点击分享平台
 @prarm socialData   分享内容
 */
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    
    if (platformName==UMShareToSina) { //新浪
        NSMutableString *shareContent = [NSMutableString stringWithFormat:@"%@",self.sitem.content];
        if([self.sitem.title isNonEmpty]){
            shareContent = [NSMutableString stringWithFormat:@"【%@】%@",self.sitem.title,self.sitem.content];
        }
        if ([self.sitem.sharedURL isNonEmpty]) {
            [shareContent appendString:[NSString stringWithFormat:@" :%@",self.sitem.sharedURL]];
        }
        
        socialData.shareText = shareContent;
    }
    if (platformName==UMShareToQQ) {// 手机QQ
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
        if ([self.sitem.title isNonEmpty]) {
            [UMSocialData defaultData].extConfig.qqData.title = self.sitem.title;
        }
        if ([self.sitem.sharedURL isNonEmpty]) {
            [UMSocialData defaultData].extConfig.qqData.url = self.sitem.sharedURL;
        }
        
    }
    if (platformName==UMShareToQzone) {//QQ空间
        if ([self.sitem.title isNonEmpty]) {
            [UMSocialData defaultData].extConfig.qzoneData.title = self.sitem.title;
        }
        if ([self.sitem.sharedURL isNonEmpty]) {
            [UMSocialData defaultData].extConfig.qzoneData.url = self.sitem.sharedURL;
        }
    }
    if (platformName==UMShareToWechatSession) {//微信好友
        if ([self.sitem.sharedURL isNonEmpty]) {
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;//消息类型
            [UMSocialData defaultData].extConfig.wechatSessionData.url = self.sitem.sharedURL;
        }
        if ([self.sitem.title isNonEmpty]) {
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.sitem.title;
        }
    }
    if (platformName==UMShareToWechatTimeline) {//微信朋友圈
        if ([self.sitem.sharedURL isNonEmpty]) {
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;//消息类型
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.sitem.sharedURL;
        }
        if ([self.sitem.title isNonEmpty]) {
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.sitem.title;
        }
    }
    
    if (platformName == UMShareToSms) {//分享到短信
        NSMutableString *shareContent = [NSMutableString stringWithFormat:@"%@",self.sitem.content];
        if([self.sitem.title isNonEmpty]){
            shareContent = [NSMutableString stringWithFormat:@"【%@】%@",self.sitem.title,self.sitem.content];
        }
        if ([self.sitem.sharedURL isNonEmpty]) {
            [shareContent appendString:[NSString stringWithFormat:@" :%@",self.sitem.sharedURL]];
        }
        socialData.shareText = shareContent;
    }
   
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    BOOL issuccess = (response.responseCode == UMSResponseCodeSuccess)?YES:NO;
    NSString *result = @"";
    if (response.responseCode == UMSResponseCodeSuccess) {
        
        NSString *sharename=[[response.data allKeys] objectAtIndex:0];
        if (sharename&&[sharename isEqualToString:@"wxtimeline"]) {
            result=@"分享到 微信朋友圈 成功";
        }else if (sharename&&[sharename isEqualToString:@"wxsession"]) {
            result=@"分享到 微信好友 成功";
        }else  if (sharename&&[sharename isEqualToString:@"qzone"]) {
            result=@"分享到 QQ空间 成功";
        }else if (sharename&&[sharename isEqualToString:@"sina"]) {
            result=@"分享到 新浪微博 成功";
        }else{
            result=@"分享成功";
        }
        /*else if (sharename&&[sharename isEqualToString:@"tencent"]){
         messag=@"分享到 腾讯微博 成功";
         }else if (sharename&&[sharename isEqualToString:@"renren"]) {
         messag=@"分享到 人人网 成功";
         }*/
    }else if (response.responseCode == UMSResponseCodeCancel){
        result = @"取消分享";
    }else{
        result = @"分享失败";
    }
    
    if (issuccess) {
        [SVProgressHUD showSuccessWithStatus: result];
    }else {
        [SVProgressHUD showErrorWithStatus: result];
    }
}

// 直接分享到某个平台上
- (void)shareToSnsType:(UMSocialSnsType)type title:(NSString*)title content:(NSString*)content url:(NSString*)url toViewController:(UIViewController*)controller{
    
    NSString *platName = [UMSocialSnsPlatformManager getSnsPlatformString:type];
    
    NSString *shareContent = content;
    if ([url isNonEmpty]) {
        shareContent = [shareContent stringByAppendingString: url];
    }
    
    [[UMSocialControllerService defaultControllerService] setShareText:shareContent
                                                            shareImage:[ UIImage imageNamed: @"icon.png"]
                                                      socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:platName].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
}


@end
