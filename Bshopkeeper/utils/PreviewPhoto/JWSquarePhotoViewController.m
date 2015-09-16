//
//  JWSquarePhotoViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/5/23.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWSquarePhotoViewController.h"
#import "JWScrollPhotoView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"


@interface JWSquarePhotoViewController ()<UIScrollViewDelegate>
{
    UIScrollView *backScrollView;
    int currentIndex;
}

@end

@implementation JWSquarePhotoViewController

- (instancetype)initWithImgs:(NSArray *)list withCurrentIndex:(int)index
{
    self = [super init];
    if (self) {
        currentIndex = index;
        if (list) {
            _imageUrls = [NSMutableArray arrayWithArray:list];
        }else{
            _imageUrls = [NSMutableArray array];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    backScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    backScrollView.delegate = self;
    backScrollView.backgroundColor = [UIColor blackColor];
    backScrollView.pagingEnabled = YES;
    backScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*[self.imageUrls count], CGRectGetHeight(self.view.frame));
    backScrollView.autoresizingMask = self.view.autoresizingMask;
    [self.view addSubview:backScrollView];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    if (currentIndex== 0 ||currentIndex>self.imageUrls.count) {
        currentIndex = 1;
    }
    for (int i= 0; i< self.imageUrls.count;i++)
    {
        JWScrollPhotoView* image = [[JWScrollPhotoView alloc]initWithFrame:CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, SCREENHEIGHT)];
        
        NSString *imageUrl = [self.imageUrls objectAtIndex:i];
        
        if (imageUrl) {
            imageUrl =  [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [image setimageWith:[NSURL URLWithString:imageUrl]];
        }
        image.tag = 101+i;
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        image.backgroundColor = [UIColor clearColor];
        [backScrollView addSubview:image];

        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onDismiss)];
        [image addGestureRecognizer:tap];
        image.userInteractionEnabled = YES;
        
    }
    self.pageLabel = [UILabel labelWithFrame:CGRectMake(20, 40, SCREENWIDTH-40, 24) fontSize:18 fontColor:[UIColor whiteColor] text:@""];
    self.pageLabel.textAlignment = NSTextAlignmentRight;
    self.pageLabel.backgroundColor = [UIColor clearColor];
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%d",1,_imageUrls.count];
    [self.view addSubview:self.pageLabel];
    
    _downLoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-60, SCREENHEIGHT-60, 40, 40)];
    _downLoadBtn.backgroundColor = [UIColor clearColor];
    [_downLoadBtn setImage:[UIImage imageNamed:@"icon_downLoad_img.png"] forState:UIControlStateNormal];
    _downLoadBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [_downLoadBtn addTarget:self action:@selector(clickDownLoadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_downLoadBtn];
    
    
    backScrollView.contentOffset = CGPointMake((currentIndex-1)*backScrollView.width, 0);
    

}

- (void)clickDownLoadBtnAction:(id)sender
{
    
    JWScrollPhotoView* image  = (JWScrollPhotoView *)[backScrollView viewWithTag:100+currentIndex];
    if (!image)return;
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    [assetsLibrary writeImageToSavedPhotosAlbum:[image.imageView.image CGImage] orientation:(ALAssetOrientation)image.imageView.image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
    }];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
   currentIndex = scrollView.contentOffset.x/SCREENWIDTH + 1;
   if (currentIndex != 0) {
        self.pageLabel.text = [NSString stringWithFormat:@"%d/%d",currentIndex,_imageUrls.count];

    }

}

- (void)dealloc{
    _imageUrls = nil;
    _downLoadBtn = nil;
}

- (void) onDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
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
