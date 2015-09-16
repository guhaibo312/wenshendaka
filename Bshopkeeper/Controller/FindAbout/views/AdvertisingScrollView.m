

#import "AdvertisingScrollView.h"
#import <objc/runtime.h>
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import "Configurations.h"
#import "H5PreviewManageViewController.h"

@interface AdvertisingScrollView ()
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
}

- (void)setupViews;
- (void)switchFocusImageItems;

@end

static NSString *SG_FOCUS_ITEM_ASS_KEY = @"loopScrollview";

static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 2.0; //switch interval time


@implementation AdvertisingScrollView


- (id)initWithFrame:(CGRect)frame ownerController:(UIViewController *)controller isAuto:(BOOL)isAuto array:(NSArray *)data
{
    self = [super initWithFrame:frame];
    if (self) {
    
        if (controller) {
            self.ownerController = controller;
        }
        
        //网络请求图片
        NSMutableArray *arr = [NSMutableArray arrayWithArray:data];
        NSMutableArray *imagesArray = [NSMutableArray arrayWithArray:arr];
        if (arr.count > 1) {
            [imagesArray insertObject:[arr lastObject] atIndex:0];
            [imagesArray addObject:[arr firstObject]];
        }
        objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, imagesArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        _isAutoPlay = isAuto;
        [self setupViews];
        
    }
    return self;
}

- (void)setupViews
{
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.scrollsToTop = NO;
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.width/2-30, self.height-20, 60, 20)];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = NAVIGATIONCOLOR;
    
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    _pageControl.numberOfPages = imageItems.count>1?imageItems.count -2:imageItems.count;
    _pageControl.currentPage = 0;
    _scrollView.delegate = self;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * imageItems.count, _scrollView.frame.size.height);
    for (int i = 0; i < imageItems.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.width, 0, _scrollView.width, _scrollView.height)];
        NSString *urlStr = [[imageItems objectAtIndex:i]objectForKey:@"img"];
        NSURL *url = [NSURL URLWithString:urlStr];
        if (url) {
            [imageView sd_setImageWithURL:url];

        }
        [_scrollView addSubview:imageView];
    }
    
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO] ;

}
- (void)stop
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
}

- (void)start
{
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);

    if ([imageItems count]>1 && _isAutoPlay)
    {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
    }
}

- (void)switchFocusImageItems
{
    [self stop];
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
    targetX = (int)(targetX/self.width) * self.width;
    [self moveToTargetPosition:targetX];
    [self start];
}


//点击
- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (!_ownerController) return;
    
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    if (page > -1 && page < imageItems.count) {
        
        NSDictionary *item = [imageItems objectAtIndex:page];
        NSString *url = item[@"url"];
        if (url) {
            H5PreviewManageViewController *hotVC = [[H5PreviewManageViewController alloc]initWithQuery:@{@"urlStr":url}];
            [_ownerController.navigationController pushViewController:hotVC animated:YES];
        }
   
    }
}
- (void)moveToTargetPosition:(CGFloat)targetX
{
    BOOL animated = YES;
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float targetX = scrollView.contentOffset.x;
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>=3)
    {
        if (targetX >= self.width * ([imageItems count] -1)) {
            targetX = self.width;
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
        else if(targetX <= 0)
        {
            targetX = self.width *([imageItems count]-2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    NSInteger page = (_scrollView.contentOffset.x+self.width/2.0) / self.width;
    if ([imageItems count] > 1)
    {
        page --;
        if (page >= _pageControl.numberOfPages)
        {
            page = 0;
        }else if(page <0)
        {
            page = _pageControl.numberOfPages -1;
        }
    }
    _pageControl.currentPage = page;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/self.width) * self.width;
        [self moveToTargetPosition:targetX];
    }
}


- (void)scrollToIndex:(NSInteger)aIndex
{
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>1)
    {
        if (aIndex >= ([imageItems count]-2))
        {
            aIndex = [imageItems count]-3;
        }
        [self moveToTargetPosition:self.width*(aIndex+1)];
    }else
    {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
    
}
- (void)deleteAll
{
    if (_ownerController) {
        _ownerController = nil;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    objc_removeAssociatedObjects(self);
}


- (void)dealloc
{
    NSLog(@"广告挂了");
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
