//
//  JWPluginBoardView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWPluginBoardView.h"
#import "UserHomeBtn.h"
#import "Configurations.h"


@class JWPluginBoardItem;


@implementation JWPluginBoardView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *items = [[NSMutableArray alloc]init];

        JWPluginBoardItem *first = [[JWPluginBoardItem alloc]initWithDict:@{@"imageNamed":@"icon_chat_input_photo",@"titleString":@"相册"}];
        [items addObject:first];
        
        JWPluginBoardItem *second = [[JWPluginBoardItem alloc]initWithDict:@{@"imageNamed":@"icon_chat_input_cam",@"titleString":@"拍照"}];
        [items addObject:second];
        

        for (int i = 0 ; i< items.count; i++) {
            JWPluginBoardItem *item = [items objectAtIndex:i];
            CGRect itemFrame = CGRectMake(10+(i%4)*(SCREENWIDTH-20)/4,18+(i/4*((frame.size.height-36)/2)), (SCREENWIDTH-20)/4, (frame.size.height-36)/2);
            UserHomeBtn *onePluginBoardView = [[UserHomeBtn alloc]initWithFrame:itemFrame text:item.titleString imageName:item.imageNamed];
            onePluginBoardView.desIamgeView.frame = CGRectMake(onePluginBoardView.width/2-15, onePluginBoardView.height/2-20, 30, 30);
            onePluginBoardView.nameLabel.font = [UIFont systemFontOfSize:14];
            onePluginBoardView.nameLabel.textColor = [UIColor blackColor];
            onePluginBoardView.nameLabel.textAlignment = NSTextAlignmentCenter;
            onePluginBoardView.tag = i+10;
            [onePluginBoardView setBackgroundImage:[UIUtils imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [onePluginBoardView addTarget:self action:@selector(clickItemAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:onePluginBoardView];
            onePluginBoardView.userInteractionEnabled = YES;
            self.backgroundColor = VIEWBACKGROUNDCOLOR;
            self.showsHorizontalScrollIndicator = NO;
            self.showsVerticalScrollIndicator = NO;
        }
    }
    return self;
}


- (void)clickItemAction:(UserHomeBtn *)sender
{
    int index = sender.tag-10;
    if (_actionBlock) {
        _actionBlock(index);
    }
}


@end

@implementation JWPluginBoardItem

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}


@end