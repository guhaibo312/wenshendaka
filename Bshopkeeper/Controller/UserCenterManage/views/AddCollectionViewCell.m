//
//  AddCollectionViewCell.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "AddCollectionViewCell.h"
#import "Configurations.h"

@implementation AddCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    if (self) {
        addImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        addImageView.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 2;
        self.layer.borderColor = TAGSCOLORFORE.CGColor;
        [self addSubview:addImageView];
        
        addPromptLabel = [UILabel labelWithFrame:CGRectZero fontSize:16 fontColor:RGBCOLOR_HEX(0x1a1a1a) text:@""];
        addPromptLabel.textAlignment = NSTextAlignmentCenter;
        addPromptLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:addPromptLabel];
        self.backgroundColor = TAGBODLECOLOR;
        
    }
    return self;
}

- (void)loadWithTitle:(NSString *)title
{
    addImageView.frame = CGRectMake((SCREENWIDTH/2-12)/2-25,(SCREENWIDTH/2-12)/2-35 , 50, 50);
    addImageView.image = [UIImage imageNamed:@"icon_userpage_add.png"];
    addPromptLabel.frame =  CGRectMake(0, addImageView.bottom+15, SCREENWIDTH/2-12, 20);
    addPromptLabel.text = title;
}

@end
