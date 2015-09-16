//
//  JWShareView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/27.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWShareView.h"
#import "UserHomeBtn.h"

@interface JWShareView ()<UMSocialUIDelegate>
{
    float bottomHeight;
}
@property (nonatomic, strong) SharedItem *dataItem;
@property (nonatomic, strong) UIViewController *supController;
@end

@implementation JWShareView


/**分享到各个平台
 *@types 制定类型的数组
 */
- (instancetype)initWithFrame:(CGRect)frame withShareTypes:(NSArray *)types dataItem:(SharedItem*)item UIViewController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _dataItem = item;
        _supController = controller;
        
        backGroundView = [[UIView alloc]initWithFrame:self.bounds];
        backGroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissMiss)];
        backGroundView.userInteractionEnabled = YES;
        [backGroundView addGestureRecognizer:tap];
        [self addSubview:backGroundView];
        
        bottomeView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-260, SCREENHEIGHT, 260)];
        bottomeView.backgroundColor = RGBCOLOR(240, 240, 240);
        
        int totalType = 7;
        NSArray *titleArray = @[@(JWShareViewTypewx),@(JWShareViewTypewxpyq),@(JWShareViewTypesjqq),@(JWShareViewTypeqqkj),@(JWShareViewTypexlwb),@(JWShareViewTypesjdx),@(JWShareViewTypefzlj)];
        if (types != nil) {
            totalType = (int)types.count;
            titleArray = [NSArray arrayWithArray:types];
        }
        
        for (int i = 0 ; i< totalType; i++) {
            
            UserHomeBtn *oneBtn = [[UserHomeBtn alloc]initWithFrame:CGRectMake(SCREENWIDTH/4*(i%4), 10+(i/4)*SCREENWIDTH/4, SCREENWIDTH/4, SCREENWIDTH/4) text:[self returnTitleFromJWShareType:[titleArray[i] integerValue]] imageName:nil];
           
            oneBtn.desIamgeView.image = [self returnImgFormJWShareType:[titleArray[i] integerValue]];
            oneBtn.backgroundColor = [UIColor clearColor];
            oneBtn.desIamgeView.frame = CGRectMake(20, 10, SCREENWIDTH/4-40, SCREENWIDTH/4-40);
            oneBtn.nameLabel.frame = CGRectMake(10, oneBtn.height-25, oneBtn.width-20, 25);
            oneBtn.desIamgeView.layer.cornerRadius= 5;
            if ([titleArray[i]integerValue] == JWShareViewTypewxpyq) {
                oneBtn.desIamgeView.layer.borderWidth =0.5;
                oneBtn.desIamgeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }
            oneBtn.desIamgeView.clipsToBounds = YES;
            oneBtn.nameLabel.font = [UIFont systemFontOfSize:12];
            oneBtn.nameLabel.backgroundColor = [UIColor clearColor];
            [oneBtn setBackgroundImage:[UIUtils imageFromColor:RGBCOLOR(240, 240, 240)] forState:UIControlStateNormal];
            [oneBtn addTarget:self action:@selector(clickOneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [bottomeView addSubview:oneBtn];
        }
        [self addSubview:bottomeView];
        
        bottomHeight = (totalType/4+2)*SCREENWIDTH/4+10;
        bottomeView.height = bottomHeight;
        UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, bottomHeight-SCREENWIDTH/4+10, SCREENWIDTH-30, 40)];
        cancleBtn.backgroundColor = [UIColor clearColor];
        cancleBtn.layer.borderWidth = 0.5;
        cancleBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cancleBtn setTitle:@"取消分享" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancleBtn addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
        [bottomeView addSubview:cancleBtn];
        
        
        self.tag = 201;
    }
    return self;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *haveView = [keyWindow viewWithTag:201];
    if (haveView) {
        [haveView removeFromSuperview];
    }
    [keyWindow addSubview:self];
    backGroundView.alpha = 0;
    bottomeView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, bottomHeight);
    [UIView animateWithDuration:0.3 animations:^{
        bottomeView.frame = CGRectMake(0, SCREENHEIGHT- bottomHeight, SCREENWIDTH, bottomHeight);
        backGroundView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        }
    }];
}


- (void)dissMiss
{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *haveView = [keyWindow viewWithTag:201];
    if (haveView) {
        
        [UIView animateWithDuration:0.3 animations:^{
            bottomeView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, bottomHeight);
            backGroundView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                if (_block) {
                    _block();
                }
                _block = NULL;
                [self removeFromSuperview];
            }
        }];
    }
    
}


- (NSString *)returnTitleFromJWShareType:(JWShareViewType)type
{
    if (type == JWShareViewTypewx) {
        
        return @"微信";
    }else if (type == JWShareViewTypewxpyq){
        return @"微信朋友圈";
    }else if (type == JWShareViewTypesjqq){
        return @"手机QQ";
    }else if (type == JWShareViewTypeqqkj){
        return @"QQ空间";
    }else if (type == JWShareViewTypexlwb){
        return @"新浪微博";
    }else if (type == JWShareViewTypesjdx){
        return @"短信";
    }else if (type == JWShareViewTypefzlj){
        return @"复制链接";
    }
    return @"";
}


