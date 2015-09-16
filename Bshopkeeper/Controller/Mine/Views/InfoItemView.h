//
//  InfoItemView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/7/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoItemView : UIView
{
    UIImageView *leftImg;
    UIImageView *pointImg;
    UILabel *messageLabel;
    UILabel *titleLabel;
    UIButton *actionBtn;
}

@property (nonatomic, strong)     UILabel *detailLabel;
@property (nonatomic, strong) NSString *controlDes;

- (instancetype)initWithFrame:(CGRect)frame Img:(UIImage *)img titleString:(NSString *)title detailInfo:(NSString *)detailStr;
- (void)setAction:(SEL)action target:(id)sender;

- (void)setMessageCount:(int)count;

@end

@interface InfoItemViewItem : NSObject

@property (nonatomic, strong) UIImage *iconImg;

@property (nonatomic, strong) NSString *itemTitle;

@property (nonatomic, strong) NSString *DesController;

@property (nonatomic, strong) NSString *detailTitle;


@end

@interface InfoItemViewItemCell : UITableViewCell

@property (nonatomic, strong)InfoItemView *infoView;

- (void)setInfoValue:(InfoItemViewItem *)item;

@end
