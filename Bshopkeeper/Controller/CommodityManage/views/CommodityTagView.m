//
//  CommodityTagView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CommodityTagView.h"
#import "Configurations.h"

@interface CommodityTagView ()
{
    UILabel *titleLabel;
    UIView  *leftView;
    NSMutableArray *currentSelectedArray;
    NSMutableArray *allBtns;
    UIColor *currentColor;
    UIView *lineView;
    NSMutableArray *allTitles;  //所有的标签
}
@end

@implementation CommodityTagView

/*
 *@根据数据初始化
 **/
- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSDictionary *)sourceDict andCurrentSelectedArray:(NSMutableArray *)selectedArray withLeftColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        _tagCount = 10;
        currentSelectedArray = selectedArray;
        NSString *title = sourceDict?sourceDict[@"type"]:@"";
        NSArray *tempArray = [sourceDict objectForKey:@"list"];
        
        currentColor = color;
        leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/6+10, frame.size.height)];
        [self addSubview:leftView];
        
        titleLabel = [UILabel labelWithFrame:CGRectMake(5, 0, SCREENWIDTH/6-5, 40) fontSize:14 fontColor:[UIColor whiteColor] text:title];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        
        if (tempArray.count >=1) {
            allTitles = [NSMutableArray arrayWithArray:tempArray];
            int count = (int)tempArray.count;
            float self_width = frame.size.width;
            allBtns = [NSMutableArray array];
            for (int i = 0; i < count; i++) {
                UIButton *lastBtn = [allBtns lastObject];

                if (lastBtn) {
                    NSString *title1 = tempArray[i];
                    float t_width = [self getSizeWithString:title1 withfont:14];
                    float point_y =  lastBtn.top;
                    float point_x =  lastBtn.right + 10;
                    if (point_x + t_width + 10 > self_width ) {
                        point_x = 10+SCREENWIDTH/6;
                        point_y = lastBtn.bottom + 10;
                    }
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(point_x, point_y, t_width, 30);
                    [button setTitle:title1 forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    button.titleLabel.font = [UIFont systemFontOfSize:14];
                    button.layer.borderColor = TAGSCOLORTHREE.CGColor;
                    button.layer.borderWidth = 0.5;
                    button.tag = i;
                    [button addTarget:self action:@selector(clickTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    button.layer.cornerRadius = 5;
                    [self addSubview:button];
                    [allBtns addObject:button];
                    if ([selectedArray containsObject:title1]) {
                        button.selected = YES;
                        button.backgroundColor = TAGSCOLORTHREE;
                    }
                    
                }else{
                    NSString *title1 = tempArray[i];
                    float t_width = [self getSizeWithString:title1 withfont:14];
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(10+SCREENWIDTH/6, 10, t_width, 30);
                    [button setTitle:title1 forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    button.titleLabel.font = [UIFont systemFontOfSize:14];
                    button.layer.borderColor = TAGSCOLORTHREE.CGColor;
                    button.layer.borderWidth = 0.5;

                    button.tag = i;
                    [button addTarget:self action:@selector(clickTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    button.layer.cornerRadius = 5;
                    [self addSubview:button];
                    [allBtns addObject:button];
                    if ([selectedArray containsObject:title1]) {
                        button.selected = YES;
                        button.backgroundColor = TAGSCOLORTHREE;
                    }
                }
            }
        }
        UIButton *lastBtn = [allBtns lastObject];
        if (lastBtn) {
            CGRect beforeFrome = frame;
            beforeFrome.size.height = lastBtn.bottom+10;
            self.frame = beforeFrome;
            leftView.height = beforeFrome.size.height;
            titleLabel.frame = CGRectMake(5, self.height/2-15, SCREENWIDTH/6-5, 30);
            leftView.layer.cornerRadius = 5;
            leftView.layer.backgroundColor = color.CGColor;
        }
        lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/6, 0, 10, self.height)];
        lineView.backgroundColor= [UIColor whiteColor];
        [self addSubview:lineView];
        self.layer.cornerRadius = 10;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

- (float)getSizeWithString:(NSString *)contentString withfont:(float)sizeFont
{
    float sizeOfWhide = 0 ;
    if (IS_IOS7) {
         sizeOfWhide = [contentString boundingRectWithSize:CGSizeMake(200, 40) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:sizeFont]} context:nil].size.width;
    }else{
        sizeOfWhide = [contentString sizeWithFont:[UIFont systemFontOfSize:sizeFont] constrainedToSize:CGSizeMake(200, 40) lineBreakMode:NSLineBreakByWordWrapping].width;
       
    }
    return sizeOfWhide + 40;
    
}


#pragma mark --------------------------------- 选择标签
- (void)clickTypeBtnAction:(UIButton *)sender
{
    
    if (sender.selected == YES) {
        sender.selected = NO;
        sender.backgroundColor = [UIColor whiteColor];
        if ([currentSelectedArray containsObject:sender.titleLabel.text]) {
            [currentSelectedArray removeObject:sender.titleLabel.text];
        }
        
        
    }else{
        if (currentSelectedArray.count >=_tagCount) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"标签个数只能选择%d个哦",_tagCount]];
            return;
        }
        
        if (![currentSelectedArray containsObject:sender.titleLabel.text]) {
            [currentSelectedArray addObject:sender.titleLabel.text];
        }
        sender.selected = YES;
        sender.backgroundColor = TAGSCOLORTHREE;
    }
}

