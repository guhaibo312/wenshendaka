//
//  OrderNotExtractCashViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderNotExtractCashViewController.h"
#import "OrderManageCenterViewController.h"
#import "UserHomeBtn.h"

@interface OrderNotExtractCashViewController ()
{
    UILabel * totalMoneyLabel;
    UILabel * autoMoneyLabel;
    UILabel * unMoneyLabel;
    

}

@property (nonatomic, strong) NSMutableDictionary *unRecivedMoney;

@end

@implementation OrderNotExtractCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"未提现金额";
    self.view.backgroundColor = VIEWBACKGROUNDCOLOR;
    
    [self initSubViews];
    
    [self reloadData];
}

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _unRecivedMoney = [NSMutableDictionary dictionaryWithDictionary:query];
        }
    }
    return self;
}

- (void)initSubViews
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 132)];
    topView.backgroundColor = NAVIGATIONCOLOR;
    [self.view addSubview:topView];
    
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    topLineView.backgroundColor = TAGSCOLORFORE;
    [topView addSubview:topLineView];
    
    totalMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 66-20, SCREENWIDTH-60 , 40)];
   
    totalMoneyLabel.font = [UIFont systemFontOfSize:40];
    totalMoneyLabel.textColor = [UIColor whiteColor];
    NSString *totalStr = [NSString stringWithFormat:@"%d",[[NSString stringWithFormat:@"%@",_unRecivedMoney?_unRecivedMoney[@"unconfirmedAmount"]:@"0"] integerValue]+[[NSString stringWithFormat:@"%@",_unRecivedMoney?_unRecivedMoney[@"waitDrawAmount"]:@"0"] integerValue]+[[NSString stringWithFormat:@"%@",_unRecivedMoney?_unRecivedMoney[@"drawingAmount"]:@"0"] integerValue]];
    
    NSMutableAttributedString *threeText = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] ,NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    [threeText appendAttributedString:[[NSAttributedString alloc] initWithString:totalStr attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] ,NSFontAttributeName: [UIFont systemFontOfSize:40]}]];
    totalMoneyLabel.attributedText = threeText;
    totalMoneyLabel.textAlignment = NSTextAlignmentCenter;

    [topView addSubview:totalMoneyLabel];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,topView.bottom , SCREENWIDTH, 176)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *leftTopLabel = [UILabel labelWithFrame:CGRectMake(25,30 , SCREENWIDTH/2-50, 20) fontSize:16 fontColor:GRAYTEXTCOLOR text:@"待提现"];
    [bottomView addSubview:leftTopLabel];
    
    autoMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, leftTopLabel.bottom, SCREENWIDTH/2-50 , 30)];
    autoMoneyLabel.font = [UIFont systemFontOfSize:23];
    autoMoneyLabel.textAlignment = NSTextAlignmentLeft;
    autoMoneyLabel.textColor = [UIColor blackColor];
    NSString *waitingStr = [NSString stringWithFormat:@"%d",[[NSString stringWithFormat:@"%@",_unRecivedMoney?_unRecivedMoney[@"waitDrawAmount"]:@"0"] integerValue]+[[NSString stringWithFormat:@"%@",_unRecivedMoney?_unRecivedMoney[@"drawingAmount"]:@"0"] integerValue]];
    NSMutableAttributedString *twoText = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSForegroundColorAttributeName: [UIColor blackColor] ,NSFontAttributeName: [UIFont systemFontOfSize:10]}];
    [twoText appendAttributedString:[[NSAttributedString alloc] initWithString:waitingStr attributes:@{NSForegroundColorAttributeName: [UIColor blackColor] ,NSFontAttributeName: [UIFont systemFontOfSize:23]}]];
    autoMoneyLabel.attributedText = twoText;
    [bottomView addSubview:autoMoneyLabel];
    
    UILabel *leftBottomLabel = [UILabel labelWithFrame:CGRectMake(20, autoMoneyLabel.bottom+10, SCREENWIDTH/2-30, 40) fontSize:12 fontColor:GRAYTEXTCOLOR text:@"2－5个工作日内到账，\n节假日顺延"];
    leftBottomLabel.numberOfLines = 0;
    [bottomView addSubview:leftBottomLabel];
    
    
    UILabel *righttopLabel = [UILabel labelWithFrame:CGRectMake(SCREENWIDTH/2 + 25,30 , SCREENWIDTH/2-50, 20) fontSize:16 fontColor:GRAYTEXTCOLOR text:@"未接受"];
    [bottomView addSubview:righttopLabel];
    
    unMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(25+SCREENWIDTH/2, leftTopLabel.bottom, SCREENWIDTH/2-50 , 30)];
    unMoneyLabel.font = [UIFont systemFontOfSize:23];
    unMoneyLabel.textAlignment = NSTextAlignmentLeft;
    unMoneyLabel.textColor = [UIColor blackColor];
    NSMutableAttributedString *oneText = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSForegroundColorAttributeName: [UIColor blackColor] ,NSFontAttributeName: [UIFont systemFontOfSize:10]}];
    [oneText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_unRecivedMoney?_unRecivedMoney[@"unconfirmedAmount"]:@"0"] attributes:@{NSForegroundColorAttributeName: [UIColor blackColor] ,NSFontAttributeName: [UIFont systemFontOfSize:23]}]];
    unMoneyLabel.attributedText = oneText;
    [bottomView addSubview:unMoneyLabel];
    
    UILabel *rightBottomLabel = [UILabel labelWithFrame:CGRectMake(25+SCREENWIDTH/2, autoMoneyLabel.bottom+10, SCREENWIDTH/2-30, 20) fontSize:12 fontColor:GRAYTEXTCOLOR text:@"接受订单后可提现"];
    [bottomView addSubview:rightBottomLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-0.5, 20, 1, bottomView.height-40)];
    lineView.backgroundColor = VIEWBACKGROUNDCOLOR;
    [bottomView addSubview:lineView];
    
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, bottomView.bottom, SCREENWIDTH, 1)];
    lineView1.backgroundColor = VIEWBACKGROUNDCOLOR;
    [bottomView addSubview:lineView1];
    
    UserHomeBtn *backOrderList = [UserHomeBtn buttonWithFrame:CGRectMake(SCREENWIDTH/2, rightBottomLabel.bottom+30, SCREENWIDTH/2, 20) text:@"查看待接受的订单" imageName:@"icon_right_img.png"];
    backOrderList.nameLabel.frame = CGRectMake(20, 0, backOrderList.width-40, 20);
    backOrderList.nameLabel.font = [UIFont systemFontOfSize:14];
    backOrderList.nameLabel.textColor = SquareLinkColor;
    backOrderList.desIamgeView.frame = CGRectMake(backOrderList.width-16, 5, 6, 10);
    [backOrderList addTarget:self action:@selector(backToOrderlistFunction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:backOrderList];
    
}


- (void)reloadData
{
    
}

- (void)backToOrderlistFunction:(id)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[OrderManageCenterViewController class]]) {
            OrderManageCenterViewController *manageVC = (OrderManageCenterViewController *)controller;
            [manageVC backToPindingList];
            [self.navigationController popToViewController:manageVC animated:YES];
            return;
        }
    }
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
