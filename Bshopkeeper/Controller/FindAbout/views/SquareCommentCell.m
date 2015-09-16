//
//  SquareCommentCell.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/4.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SquareCommentCell.h"
#import "Configurations.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"
#import "SquareUserPageViewController.h"


@interface SquareCommentCell() <TTTAttributedLabelDelegate>
{
    UIActivityIndicatorView *activityView;
    CommentStatusBtn *failBtn;
}
@property (nonatomic) UILongPressGestureRecognizer *longPress;
@end

@implementation SquareCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        leftHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(34-20, 12, 40, 40)];
        leftHeadImageView.clipsToBounds = YES;
        leftHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
        leftHeadImageView.layer.borderWidth = 1;
        leftHeadImageView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
        leftHeadImageView.layer.borderColor = LINECOLOR.CGColor;
        leftHeadImageView.layer.cornerRadius = 20;
        UITapGestureRecognizer *taphead = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushtoUserPageDetail:)];
        [leftHeadImageView addGestureRecognizer:taphead];
        leftHeadImageView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:leftHeadImageView];
                
        userNameLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(leftHeadImageView.right+10, 12, SCREENWIDTH-leftHeadImageView.right-20, 20)];
        userNameLabel.textColor = SquareLinkColor;
        NSMutableDictionary *mutableLinkAttributes1 = [NSMutableDictionary dictionary];
        [mutableLinkAttributes1 setValue:(id)[SquareLinkColor CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
        [mutableLinkAttributes1 setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        userNameLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes1];
        userNameLabel.font = [UIFont systemFontOfSize:12];
        userNameLabel.userInteractionEnabled = YES;
        userNameLabel.delegate = self;
        [self.contentView addSubview:userNameLabel];
        
        replayNameLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(leftHeadImageView.right+10, userNameLabel.bottom, SCREENWIDTH-leftHeadImageView.right-20, 20)];
        replayNameLabel.font = [UIFont systemFontOfSize:12];
        NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
        [mutableLinkAttributes setValue:(id)[SquareLinkColor CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
        [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        replayNameLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes];
        replayNameLabel.userInteractionEnabled = YES;
        replayNameLabel.delegate = self;
        replayNameLabel.backgroundColor = [UIColor clearColor];
        replayNameLabel.textColor = GRAYTEXTCOLOR;
        [self.contentView addSubview:replayNameLabel];
        
        releaseLabel = [UILabel labelWithFrame:CGRectMake(SCREENWIDTH-110, 12, 100, 22) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
        releaseLabel.backgroundColor = [UIColor clearColor];
        releaseLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:releaseLabel];
        
        atextLabel = [UILabel labelWithFrame:CGRectMake(leftHeadImageView.right+10, replayNameLabel.bottom+5, SCREENWIDTH-leftHeadImageView.right-20, 20) fontSize:16 fontColor:GRAYTEXTCOLOR text:@""];
        [self.contentView addSubview:atextLabel];
        atextLabel.numberOfLines = 0;
        self.backgroundColor = VIEWBACKGROUNDCOLOR;
        self.contentView.backgroundColor = VIEWBACKGROUNDCOLOR;
        
        bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, SCREENWIDTH, 0.5)];
        bottomLine.backgroundColor = LINECOLOR;
        [self.contentView addSubview:bottomLine];
        
        failBtn = [CommentStatusBtn buttonWithType:UIButtonTypeDetailDisclosure];
        failBtn.frame = CGRectMake(SCREENWIDTH-40, 8, 30, 30);
        failBtn.tintColor = SquareLinkColor;
        [self addSubview:failBtn];
        
        activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(SCREENWIDTH-40, 8, 30, 30);
        activityView.color = SquareLinkColor;
        [self.contentView addSubview:activityView];
        [activityView startAnimating];
        
    }
    return self;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    failBtn.tag = tag;
}