/*
 *检索数据
 */
- (NSArray *)checkingDataFromeArray:(NSArray *)array
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
    for (int i = 0 ; i< array.count; i++) {
        NSString *nowTitle = [array objectAtIndex: i];
        if ([allTitles containsObject:nowTitle]) {
            if ([tempArray containsObject:nowTitle]) {
                [tempArray removeObject:nowTitle];
            }
        }
    }
    return tempArray;
}


/*
 *新建标签
 */
- (void)addTag:(NSString *)fromStr
{
    UIButton *lastBtn = [allBtns lastObject];
    float t_width = [self getSizeWithString:fromStr withfont:14];
    float point_y =  lastBtn.top;
    float point_x =  lastBtn.right + 10;
    if (point_x + t_width + 10 > self.width ) {
        point_x = 10+SCREENWIDTH/6;
        point_y = lastBtn.bottom + 10;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(point_x, point_y, t_width, 30);
    [button setTitle:fromStr forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.borderColor = TAGSCOLORTHREE.CGColor;
    button.layer.borderWidth = 0.5;
    button.tag = allBtns.count -1;
    [button addTarget:self action:@selector(clickTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    [self addSubview:button];
    [allBtns addObject:button];
    [allTitles addObject:fromStr];
    
    if (button) {
        CGRect beforeFrome = self.frame;
        beforeFrome.size.height = button.bottom+10;
        self.frame = beforeFrome;
        leftView.height = beforeFrome.size.height;
        titleLabel.frame = CGRectMake(5, self.height/2-15, SCREENWIDTH/6, 30);
        leftView.layer.cornerRadius = 5;
        leftView.layer.backgroundColor = currentColor.CGColor;
        lineView.frame = CGRectMake(SCREENWIDTH/6, 0, 10, self.height);
    }
    [self clickTypeBtnAction:button];
}


- (BOOL)WhetherTheLabelAlreadyExists:(NSString *)fromStr
{
    return [allTitles containsObject:fromStr];
}

/*
 *获取所有标签
 */
- (NSArray *)getAllTitles
{
    return allTitles;
}

/*设置选中
 */
- (void)setSelected:(NSString *)tagStr
{
    if ([allTitles containsObject:tagStr]) {
        int index  =[allTitles indexOfObject:tagStr];
        UIButton *button = [allBtns objectAtIndex:index];
        [self clickTypeBtnAction:button];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
