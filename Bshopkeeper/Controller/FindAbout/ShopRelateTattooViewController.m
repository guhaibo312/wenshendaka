//
//  ShopRelateTattooViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/9/8.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ShopRelateTattooViewController.h"
#import "UIImageView+WebCache.h"

@interface ShopRelateTattooViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *listTable;
}
@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *selectedArray;


@end


@implementation ShopRelateTattooViewController


- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            self.companyId = query[@"id"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"作品关联纹身师";
    self.selectedArray = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    listTable.rowHeight = 60;
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:listTable];
    
    __weak __typeof (self)weakself = self;
    
    [[JWNetClient defaultJWNetClient]getNetClient:@"Company/clerkList" requestParm:@{@"companyId":_companyId?_companyId:@""} result:^(id responObject, NSString *errmsg) {
        if (!weakself) return ;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            [weakself requestFinished:responObject];
        }
        
    }];
}

- (void)requestFinished:(NSDictionary *)result
{
    if (result) {
        NSDictionary *datadict = [result objectForKey:@"data"];
        if (datadict) {
            NSArray *listArray = datadict[@"list"];
            if (listArray) {
                _dataArray = [NSMutableArray arrayWithArray:listArray];
            }else{
                _dataArray = [[NSMutableArray alloc] init];
            }
        }
    }
    if (listTable) {
        [listTable reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *relateCellidentifier = @"relateCellidentifier";
    RelateTattooCell *cell = [tableView dequeueReusableCellWithIdentifier:relateCellidentifier];
    if (!cell) {
        cell =  [[RelateTattooCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:relateCellidentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell reloadData:_dataArray[indexPath.row]];
    
    cell.tag = indexPath.row;
    [cell.relateButton addTarget:self action:@selector(clickRelateFunction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)clickRelateFunction:(UIButton *)sender
{
    if (!sender.selected) {
        NSNumber *number = [NSNumber numberWithInteger:sender.tag];
        if (![self.selectedArray containsObject:number]) {
            [self.selectedArray addObject:number];
        };
    }else{
        NSNumber *number = [NSNumber numberWithInteger:sender.tag];
        if ([self.selectedArray containsObject:number]) {
            [self.selectedArray removeObject:number];
        };
    }
    sender.selected = !sender.selected;
}

- (void)backAction
{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (int i = 0; i< self.selectedArray.count; i++) {
        NSNumber *one = self.selectedArray[i];
        int index = [one integerValue];
        if (index >= 0 && index < self.dataArray.count) {
            [temp addObject:_dataArray[index]];
        }
    }
    if (_selectedBlock) {
        _selectedBlock(temp);
        _selectedBlock = NULL;
    }
    listTable.delegate = nil;
    listTable.dataSource = nil;
    [super backAction];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

@implementation RelateTattooCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        headImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 44, 44)];
        headImage.backgroundColor = [UIColor clearColor];
        headImage.clipsToBounds = YES;
        headImage.layer.cornerRadius = 22;
        headImage.userInteractionEnabled = YES;
        headImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:headImage];
        
        nameLabel =  [UILabel labelWithFrame:CGRectMake(headImage.right+10, 10, SCREENWIDTH-headImage.right-80, 40) fontSize:16 fontColor:[UIColor blackColor] text:@""];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        
        self.relateButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 16, 80, 28)];
        [self.relateButton setBackgroundImage:[UIUtils imageFromColor:SEGMENTSELECT] forState:UIControlStateNormal];
         [self.relateButton setBackgroundImage:[UIUtils imageFromColor:VIEWBACKGROUNDCOLOR] forState:UIControlStateSelected];
        [self.relateButton setTitle:@"关联作品" forState:UIControlStateNormal];
        [self.relateButton setTitle:@"取消关联" forState:UIControlStateSelected];
        [self.relateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.relateButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        self.relateButton.clipsToBounds = YES;
        self.relateButton.layer.cornerRadius= 5;
        self.relateButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.relateButton];
        
    }
    return self;
}
- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    self.relateButton.tag = tag;
    
}

- (void)reloadData:(NSDictionary *)dict
{
    if (dict) {
        if ([NSObject nulldata:dict[@"avatar"]]) {
            [headImage sd_setImageWithURL:[NSURL URLWithString:dict[@"avatar"]]];
        }else {
            headImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_userHead_default" ofType:@"png"]];
        }
        if ([NSObject nulldata:dict[@"nickname"]]) {
            nameLabel.text = dict[@"nickname"];
        }else {
            nameLabel.text = @"纹身大师";
        }
    }
}

@end
