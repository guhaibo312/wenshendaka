//
//  JWCollectionViewCell.m
//  Tools
//
//  Created by jinwei on 15/5/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWCollectionViewCell.h"
#import "NSString+Extension.h"
#import "UIKit+AFNetworking.h"
#import "UIImage+JWNetImageSize.h"
#import "UIImageView+WebCache.h"
#import "NSString+BG.h"

#define spaceWidth 6

@implementation JWCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _topImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    _topImg.layer.masksToBounds = YES;
    _topImg.contentMode = UIViewContentModeScaleAspectFill;
    _topImg.clipsToBounds = YES;
    
    _topImg.backgroundColor = [UIColor whiteColor];
    
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    [self addSubview:_topImg];
    
    headImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    headImg.contentMode = UIViewContentModeScaleAspectFill;
    headImg.clipsToBounds = YES;
    headImg.layer.cornerRadius = 15;
    [self addSubview:headImg];
    
    
    nameLabel = [UILabel labelWithFrame:CGRectZero fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
    [self addSubview:nameLabel];
    
//    vImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-33-85, 50, 18, 16)];
//    vImageView.image = [UIImage imageNamed:@"icon_mine_v.png"];
//    [self.contentView addSubview:vImageView];
}

- (void)setDataItem:(JWCollectionItem *)dataItem withColor:(UIColor *)color
{
    if (dataItem == nil) return;
    ownerItem = dataItem;
    
    float imgHeight = dataItem.firstImgSize.height/fabsf(dataItem.firstImgSize.width/(SCREENWIDTH/2-2*spaceWidth));

    
    _topImg.frame = CGRectMake(0, 0,SCREENWIDTH/2-2*spaceWidth,imgHeight);
    if (dataItem.image_urls) {
        NSString *imgUrl = [dataItem.image_urls firstObject];
        if (imgUrl) {
            [_topImg sd_setImageWithURL:[NSURL URLWithString:[imgUrl getQiNiuThunbImage]] placeholderImage:[UIUtils imageFromColor:color?color:[UIColor grayColor]]];
        }

    }
    
    if (dataItem.userInfo) {
        if ([NSObject nulldata:dataItem.userInfo[@"avatar"]]) {
            [headImg sd_setImageWithURL:[NSURL URLWithString:dataItem.userInfo[@"avatar"]]];
        }else{
            headImg.image = [UIImage imageNamed:@"icon_userHead_default.png"];
        }
        if ([NSObject nulldata:dataItem.userInfo[@"nickname"]]) {
            nameLabel.text = dataItem.userInfo[@"nickname"];
        }
    }
    headImg.frame = CGRectMake(15, _topImg.bottom+7, 30, 30);
    nameLabel.frame = CGRectMake(headImg.right+10, _topImg.bottom+7, 100, 30);
}



@end

@implementation JWUserPageCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _topImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    _topImg.layer.masksToBounds = YES;
    _topImg.contentMode = UIViewContentModeScaleAspectFill;
    _topImg.clipsToBounds = YES;
    
    _topImg.backgroundColor = [UIColor whiteColor];
    
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    [self addSubview:_topImg];
   
    
    countLabel = [UILabel labelWithFrame:CGRectZero fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
    countLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:countLabel];
}

- (void)setDataItem:(JWCollectionItem *)dataItem withColor:(UIColor *)color
{
    if (dataItem == nil) return;
    ownerItem = dataItem;
    
    float imgHeight = dataItem.firstImgSize.height/fabsf(dataItem.firstImgSize.width/(SCREENWIDTH/2-2*spaceWidth));
    
    
    _topImg.frame = CGRectMake(0, 0,SCREENWIDTH/2-2*spaceWidth,imgHeight);
    NSString *imgUrl = [dataItem.image_urls firstObject];
    if (imgUrl) {
        [_topImg sd_setImageWithURL:[NSURL URLWithString:[imgUrl getQiNiuThunbImage]] placeholderImage:[UIUtils imageFromColor:color?color:[UIColor grayColor]]];
    }
    
    countLabel.frame = CGRectMake(20, _topImg.bottom, SCREENWIDTH/2-spaceWidth*2-40, 20);
    countLabel.text = [NSString stringWithFormat:@"%d张",dataItem.image_urls.count];
}



@end

@implementation JWCollectionItem


- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
        if (!self.image_urls || self.image_urls == NULL || ![self.image_urls isKindOfClass:[NSArray class]]) {
            self.image_urls = [NSArray array];
        }
        
        NSString *firstImgURL = [self.image_urls firstObject];
        _firstImgSize = CGSizeMake(SCREENWIDTH/2-spaceWidth*2,(SCREENWIDTH/2-spaceWidth*2)/2*3 );
        _firstImgSize = [firstImgURL imageUrlSizeWithTheOriginalSize:_firstImgSize];
        [self getDataSizeHeight];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)getDataSizeHeight
{
    
    float scale_h = fabs(_firstImgSize.width/(SCREENWIDTH/2-2*spaceWidth));
    
    float imgHeight =_firstImgSize.height/scale_h;

    _userPageSize = CGSizeMake(SCREENWIDTH/2, imgHeight + 20) ;

    _squareListSize = CGSizeMake(SCREENWIDTH/2,imgHeight +44);
    
}

@end