- (UIImage *)returnImgFormJWShareType:(JWShareViewType)type
{
    
    if (type == JWShareViewTypewx) {
        return [UIImage imageNamed:@"icon_weixin_popover.png"];
    }else if (type == JWShareViewTypewxpyq){
        return [UIImage imageNamed:@"icon_wxpyq_popover.png"];
    }else if (type == JWShareViewTypesjqq){
        return [UIImage imageNamed:@"icon_qq_popover.png"];
    }else if (type == JWShareViewTypeqqkj){
        return [UIImage imageNamed:@"icon_qqkj_popover.png"];
    }else if (type == JWShareViewTypexlwb){
        return [UIImage imageNamed:@"icon_sina_popover.png"];
    }else if (type == JWShareViewTypesjdx){
        return [UIImage imageNamed:@"icon_message_popover_night.png"];
    }else if (type == JWShareViewTypefzlj){
        return [UIImage imageNamed:@"icon_copy_popover.png"];
    }
    return nil;

}

- (void)clickOneBtnAction:(UserHomeBtn *)sender
{
    NSString *type = sender.nameLabel.text;
    if ([type isEqualToString:@"微信"]) {
        [self shareToSnsType:UMSocialSnsTypeWechatSession];
        return ;
    }else if ([type isEqualToString:@"微信朋友圈"]){
        [self shareToSnsType:UMSocialSnsTypeWechatTimeline];

        return ;
    }else if ([type isEqualToString:@"手机QQ"]){
        [self shareToSnsType:UMSocialSnsTypeMobileQQ];

        return ;
    }else if ([type isEqualToString:@"QQ空间"]){
        [self shareToSnsType:UMSocialSnsTypeQzone];

        return ;
    }else if ([type isEqualToString:@"新浪微博"]){
        [self shareToSnsType:UMSocialSnsTypeSina];

        return ;
    }else if ([type isEqualToString:@"短信"]){
        [self shareToSnsType:UMSocialSnsTypeSms];

        return ;
    }else if ([type isEqualToString:@"复制链接"]){
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:_dataItem.sharedURL];
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        [self dissMiss];
        return ;
    }
}

- (void)shareToSnsType:(UMSocialSnsType)type {
    
    self.hidden = YES;

    NSString *platName = [UMSocialSnsPlatformManager getSnsPlatformString:type];
    NSString *content = @"";
    UIImage *sharIMG = [UIImage imageNamed:@"icon_qq_popover.png"];

    if (_dataItem) {
        if ([NSObject nulldata:_dataItem.content]) {
            content = _dataItem.content;
        }
        if (_dataItem.shareImg) {
            sharIMG = _dataItem.shareImg;
        }
    }
    
    [[UMSocialControllerService defaultControllerService] setShareText:content
                                                            shareImage:sharIMG
                                                      socialUIDelegate:self];
    //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:platName].snsClickHandler(_supController,[UMSocialControllerService defaultControllerService],YES);
}


-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    
    
    if (platformName==UMShareToSina) { //新浪
        NSMutableString *shareContent = [NSMutableString stringWithFormat:@"%@",self.dataItem.content];
        if([self.dataItem.title isNonEmpty]){
            shareContent = [NSMutableString stringWithFormat:@"【%@】%@",self.dataItem.title,self.dataItem.content];
        }
        if ([self.dataItem.sharedURL isNonEmpty]) {
            [shareContent appendString:[NSString stringWithFormat:@" :%@",self.dataItem.sharedURL]];
        }
        [shareContent appendString:@" @纹身大咖"];
        socialData.shareText = shareContent;
        
    }
    if (platformName==UMShareToQQ) {// 手机QQ
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
        if ([self.dataItem.title isNonEmpty]) {
            [UMSocialData defaultData].extConfig.qqData.title = self.dataItem.title;
        }
        if ([self.dataItem.sharedURL isNonEmpty]) {
            [UMSocialData defaultData].extConfig.qqData.url = self.dataItem.sharedURL;
        }
        
    }
    if (platformName==UMShareToQzone) {//QQ空间
        if ([self.dataItem.title isNonEmpty]) {
            [UMSocialData defaultData].extConfig.qzoneData.title = self.dataItem.title;
        }
        if ([self.dataItem.sharedURL isNonEmpty]) {
            [UMSocialData defaultData].extConfig.qzoneData.url = self.dataItem.sharedURL;
        }
    }
    if (platformName==UMShareToWechatSession) {//微信好友
        if ([self.dataItem.sharedURL isNonEmpty]) {
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;//消息类型
            [UMSocialData defaultData].extConfig.wechatSessionData.url = self.dataItem.sharedURL;
        }
        if ([self.dataItem.title isNonEmpty]) {
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.dataItem.title;
        }
    }
    if (platformName==UMShareToWechatTimeline) {//微信朋友圈
        if ([self.dataItem.sharedURL isNonEmpty]) {
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;//消息类型
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.dataItem.sharedURL;
        }
        if ([self.dataItem.title isNonEmpty]) {
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.dataItem.title;
        }
    }
    
    if (platformName == UMShareToSms) {//分享到短信
        NSMutableString *shareContent = [NSMutableString stringWithFormat:@"%@",self.dataItem.content];
        if([self.dataItem.title isNonEmpty]){
            shareContent = [NSMutableString stringWithFormat:@"【%@】%@",self.dataItem.title,self.dataItem.content];
        }
        if ([self.dataItem.sharedURL isNonEmpty]) {
            [shareContent appendString:[NSString stringWithFormat:@" :%@",self.dataItem.sharedURL]];
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
    
    if (_block) {
        _block();
    }
    _block = NULL;
    
}



@end
