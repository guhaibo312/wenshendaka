//
//  SquareInfoDetailHead.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/3.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SquareInfoDetailHead.h"
#import "PhotoWallView.h"
#import "UIViewExt.h"
#import "Configurations.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"
#import "SquareCommentCell.h"
#import "SquareUserPageViewController.h"
#import "H5PreviewManageViewController.h"
#import "SquareURLView.h"


@interface SquareInfoDetailHead()<UIActionSheetDelegate>
{
    UIImageView *headImageView;
    
    UILabel *userNameLabel;
    UILabel *releaseLabel;
    UILabel *fromLabel;
    UILabel *contentLabel;
    
    PhotoWallView *photoWall;
    SquareInfoDetailTag *tagView;
    SquareURLView *urlView;

    BOOL isMyReleased;
}

@property (nonatomic, assign) UIViewController *supVC;
@property (nonatomic, strong) SquareDataItem *dataItem;

@end

@implementation SquareInfoDetailHead


- (instancetype)initWithSquareItem:(SquareDataItem *)item ownerController:(UIViewController *)ownerVC
{
    self = [super init];
    if (self) {
        _supVC = nil;
        _supVC = ownerVC;
        
        isMyReleased = NO;
        
        //头像
        headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 48, 48)];
        headImageView.clipsToBounds = YES;
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.layer.borderWidth = 1;
        headImageView.layer.borderColor = LINECOLOR.CGColor;
        headImageView.layer.cornerRadius = 24;
        headImageView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
        UITapGestureRecognizer  * tapHead = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickpushToUserPageFunction:)];
        [headImageView addGestureRecognizer:tapHead];
        headImageView.userInteractionEnabled = YES;
        [self addSubview:headImageView];
        
        //昵称
        userNameLabel = [UILabel labelWithFrame:CGRectMake(headImageView.right+10, 12, 200, 22) fontSize:16 fontColor:SquareLinkColor text:@""];
        
        UITapGestureRecognizer *tapName = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickpushToUserPageFunction:)];
        [userNameLabel addGestureRecognizer:tapName];
        userNameLabel.userInteractionEnabled = YES;
        [self addSubview:userNameLabel];
        
        //发布时间
        releaseLabel = [UILabel labelWithFrame:CGRectMake(headImageView.right+10, 34, 60,18 ) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
        [self addSubview:releaseLabel];
        
        //来自
        fromLabel = [UILabel labelWithFrame:CGRectMake(releaseLabel.right, 34, SCREENWIDTH-releaseLabel.right-10, 18) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
        [self addSubview:fromLabel];
        
        
        
        //内容
        contentLabel = [UILabel labelWithFrame:CGRectMake(26, headImageView.bottom+10, SCREENWIDTH-52, 1000) fontSize:16 fontColor:[UIColor blackColor] text:@""];
        [self addSubview:contentLabel];
        contentLabel.numberOfLines = 0;
        
        //图片墙
        photoWall = [[PhotoWallView alloc]initWithFrame:CGRectMake(26, contentLabel.bottom, SCREENWIDTH-52, 100)];
        [self addSubview:photoWall];
        
        //链接
        urlView = [[SquareURLView alloc]initWithFrame:CGRectMake(26, contentLabel.bottom, SCREENWIDTH-52, 64)];
        [urlView addTarget:self action:@selector(pushToH5Preview:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:urlView];
        urlView.hidden = YES;
        
        //标签
        tagView = [[SquareInfoDetailTag alloc]initWithFrame:CGRectMake(0, photoWall.bottom+10, SCREENWIDTH, 40) withTag:nil];
        [self addSubview:tagView];
        
        self.height = tagView.bottom+5;
        
        [self setValueForViews:item];
    }
    return self;
}

- (UIImage *)getHeadImg
{
    return headImageView.image;
}

- (void)setValueForViews:(SquareDataItem *)item
{
    if (!self || !item) return;
    _dataItem = item;
    if (item) {
        if (item.userInfo) {
            if (item.userInfo[@"avatar"]) {
                headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
                [headImageView sd_setImageWithURL:[NSURL URLWithString:item.userInfo[@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon_userHead_default.png"]];
            }
        }
    
    }
    if (item) {
        if (item.userInfo) {
            userNameLabel.text = item.userInfo[@"nickname"];
        }
    }
    if (item) {
        if (item.create_time) {
            double createtime = [item.create_time doubleValue];
            
            if (createtime >9999999999) {
                createtime = createtime/1000;
            }
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:createtime];
            releaseLabel.text = [NSString stringWithDate:date];
        }
        
    }
//    fromLabel.text = item.from;

    
    if ([NSObject nulldata:item.content ]) {
        contentLabel.text = item.content;
        contentLabel.height = [item.content sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(SCREENWIDTH-52, 2000)].height+20;
    }else{
        contentLabel.height = 0;
    }

//    if (item.type == 3) {
//        
//        urlView.frame = CGRectMake(26, contentLabel.bottom, SCREENWIDTH-52, 64);
//        NSString *imgUrl = nil;
//        if (item.image_urls) {
//            imgUrl = [item.image_urls firstObject];
//        }
//        [urlView setImageValue:imgUrl title:item.title];
//        urlView.hidden = NO;
//        photoWall.hidden = YES;
//        tagView.frame = CGRectMake(0, urlView.bottom+10, SCREENWIDTH, 40);
//        [tagView setTagStr:item.tag];
//        self.height = tagView.bottom+5;
//        return;
//        
//    }else{
        urlView.hidden = YES;
        photoWall.hidden = NO;
        photoWall.frame = CGRectMake(26, contentLabel.bottom, SCREENWIDTH-52, 100);
        [photoWall setAllImageWithArray:item.image_urls];
        
        tagView.frame = CGRectMake(0, photoWall.bottom+10, SCREENWIDTH, 40);
        [tagView setTagStr:item.tag];
        self.height = tagView.bottom+5;
//    }
    
    
}


#pragma mark ---------------------------- 跳入个人信息---------------------------------------

- (void)clickpushToUserPageFunction:(id)sender
{
    if (!_dataItem) {
        return;
    }
    SquareUserPageViewController *userPageVC = [[SquareUserPageViewController alloc]initWithQuery:@{@"userId":[NSString stringWithFormat:@"%@",_dataItem.userInfo[@"userId"]]}];
    [_supVC.navigationController pushViewController:userPageVC animated:YES];
}

#pragma mark --------------------------- 预览----------------------------------------------
-(void)pushToH5Preview:(id)sender
{
    if (!_supVC ) return;
    
    H5PreviewManageViewController *h5manageVC = [[H5PreviewManageViewController alloc]initWithQuery:@{@"urlStr":_dataItem.url?_dataItem.url:@""}];
    [_supVC.navigationController pushViewController:h5manageVC animated:YES];

}


@end



@implementation SquareInfoDetailTag

- (instancetype)initWithFrame:(CGRect)frame withTag:(NSString *)tagStr
{
    self = [super initWithFrame:frame];
    if (self) {
        tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(40, 8, self.width-40-10, 24)];
        tagScrollView.backgroundColor = [UIColor clearColor];
        tagScrollView.userInteractionEnabled = NO;
        tagScrollView.showsHorizontalScrollIndicator = NO;
        tagScrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:tagScrollView];
        
        if (![NSObject nulldata:tagStr ]) {
            self.hidden = YES;
            self.height = 0;
            return self;
        }
      
        [self setTagStr:tagStr];
    }
    return self;
}

- (void)setTagStr:(NSString *)tagStr
{
    if (![NSObject nulldata:tagStr ]) {
        self.hidden = YES;
        self.height = 0;
        return;
    }
    if (tagScrollView) {
        if (tagScrollView.subviews) {
            [tagScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    }
    self.hidden = NO;
    leftTagView = nil;
    leftTagView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    leftTagView.backgroundColor = [UIColor clearColor];
    leftTagView.image = [UIImage imageNamed:@"icon_square_tagSign.png"];
    [self addSubview:leftTagView];
    
    
    NSArray *array = [tagStr componentsSeparatedByString:@"#"];
    if (!array) {
        self.hidden = YES;
        self.height = 0;
        return ;
    }
    NSMutableArray * tags  = [NSMutableArray array];
    for (int i = 0 ; i< array.count; i++) {
        NSString *title = [array objectAtIndex:i];
        float width = [UIUtils getSizeWithString:title withfont:12]-10;
        UILabel *label = [tags lastObject];
        if (label) {
            UILabel *oneLabel = [UILabel labelWithFrame:CGRectMake(label.right +4, 0, width, 24) fontSize:12 fontColor:GRAYTEXTCOLOR text:title];
            oneLabel.layer.cornerRadius = 5;
            oneLabel.layer.borderColor = TAGSCOLORFORE.CGColor;
            oneLabel.layer.borderWidth = 0.5;
            oneLabel.textAlignment = NSTextAlignmentCenter;
            [tagScrollView addSubview:oneLabel];
            [tags addObject:oneLabel];
            
        }else{
            UILabel *oneLabel = [UILabel labelWithFrame:CGRectMake(0, 0, width, 24) fontSize:12 fontColor:GRAYTEXTCOLOR text:title];
            oneLabel.layer.cornerRadius = 5;
            oneLabel.textAlignment = NSTextAlignmentCenter;
            oneLabel.layer.borderColor = TAGSCOLORFORE.CGColor;
            oneLabel.layer.borderWidth = 0.5;
            [tagScrollView addSubview:oneLabel];
            [tags addObject:oneLabel];
        }
    }
    UILabel *label = [tags lastObject];
    tagScrollView.contentSize = CGSizeMake(label.right +10, tagScrollView.height);
}

- (void)bingClickFuncitonTarget:(id)taget action:(SEL)sel
{
    UIButton *button = [[UIButton alloc]initWithFrame:self.bounds];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:taget action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

@end


@interface ImageFeedHeadView()<UIActionSheetDelegate>
{
    UIImageView *headImageView;
    
    UILabel *contentLabel;
    
    PhotoWallView *photoWall;
    SquareInfoDetailTag *tagView;
    SquareURLView *urlView;
    
    BOOL isMyReleased;
}

@property (nonatomic, assign) UIViewController *supVC;
@property (nonatomic, strong) SquareDataItem *dataItem;

@end


@implementation ImageFeedHeadView

- (instancetype)initWithSquareItem:(SquareDataItem *)item ownerController:(UIViewController *)ownerVC
{
    self = [super init];
    if (self) {
        _supVC = nil;
        _supVC = ownerVC;
        
        isMyReleased = NO;
        
        //头像
        headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 48, 48)];
  
        
        //图片墙
        photoWall = [[PhotoWallView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
        photoWall.backgroundColor = [UIColor blackColor];
        [self addSubview:photoWall];
        
        //链接
        urlView = [[SquareURLView alloc]initWithFrame:CGRectMake(26, 0, SCREENWIDTH-52, 64)];
        [urlView addTarget:self action:@selector(pushToH5Preview:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:urlView];
        urlView.hidden = YES;

        //内容
        contentLabel = [UILabel labelWithFrame:CGRectMake(26, photoWall.bottom+10, SCREENWIDTH-52, 1000) fontSize:16 fontColor:[UIColor blackColor] text:@""];
        [self addSubview:contentLabel];
        contentLabel.numberOfLines = 0;
        
        //标签
        tagView = [[SquareInfoDetailTag alloc]initWithFrame:CGRectMake(0, contentLabel.bottom+10, SCREENWIDTH, 40) withTag:nil];
        [self addSubview:tagView];
        
        self.height = tagView.bottom+5;

        [self setValueForViews:item];
    }
    return self;
}

- (UIImage *)getHeadImg
{
    return headImageView.image;
}

- (void)setValueForViews:(SquareDataItem *)item
{
    if (!self || !item) return;
    _dataItem = item;
    if (item) {
        if (item.userInfo) {
            if (item.userInfo[@"avatar"]) {
                headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
                [headImageView sd_setImageWithURL:[NSURL URLWithString:item.userInfo[@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon_userHead_default.png"]];
            }
        }
        
    }
    
    
    if ([NSObject nulldata:item.content]) {
        contentLabel.text = item.content;
        contentLabel.height = [item.content sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(SCREENWIDTH-52, 2000)].height+20;
    }else{
        contentLabel.height = 0;
    }
    
    if (item.type == 3) {
        
        urlView.frame = CGRectMake(26, 0, SCREENWIDTH-52, 64);
        NSString *imgUrl = nil;
        if (item.image_urls) {
            imgUrl = [item.image_urls firstObject];
        }
        [urlView setImageValue:imgUrl title:item.title];
        contentLabel.frame = CGRectMake(26, urlView.bottom+10, SCREENWIDTH-52, contentLabel.height);
        urlView.hidden = NO;
        photoWall.hidden = YES;
        tagView.frame = CGRectMake(0, contentLabel.bottom+10, SCREENWIDTH, 40);
        [tagView setTagStr:item.tag];
        self.height = tagView.bottom+5;
        return;
        
    }else{
        urlView.hidden = YES;
        photoWall.hidden = NO;
        photoWall.frame = CGRectMake(0, 0, SCREENWIDTH, 100);
        [photoWall setAllImageWithArray:item.image_urls];
        [photoWall setBigImageCenter];
        contentLabel.frame = CGRectMake(26, photoWall.bottom+10, SCREENWIDTH-52, contentLabel.height);
        tagView.frame = CGRectMake(0, contentLabel.bottom+10, SCREENWIDTH, 40);
        [tagView setTagStr:item.tag];
        self.height = tagView.bottom+5;
    }
    
    
}


#pragma mark ---------------------------- 跳入个人信息---------------------------------------

- (void)clickpushToUserPageFunction:(id)sender
{
    if (!_dataItem) {
        return;
    }
    SquareUserPageViewController *userPageVC = [[SquareUserPageViewController alloc]initWithQuery:@{@"userId":[NSString stringWithFormat:@"%@",_dataItem.userInfo[@"userId"]]}];
    [_supVC.navigationController pushViewController:userPageVC animated:YES];
}

#pragma mark --------------------------- 预览----------------------------------------------
-(void)pushToH5Preview:(id)sender
{
    if (!_supVC ) return;
    
    H5PreviewManageViewController *h5manageVC = [[H5PreviewManageViewController alloc]initWithQuery:@{@"urlStr":_dataItem.url?_dataItem.url:@""}];
    [_supVC.navigationController pushViewController:h5manageVC animated:YES];
    
}


@end
