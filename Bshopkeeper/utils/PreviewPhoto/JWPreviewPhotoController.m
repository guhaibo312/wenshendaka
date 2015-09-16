//
//  JWPreviewPhotoController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/30.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWPreviewPhotoController.h"
#import <QuartzCore/QuartzCore.h>
#import "Configurations.h"


static const double kAnimationDuration = 0.3;

static inline GGOrientation convertOrientation(UIInterfaceOrientation orientation) {
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return GGOrientationLandscapeLeft;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            return GGOrientationPortraitUpsideDown;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return GGOrientationLandscapeRight;
            break;
        default:
            return GGOrientationPortrait;
            break;
    }
}

static inline NSInteger RadianDifference(UIInterfaceOrientation from, UIInterfaceOrientation to) {
    GGOrientation gg_from = convertOrientation(from);
    GGOrientation gg_to = convertOrientation(to);
    return gg_from-gg_to;
}


@interface JWPreviewPhotoController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) UIInterfaceOrientation fromOrientation;
@property (nonatomic, assign) UIInterfaceOrientation toOrientation;

- (void) onDismiss;


@end

@implementation JWPreviewPhotoController
@synthesize thumbArray;
@synthesize imageUrlArr;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) init {
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.supportedOrientations = UIInterfaceOrientationMaskAll;
    }
    return self;
}


#pragma mark - View Life Cycle

- (void) loadView
{
    scrollImageArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.view = [[UIView alloc] init];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*[self.thumbArray count], CGRectGetHeight(self.view.frame));
    self.scrollView.autoresizingMask = self.view.autoresizingMask;
    [self.view addSubview:self.scrollView];
    
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.autoresizingMask = self.view.autoresizingMask;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDismiss)];
    [self.imageView addGestureRecognizer:tap];
    
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
    
    [nc addObserver:self
           selector:@selector(orientationChanged:)
               name:UIDeviceOrientationDidChangeNotification
             object:device];
    
    original = [UIApplication sharedApplication].statusBarOrientation;
    
}


- (void)orientationChanged:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation !=original)
    {
        int i = 0;
        for (JWScrollPhotoView* preView in scrollImageArr)
        {
            preView.contentSize = CGSizeMake(preView.frame.size.width, preView.frame.size.height);
            preView.frame = CGRectMake(i*CGRectGetWidth(preView.frame), 0, CGRectGetWidth(preView.frame), CGRectGetHeight(preView.frame));
            i++;
        }
        self.scrollView.contentSize = CGSizeMake([self.imageUrlArr count]*self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width*currentNum, 0);
    }
    original = orientation;
}



- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIApplication *app = [UIApplication sharedApplication];
    UIView *window = [app keyWindow];
    [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    self.imageView.image = self.liftedImageView.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    
    
    CGRect startFrame = [self.liftedImageView convertRect:self.liftedImageView.bounds toView:window];
    self.imageView.layer.position = CGPointMake(startFrame.origin.x + floorf(startFrame.size.width/2), startFrame.origin.y + floorf(startFrame.size.height/2));
    
    UIInterfaceOrientation orientation = self.presentingViewController.interfaceOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        self.imageView.layer.bounds = CGRectMake(0, 0, startFrame.size.width, startFrame.size.height);
    } else {
        self.imageView.layer.bounds = CGRectMake(0, 0, startFrame.size.height, startFrame.size.width);
    }
    
    if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        self.imageView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        self.imageView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
    } else {
        self.imageView.layer.transform = CATransform3DIdentity;
    }
    [window addSubview:self.imageView];
    
    self.fromOrientation = self.presentingViewController.interfaceOrientation;
    self.toOrientation = self.interfaceOrientation;
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIApplication *app = [UIApplication sharedApplication];
    UIView *window = [app keyWindow];
    [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    CGRect endFrame = [self.scrollView convertRect:self.scrollView.bounds toView:window];
    CABasicAnimation *center = [CABasicAnimation animationWithKeyPath:@"position"];
    center.fromValue = [NSValue valueWithCGPoint:self.imageView.layer.position];
    center.toValue = [NSValue valueWithCGPoint:CGPointMake(floorf(endFrame.size.width/2),floorf(endFrame.size.height/2))];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"bounds"];
    scale.fromValue = [NSValue valueWithCGRect:self.imageView.layer.bounds];
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotate.fromValue = [NSValue valueWithCATransform3D:self.imageView.layer.transform];
    
    UIInterfaceOrientation from = self.fromOrientation;
    UIInterfaceOrientation to = self.toOrientation;
    
    if (UIInterfaceOrientationIsPortrait(to)) {
        scale.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, endFrame.size.width, endFrame.size.height)];
    } else {
        scale.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, endFrame.size.height, endFrame.size.width)];
    }
    
    NSInteger factor = RadianDifference(from, to);
    rotate.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.imageView.layer.transform, factor*M_PI_2, 0, 0, 1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = kAnimationDuration;
    group.delegate = self;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.animations = @[scale,rotate,center];
    
    [group setValue:@"expand" forKey:@"type"];
    
    self.imageView.layer.position = [center.toValue CGPointValue];
    self.imageView.layer.bounds = [scale.toValue CGRectValue];
    self.imageView.layer.transform = [rotate.toValue CATransform3DValue];
    [self.imageView.layer addAnimation:group forKey:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = [app keyWindow];
    [app setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    CGRect startFrame = [self.imageView convertRect:self.imageView.bounds toView:window];
    self.imageView.layer.position = CGPointMake(startFrame.origin.x + floorf(startFrame.size.width/2), startFrame.origin.y + floorf(startFrame.size.height/2));
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        self.imageView.layer.bounds = CGRectMake(0, 0, startFrame.size.width, startFrame.size.height);
    } else {
        self.imageView.layer.bounds = CGRectMake(0, 0, startFrame.size.height, startFrame.size.width);
    }
    
    if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        self.imageView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        self.imageView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
    } else {
        self.imageView.layer.transform = CATransform3DIdentity;
    }
    [window addSubview:self.imageView];
    self.imageView.layer.backgroundColor = [[UIColor blackColor] CGColor];
    
    self.fromOrientation = self.interfaceOrientation;
    self.toOrientation = self.presentingViewController.interfaceOrientation;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = [app keyWindow];
    
    CGRect endFrame = [self.liftedImageView.superview convertRect:self.liftedImageView.frame toView:window];
    CABasicAnimation *center = [CABasicAnimation animationWithKeyPath:@"position"];
    center.fromValue = [NSValue valueWithCGPoint:self.imageView.layer.position];
    center.toValue = [NSValue valueWithCGPoint:CGPointMake(endFrame.origin.x + floorf(endFrame.size.width/2), endFrame.origin.y + floorf(endFrame.size.height/2))];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"bounds"];
    scale.fromValue = [NSValue valueWithCGRect:self.imageView.layer.bounds];
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotate.fromValue = [NSValue valueWithCATransform3D:self.imageView.layer.transform];
    
    UIInterfaceOrientation from = self.fromOrientation;
    UIInterfaceOrientation to = self.toOrientation;
    
    if (UIInterfaceOrientationIsPortrait(to)) {
        scale.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, endFrame.size.width, endFrame.size.height)];
    } else {
        scale.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, endFrame.size.height, endFrame.size.width)];
    }
    
    NSInteger factor = RadianDifference(from, to);
    rotate.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.imageView.layer.transform, factor*M_PI_2, 0, 0, 1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.duration = kAnimationDuration;
    group.delegate = self;
    group.animations = @[scale,rotate,center];
    [group setValue:@"contract" forKey:@"type"];
    self.imageView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    self.imageView.layer.position = [center.toValue CGPointValue];
    self.imageView.layer.bounds = [scale.toValue CGRectValue];
    self.imageView.layer.transform = [rotate.toValue CATransform3DValue];
    [self.imageView.layer addAnimation:group forKey:nil];
}