- (void)bingLongPressAction:(SEL)action target:(id)target withSender:(NSString *)senderName
{
    if ([senderName isEqualToString:@"longpress"]) {
        if ([self.contentView.gestureRecognizers containsObject:_longPress]) {
            [self.contentView removeGestureRecognizer:_longPress];
        }
        _longPress = nil;
        _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:target action:action];
        _longPress.minimumPressDuration = 0.5f;
        [self addGestureRecognizer:_longPress];
        return;
    }
    if ([senderName isEqualToString:@"detailed"]){
        if (failBtn) {
            if ([failBtn.allTargets containsObject:target]) {
                [failBtn removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            }
            [failBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}


- (void)refreshDataWith:(SquareCommentItem *)commentItem owner:(UIViewController *)targer

{
    _owner = targer;
    if (commentItem) {
       
        _dataItem = commentItem;
        if (_dataItem.dataStatus  == CommentItemStatusNormal) {
            _dataItem.changBlock = NULL;
        }else{
            _dataItem.changBlock = ^(SquareCommentItemStatus status){
                if (!self) return;
                [self changeSelfDataStatusAction:status];
            };
        }
        leftHeadImageView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
        if (_dataItem.userInfo) {
            if ([NSObject nulldata:_dataItem.userInfo[@"avatar"] ]) {
                [leftHeadImageView sd_setImageWithURL:[NSURL URLWithString:_dataItem.userInfo[@"avatar"]]];
            }
            if (_dataItem.userInfo[@"nickname"]) {
                userNameLabel.text = _dataItem.userInfo[@"nickname"];
                [userNameLabel addLinkToPhoneNumber:_dataItem.userInfo[@"nickname"] withRange:[userNameLabel.text rangeOfString:_dataItem.userInfo[@"nickname"]]];
            }
          

            
            if (commentItem.replyUserInfo) {
                NSString *name = commentItem.replyUserInfo[@"nickname"];
                if ([NSObject nulldata:name ]) {
                    replayNameLabel.text = [NSString stringWithFormat:@"回复%@",name];
                    [replayNameLabel addLinkToPhoneNumber:name withRange:[replayNameLabel.text rangeOfString:name]];
                }
            }
            
        }
        if (commentItem.replyUserInfo) {
            replayNameLabel.height = 20;
        }else{
            replayNameLabel.height = 0;

        }
        
        if ([NSObject nulldata:commentItem.content ]) {
             float height = [commentItem.content sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(SCREENWIDTH-54-20, 1000)].height;
            atextLabel.text = commentItem.content;
            atextLabel.top = replayNameLabel.bottom+5;
            atextLabel.height = height+5;
        }
        if (_dataItem.time) {
            if (_dataItem.time > 9999999999) {
                _dataItem.time/=1000;
            }
            releaseLabel.text = [NSString stringWithDate:[NSDate dateWithTimeIntervalSince1970:commentItem.time]];
        }
        [self changeSelfDataStatusAction:commentItem.dataStatus];
    }
}

- (void)changeSelfDataStatusAction:(SquareCommentItemStatus)status
{
    if (status == CommentItemStatusNormal) {
        releaseLabel.hidden = NO;
        if (activityView.isAnimating) {
            [activityView stopAnimating];
        }
        failBtn.hidden = YES;
        
    }else if (status == CommentItemStatusLoading){
        releaseLabel.hidden = YES;
        if (activityView.isAnimating) {
            [activityView stopAnimating];
        }
        [activityView startAnimating];
        failBtn.hidden = YES;
    }else {
        releaseLabel.hidden = YES;
        if (activityView.isAnimating) {
            [activityView stopAnimating];
        }
        failBtn.hidden = NO;
        
    }
    
}

- (void)prepareForReuse
{
    leftHeadImageView.image = nil;
    userNameLabel.text = nil;
    userNameLabel.attributedText = nil;
    replayNameLabel.text = nil;
    atextLabel.text = nil;
    releaseLabel.text = nil;
}

- (void)layoutSubviews
{
    bottomLine.top = self.height-0.5;
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    if (self == NULL || _owner == NULL) return;

    NSString *userId ;
    if (label == userNameLabel) {
        NSLog(@"点击评论者");
        userId = _dataItem.userInfo[@"userId"];
    }else{
        NSLog(@"点击被评论着");
        userId = _dataItem.replyUserInfo[@"userId"];
    }
    if (!userId) {
        return;
    }
      SquareUserPageViewController *userPageVC = [[SquareUserPageViewController alloc]initWithQuery:@{@"userId":userId}];
    [_owner.navigationController pushViewController:userPageVC animated:YES];

}

- (void)pushtoUserPageDetail:(id)sender
{
    NSString *userId = _dataItem.userInfo[@"userId"];
    if (userId == NULL || self == NULL || _owner == NULL) return;
    SquareUserPageViewController *userPageVC = [[SquareUserPageViewController alloc]initWithQuery:@{@"userId":userId}];
    [_owner.navigationController pushViewController:userPageVC animated:YES];
}


@end


@implementation SquareFromeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        leftHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 12, 50, 50)];
        leftHeadImageView.clipsToBounds = YES;
        leftHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
        leftHeadImageView.layer.borderWidth = 1;
        leftHeadImageView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
        leftHeadImageView.layer.borderColor = LINECOLOR.CGColor;
        leftHeadImageView.layer.cornerRadius = 25;
        [self.contentView addSubview:leftHeadImageView];
        
        nameLabel = [UILabel labelWithFrame:CGRectMake(leftHeadImageView.right+10, 15, SCREENWIDTH- leftHeadImageView.right-20, 20) fontSize:16 fontColor:SquareLinkColor text:@""];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        
        
        vSignView = [[UIImageView alloc]initWithFrame:CGRectMake(leftHeadImageView.right+10, 44, 18, 16)];
        vSignView.image = [UIImage imageNamed:@"icon_mine_v.png"];
        [self.contentView addSubview:vSignView];
        
        autSignView = [[UIImageView alloc]initWithFrame:CGRectMake(vSignView.right+5, 41, 22, 22)];
        autSignView.image = [UIImage imageNamed:@"icon_mine_aut_pass.png"];
        [self.contentView addSubview:autSignView];
        
        hotLabel = [UILabel labelWithFrame:CGRectMake(leftHeadImageView.right+10, 72, SCREENWIDTH-leftHeadImageView.right-20, 20) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
        [self.contentView addSubview:hotLabel];
        
        self.contentView.backgroundColor = VIEWBACKGROUNDCOLOR;

    }
    return self;
}

