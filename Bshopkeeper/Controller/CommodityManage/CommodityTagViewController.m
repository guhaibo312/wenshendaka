//
//  CommodityTagViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CommodityTagViewController.h"
#import "CreateTagViewController.h"
#import "CommodityTagView.h"
#import "UserHomeBtn.h"
#import "NSString+BG.h"

@interface CommodityTagViewController ()<CreateTagDelegate>
{
    NSMutableArray *selectedArray;          //当前选择的Array;
    NSMutableArray *commodityTagViews;      //当前的视图数组
    UIScrollView *backScrollView;           //滑动的背景
    CommodityTagView *customerTag;          //自定义
    
    UserHomeBtn * addTagBtn;
}
@property (nonatomic, assign) BOOL showSquareTag;

@end

@implementation CommodityTagViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
        
            selectedArray = [NSMutableArray arrayWithArray:query[@"item"]];
            if (!selectedArray) {
                selectedArray =  [NSMutableArray array];
            }
            if ([query.allKeys containsObject:@"square"]) {
                _showSquareTag = [query[@"square"] boolValue];
            }else{
                _showSquareTag = NO;
            }
            if ([query.allKeys containsObject:@"tagcount"]) {
                _tagCount = [query[@"tagcount"] intValue];
            }else{
                _tagCount = 10;
            }
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择标签";
    // Do any additional setup after loading the view.
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"category" ofType:@"json"];
    NSError *error = nil;
    NSDictionary * AdataTemp = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:file ] options:kNilOptions error:&error];
    NSMutableArray *currentDataArray = [NSMutableArray array];
    
    [self setRightNavigationBarTitle:@"完成" color:[UIColor whiteColor] fontSize:14 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
    
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT- 64)];
    backScrollView.backgroundColor = VIEWBACKGROUNDCOLOR;
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:backScrollView];
    
    
    if (AdataTemp ) {
        NSString *key = @"tattooCategories";
        NSDictionary *currentDate = [AdataTemp objectForKey:key];
        NSArray *keyArray = [currentDate allKeys];
        NSArray *result;
        if (keyArray) {
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
            result = [keyArray sortedArrayUsingDescriptors:@[sortDescriptor]];
        }
        
        for (NSString *temKey in result) {
            [currentDataArray addObject:currentDate[temKey]];
        }
    }
    
    float point_y = 0 ;
    commodityTagViews = [NSMutableArray array];
    
    NSArray *colorArrays = @[TAGSCOLORONE,TAGSCOLORTWO,TAGSCOLORTHREE,TAGSCOLORFORE,TAGSCOLORONE];
    for (int i = 0; i< currentDataArray.count; i++) {
        NSDictionary *oneDict = currentDataArray[i];
        if ([oneDict objectForKey:@"type"]) {
            if ([oneDict[@"type"] isEqualToString:@"圈子"] && !_showSquareTag) {
                continue;
            }
        }
        CommodityTagView *lastView = (CommodityTagView *)[commodityTagViews lastObject];
        if (lastView) {
            point_y = lastView.bottom + 10;
        }else{
            point_y = 10;
        }
        CommodityTagView *tempView = [[CommodityTagView alloc]initWithFrame:CGRectMake(10, point_y, SCREENWIDTH- 20, 100) withDataArray:oneDict andCurrentSelectedArray:selectedArray withLeftColor:colorArrays[i]];
        [backScrollView addSubview:tempView];
        tempView.tagCount = _tagCount;
        [commodityTagViews addObject:tempView];
    }
    
    //添加标签
    [self newCreatedCustomView:nil];
    
    CommodityTagView *lastView = [commodityTagViews lastObject];
    addTagBtn = [UserHomeBtn buttonWithFrame:CGRectMake(SCREENWIDTH/3-20, lastView.bottom+10, SCREENWIDTH/3+40, 40) text:@"新建标签" imageName:@"icon_add_tag.png"];
    addTagBtn.tag = 599;
    addTagBtn.desIamgeView.frame = CGRectMake(addTagBtn.width/2-50 , (addTagBtn.height-30)/2, 30, 30);
    addTagBtn.nameLabel.frame = CGRectMake(addTagBtn.desIamgeView.right+10, 0, addTagBtn.width- addTagBtn.desIamgeView.right +10, 40);
    addTagBtn.nameLabel.textColor = GRAYTEXTCOLOR;
    addTagBtn.nameLabel.textAlignment = NSTextAlignmentLeft;
    [addTagBtn setBackgroundImage:[UIUtils imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [addTagBtn setBackgroundImage:[UIUtils imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [addTagBtn addTarget:self action:@selector(clickAddTagBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:addTagBtn];
    backScrollView.contentSize = CGSizeMake(SCREENWIDTH, addTagBtn.bottom +10);
    
}

#pragma mark ---------------------------------- 点击添加标签

- (void)clickAddTagBtnAction:(UserHomeBtn *)sender
{
    CreateTagViewController *newTagVC  = [[CreateTagViewController alloc]init];
    newTagVC.delegate = self;
    [self.navigationController pushViewController:newTagVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------------------------------  点击完成
- (void)rightNavigationBarAction:(UIButton *)sender
{
    if (_chooseTagDelegate && [_chooseTagDelegate respondsToSelector:@selector(theLabelIsCompleteFromArray:)]) {
        [_chooseTagDelegate theLabelIsCompleteFromArray:selectedArray];
    }
    if (customerTag) {
         NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:[NSString stringWithFormat:@"CustomTags%@",[User defaultUser].item.userId]];
       
        if ([customerTag getAllTitles]) {
           BOOL result =  [[customerTag getAllTitles] writeToFile:filePath atomically:YES];
           if (!result) {
                NSLog(@"写入失败");
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------------------------- 添加标签
- (BOOL)createTagWith:(NSString *)tagString
{
    for (CommodityTagView *one in commodityTagViews) {
        if ([one WhetherTheLabelAlreadyExists:tagString]) {
            [SVProgressHUD showErrorWithStatus:@"标签已经存在"];
            return YES;
        }
    }
    
    if (customerTag) {
        [customerTag addTag:tagString];
    }else{
        [self newCreatedCustomView:tagString];
        if (customerTag) {
            [customerTag setSelected:tagString];
        }
    }
    CommodityTagView *lastView  =[commodityTagViews lastObject];
    addTagBtn.frame = CGRectMake(SCREENWIDTH/3-20, lastView.bottom+10, SCREENWIDTH/3+40, 40);
    backScrollView.contentSize = CGSizeMake(SCREENWIDTH, addTagBtn.bottom +10);
    return NO;
}


#pragma mark --------------------------- 自定义标签的图
- (void)newCreatedCustomView:(NSString *)tags
{
    //检索标签 先从包里取出自定义标签 然后再根据当前标签去排除 一有新标签就加入到自定义标签
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:[NSString stringWithFormat:@"CustomTags%@",[User defaultUser].item.userId]];
    NSArray *customArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSArray *checkingArray = [NSArray arrayWithArray:selectedArray];
    for (int i = 0 ; i< commodityTagViews.count; i++) {
        
        CommodityTagView *ontView = [commodityTagViews objectAtIndex:i];
        if (ontView) {
            checkingArray = [ontView checkingDataFromeArray:checkingArray];
        }
    }
    NSMutableArray *dataCustomArray = [NSMutableArray arrayWithArray:checkingArray];
    if (customArray) {
        for (NSString *title in dataCustomArray) {
            if ([customArray containsObject:title] && [dataCustomArray containsObject:title]) {
                [dataCustomArray removeObject:title];
            }
        }
        [dataCustomArray addObjectsFromArray:customArray];
    }
    if (tags) {
        [dataCustomArray addObject:tags];
    }
    
    CommodityTagView *lastView = [commodityTagViews lastObject];
    if (dataCustomArray.count>= 1) {
        NSDictionary *customDict = @{@"type":@"自定义",@"list":dataCustomArray};
        customerTag  = [[CommodityTagView alloc]initWithFrame:CGRectMake(10, lastView.bottom+10, SCREENWIDTH- 20, 20) withDataArray:customDict andCurrentSelectedArray:selectedArray withLeftColor:TAGSCOLORFORE];
        customerTag.tagCount = _tagCount;
        [backScrollView addSubview:customerTag];
        [commodityTagViews addObject:customerTag];
    }
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