#pragma mark - Private Methods

- (void) onDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Orientation

- (NSUInteger) supportedInterfaceOrientations {
    return self.supportedOrientations;
}


- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"type"] isEqual:@"contract"]) {
        self.liftedImageView.hidden = NO;
        [self.imageView removeFromSuperview];
    } else if ([[anim valueForKey:@"type"] isEqual:@"expand"]){
        
        
        CGRect frame =  self.view.bounds;
        for (int i= 0; i< self.thumbArray.count;i++)
        {
            JWScrollPhotoView* image = [[JWScrollPhotoView alloc]initWithFrame:frame];
            UIImageView* thumb = [self.thumbArray objectAtIndex:i];
            image.imageView.image = thumb.image;
            thumb.tag = i+1;
            if (i<self.imageUrlArr.count) {
               image.imageUrl =[NSURL URLWithString:[self.imageUrlArr objectAtIndex:i]];
            }
            image.contentMode = UIViewContentModeScaleAspectFit;
            image.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
            image.backgroundColor = [UIColor clearColor];
            [self.scrollView addSubview:image];
            
            [scrollImageArr addObject:image];
            frame.origin.x = frame.origin.x + frame.size.width;
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onDismiss)];
            [image addGestureRecognizer:tap];
            image.userInteractionEnabled = YES;
            
        }
        
        
        currentNum = self.liftedImageView.tag -1;
        self.scrollView.contentOffset = CGPointMake((self.liftedImageView.tag-1)*CGRectGetWidth(self.scrollView.frame), 0);
        
        self.imageView.layer.position = CGPointMake(self.scrollView.frame.origin.x + floorf(self.scrollView.frame.size.width/2), self.scrollView.frame.origin.y + floorf(self.scrollView.frame.size.height/2));
        self.imageView.layer.bounds = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        self.imageView.layer.transform = CATransform3DIdentity;
        [self.imageView removeFromSuperview];
        JWScrollPhotoView* currentImageView = [scrollImageArr objectAtIndex:(self.liftedImageView.tag-1)];
        [currentImageView startLoadImage];
        self.imageView = currentImageView.imageView;
        [self.imageView sizeThatFits:self.imageView.bounds.size];
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    JWScrollPhotoView* lastView = [scrollImageArr objectAtIndex:currentNum];
    [lastView setZoomScale:1.0 animated:YES];
    
    currentNum = scrollView.contentOffset.x/scrollView.frame.size.width;
    JWScrollPhotoView* currentImageView = [scrollImageArr objectAtIndex:currentNum];
    [currentImageView startLoadImage];
    
    self.imageView = currentImageView.imageView;
    self.liftedImageView = [self.thumbArray objectAtIndex:currentNum];
    
    
    
}

- (void)dealloc
{
    _scrollView = nil;
    _imageView = nil;
    thumbArray = nil;
    imageUrlArr = nil;
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
