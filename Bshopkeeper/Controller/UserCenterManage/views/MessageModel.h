//
//  MessageModel.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/9.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, assign) NSString * type;
@property (nonatomic, copy) NSString *reply_id;
@property (nonatomic, assign) BOOL showTime;

+ (id)messageModelWithDict:(NSDictionary *)dict;

@end
