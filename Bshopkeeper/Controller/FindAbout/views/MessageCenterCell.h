//
//  MessageCenterCell.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/21.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCenterModel.h"

@interface MessageCenterCell : UITableViewCell
{
    UILabel *nameLabel;                        //名称
    UILabel *timeLabel;                        //时间
    UILabel *readLabel;                        //已读的标记
}

- (void)bingMessgeCenterModer:(MessageCenterModel *)messageModel;


@end
