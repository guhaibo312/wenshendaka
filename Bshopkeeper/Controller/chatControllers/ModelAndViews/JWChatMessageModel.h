//
//  JWChatMessageModel.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/26.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "DataBaseObject.h"

@interface JWChatMessageModel : DataBaseObject

@property (nonatomic, strong) NSString *_id;

@property (nonatomic, strong) NSString *title;

@property (nonatomic , strong) NSString *text;

@property (nonatomic, assign) int type;

@property (nonatomic , strong) NSString *url;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) NSString *fromId;

@property (nonatomic, strong) NSString *otherId;

@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSArray *sendImages;

- (id)initWithDictionary:(NSDictionary *)dict;


@end
