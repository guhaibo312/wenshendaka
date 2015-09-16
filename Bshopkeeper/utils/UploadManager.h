//
//  Bshopkeeper
//
//  Created by jinwei on 15/3/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"
#import "AFNetworking.h"

@interface UpTask : NSObject
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic) NSInteger uploadCount;        // 上传次数，失败的task可以重新上传
@end


@interface UploadManager : NSObject

+ (instancetype)sharedInstance;

// 上传一组图片，里面是UIImage
+ (void)uploadImageList:(NSArray*)imageList hasLoggedIn:(BOOL)hasLogged success:(void(^)(NSArray *resultList))success failure:(void(^)(NSError* error))failure;

// 需要上传的图片队列
@property (strong) NSMutableArray *upLoadTaskList;
@property (nonatomic ,assign) int completeCount;

@end
