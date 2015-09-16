//
//  H5PreviewManageViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/31.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "H5PreviewManageViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface H5PreviewManageViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    NSString *urlStr;           //url
    UIWebView *h5WebView;       //网页
    NSString *title;            //标题
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;

}

@end

@implementation H5PreviewManageViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            urlStr = query[@"urlStr"];
            title = query[@"title"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self setRightNavigationBarBackGroundImgName:@"icon_share_white.png" frame:CGRectMake(0, 0, 45, 45)];
    self.title = title;
    h5WebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    h5WebView.delegate = self;
    [self.view addSubview:h5WebView];
    
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    h5WebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.0f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.tag = 998;
    [self.navigationController.navigationBar addSubview:_progressView];
    _progressView.progressBarView.backgroundColor = SEGMENTSELECT;
    
    if (urlStr) {
        [h5WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    }
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [h5WebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)backAction
{
    UIView *progressView1 = [self.navigationController.navigationBar viewWithTag:998];
    if (progressView1) {
        [progressView1 removeFromSuperview];
    }
    if (_progressView) {
        [_progressView removeFromSuperview];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


//分享
- (void)rightNavigationBarAction:(id)sender
{
   
    NSString *sharetitle =  [h5WebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    SharedItem *shareItem = [[SharedItem alloc] init];
    shareItem.title = sharetitle?sharetitle:@"快来看看,好消息！";
    shareItem.sharedURL = urlStr;
    shareItem.shareImg = [UIImage imageNamed:@"icon-60@2x.png"];
    JWShareView *shareView = [[JWShareView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) withShareTypes:nil dataItem:shareItem UIViewController:self];
    [shareView show];

}



- (void)dealloc
{
    if ([h5WebView isLoading]) {
        [h5WebView stopLoading];
    }
    if (h5WebView) {
        h5WebView.delegate = nil;
        [h5WebView removeFromSuperview];
        h5WebView = nil;
    }
    _progressView = nil;
    _progressProxy = nil;
    
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
