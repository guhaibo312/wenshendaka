//
//  JWSquarePhotoAndTextViewController.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWSquarePhotoAndTextViewController.h"

@interface JWSquarePhotoAndTextViewController ()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIPageControl *pageVc;

@property (nonatomic,assign) int currentIndex;

@end

@implementation JWSquarePhotoAndTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTitle];
    [self setUpPageVc];
    self.downLoadBtn.hidden = YES;
    
    
}

- (void)setUpTitle
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.height - 60, self.view.width - 20, 60)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = self.titleText;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.titleLabel];
}

- (void)setUpPageVc
{
    self.pageVc = [[UIPageControl alloc] init];
    self.pageVc.width = 100;
    self.pageVc.height = 30;
    self.pageVc.x = self.view.width - self.pageVc.width - 10;
    self.pageVc.y = self.view.height - self.titleLabel.height - 25;
    self.pageVc.numberOfPages = self.imageUrls.count;
    [self.view addSubview:self.pageVc];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentIndex = (int)scrollView.contentOffset.x / SCREENWIDTH + 0.5;
    self.pageVc.currentPage = self.currentIndex;
    
    self.currentIndex = scrollView.contentOffset.x/SCREENWIDTH + 1;
    if (self.currentIndex != 0) {
        self.pageLabel.text = [NSString stringWithFormat:@"%d/%lu",self.currentIndex,(unsigned long)self.imageUrls.count];
        
    }
}

@end