- (void)refreshFromDict:(NSDictionary *)dict
{
    if (!dict) return;
    if ([NSObject nulldata:dict[@"avatar"]]) {
        [leftHeadImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"avatar"]]];
    }else{
        leftHeadImageView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
    }
    
    if ([NSObject nulldata:dict[@"nickname"]]) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:dict[@"nickname"] attributes:@{NSForegroundColorAttributeName:SquareLinkColor,NSFontAttributeName: [UIFont systemFontOfSize:16]}];
        nameLabel.attributedText = string;
    }
    if (dict[@"company"]) {
        if (dict[@"company"][@"name"]) {
             NSMutableAttributedString *companyName = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",dict[@"company"][@"name"]] attributes:@{NSForegroundColorAttributeName:GRAYTEXTCOLOR,NSFontAttributeName: [UIFont systemFontOfSize:14]}];
            if (nameLabel.attributedText) {
                NSMutableAttributedString *nicknameCompany = [[NSMutableAttributedString alloc]initWithAttributedString:nameLabel.attributedText];
                [nicknameCompany appendAttributedString:companyName];
                nameLabel.attributedText = nicknameCompany;
            }else{
                nameLabel.attributedText = companyName;
            }
        }
    }

    
    if ([dict[@"v"] boolValue]) {
        autSignView.hidden = NO;
        vSignView.hidden = NO;
        hotLabel.top = 72;
    }else{
        autSignView.hidden = YES;
        vSignView.hidden = YES;
        hotLabel.top = 46;
    }
    
    NSString *hotStr = dict[@"hot"];
    NSString *fineStr = dict [@"follower_count"];
    if (![NSObject nulldata:dict[@"hot"]]) hotStr = @"0";
    if (![NSObject nulldata:dict[@"follower_count"]]) fineStr = @"0";
    hotStr  = StringFormat(hotStr);
    fineStr = StringFormat(fineStr);
    
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc]initWithString:hotStr attributes:@{NSForegroundColorAttributeName:SEGMENTSELECT,NSFontAttributeName: [UIFont systemFontOfSize:12]}];
    [placeholderString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 人气｜" attributes:@{NSForegroundColorAttributeName:GRAYTEXTCOLOR,NSFontAttributeName: [UIFont systemFontOfSize:12]}]];
    [placeholderString appendAttributedString:[[NSAttributedString alloc] initWithString:fineStr attributes:@{NSForegroundColorAttributeName:SEGMENTSELECT,NSFontAttributeName: [UIFont systemFontOfSize:12]}]];
    [placeholderString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 粉丝" attributes:@{NSForegroundColorAttributeName:GRAYTEXTCOLOR,NSFontAttributeName: [UIFont systemFontOfSize:12]}]];
    hotLabel.attributedText = placeholderString;
    
}


@end

@implementation SquareCommentItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict) {
            [self setValuesForKeysWithDictionary:dict];
        }
        _commentCellHeight = 64;
        [self calculateWithCommentCellHeight];
        _dataStatus = CommentItemStatusNormal;
        if (_userInfo) {
            if ([_userInfo[@"userId"] isEqual:[User defaultUser].item.userId]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
                [dict setObject:_userInfo[@"userId"] forKey:@"userId"];
                [dict setObject:[User defaultUser].item.avatar forKey:@"avatar"];
                [dict setObject:[User defaultUser].item.nickname forKey:@"nickname"];
                _userInfo = dict;
            }
        }
        if (_replyUserInfo) {
            if ([_replyUserInfo[@"userId"] isEqual:[User defaultUser].item.userId]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
                [dict setObject:_replyUserInfo[@"userId"] forKey:@"userId"];
                [dict setObject:[User defaultUser].item.nickname forKey:@"nickname"];
                _replyUserInfo = dict;
            }
        }

    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)calculateWithCommentCellHeight
{
    
    _commentCellHeight = 64;
    if ([NSObject nulldata:_content ]) {
        float height = [_content sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(SCREENWIDTH-54-20, 1000)].height;
        float replayheight = 0;
        if (_replyUserInfo) {
            replayheight = 20;
        }
        
        if (height+32+5+replayheight > 64-12) {
            _commentCellHeight = 34+ 5 + 12 +height+replayheight;
        }
    }
}

- (void)dealloc
{
    _changBlock = NULL;
    _userInfo = NULL;
    _replyUserInfo = NULL;
}

@end

@implementation CommentStatusBtn

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end

