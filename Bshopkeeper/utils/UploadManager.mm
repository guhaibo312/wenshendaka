//
//  UploadManager.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "UploadManager.h"
#import "Configurations.h"
#import "UIImage+Orientation.h"
#import "NSString+Extension.h"
#import "UploadingView.h"

@implementation UpTask


@end

@interface UploadManager ()
{
    UploadingView *uploadingProgress;
    float progressTotal[9];
    int imageCount;

}
@end

@implementation UploadManager {
    QNUploadManager *_upManager;
    NSString *_token;
    void (^_successBlock)(NSArray *resultList);
    void (^_failBlock)(NSError *error);
    AFHTTPRequestOperation *_operation;
//    QNFileRecorder *qnrecord;
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static UploadManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[UploadManager alloc] init];
    });
    return sharedManager;
}

+ (void)uploadImageList:(NSArray*)imageList hasLoggedIn:(BOOL)hasLogged success:(void(^)(NSArray *resultList))success failure:(void(^)(NSError* error))failure {
    return [[self sharedInstance] uploadImageList: imageList hasLoggedIn:(BOOL)hasLogged success: success failure: failure];
}

- (id)init {
    self = [super init];
    if (self) {
        
//        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:[NSString stringWithFormat:@"QiNiuRecord"]];
//        
//        NSError *error = nil;
//        qnrecord = [QNFileRecorder fileRecorderWithFolder:filePath error:&error];
//        NSLog(@"recorder error %@", error);
//        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//            [[NSFileManager defaultManager]createFileAtPath:filePath contents:nil attributes:nil];
//        }
        _upManager = [[QNUploadManager alloc] init];

    }
    return self;
}

- (void)uploadImageList:(NSArray*)imageList hasLoggedIn:(BOOL)hasLogged success:(void(^)(NSArray *resultList))success failure:(void(^)(NSError* error))failure {
    [_operation cancel];
    
    if (uploadingProgress) {
        [uploadingProgress removeFromSuperview];
        uploadingProgress = nil;
    }
    for (int i = 0 ; i< 9; i++) {
        progressTotal[i] = 0;
    }
    
    uploadingProgress = [[UploadingView alloc]init];
    _operation = nil;
    self.upLoadTaskList = nil;
    self.upLoadTaskList = [NSMutableArray array];
    for (UIImage *image in imageList) {
        UpTask *task = [[UpTask alloc] init];
        CGSize imagesize = image.size;
        if (imagesize.width >1080) {
            imagesize.height =  imagesize.height/(imagesize.width/1080);
            imagesize.width = 1080;

        }
        if (imagesize.height >1920) {
            imagesize.width = imagesize.width/(imagesize.height/1920);
            imagesize.height = 1920;
        }
        //对图片大小进行压缩--
        UIImage * imageNew = [UIImage imageWithImage:image scaledToSize:imagesize];
        NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.7);
        task.imageData = imageData;
        NSString *key = [NSString stringWithFormat:@"%f%@",[[NSDate date] timeIntervalSince1970] *1000,[User defaultUser].item.userId];
        task.imageName = [NSString stringWithFormat:@"%@_%.0fX%.0f",[NSString md5HashFrom:key],imagesize.width,imagesize.height];
        [self.upLoadTaskList addObject: task];
    }
    
    _successBlock = success;
    _failBlock = failure;
    self.completeCount = 0;
    // 开始上传
    [self startUploadTaskListWithLoggedIn:hasLogged];
    
}

- (void)startUploadTaskListWithLoggedIn:(BOOL) hasLogged{
    if ([_token isNonEmpty]) {
        
        if (uploadingProgress) {
            [uploadingProgress show];
            [uploadingProgress setProgress:0];
            
        }
        imageCount = (int)self.upLoadTaskList.count;
        
        for (int i = 0 ;i < self.upLoadTaskList.count ; i++) {
            UpTask* task = self.upLoadTaskList[i];
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
            [parm setObject:task.imageName forKey:[NSString stringWithFormat:@"x:%@",task.imageName]];
            if (uploadingProgress) {
                if (![uploadingProgress.keyArray containsObject:task.imageName]) {
                    [uploadingProgress.keyArray addObject:task.imageName];
                }
            }
            
//            NSData *lastRecord = [qnrecord get:task.imageName];
//            if (lastRecord) {
//                NSString *recordKey = [[NSString alloc]initWithData:lastRecord encoding:NSUTF8StringEncoding];
//                if ([recordKey isEqualToString:task.imageName]) {
//                    _completeCount++;
//                    [self checkHasALLBeenUploaded];
//                    
//                    if ([uploadingProgress.keyArray containsObject:task.imageName]) {
//                        int index = (int)[uploadingProgress.keyArray indexOfObject:task.imageName];
//                        progressTotal[index] = 1.0f;
//                    }
//                    [self judgeCurrentProgress];
//                    
//                    continue;
//                }
//            }
            
            
            QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler: ^(NSString *key, float percent){
                if (key && uploadingProgress) {
                    if ([uploadingProgress.keyArray containsObject:key]) {
                        int index = (int)[uploadingProgress.keyArray indexOfObject:key];
                        progressTotal[index] = percent;
                    }
                    [self judgeCurrentProgress];
                }
            } params:parm checkCrc:YES cancellationSignal:nil];
            
            
            
            [_upManager putData: task.imageData
             key: task.imageName token: _token complete: ^(QNResponseInfo *info, NSString *key,NSDictionary *resp) {
                 
                 if (!info.isOK) {
                     // 上传失败，
                      NSDictionary *userInfo = @{@"error_msg" : @"上传图片失败"};

                      NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:userInfo];
                     if (uploadingProgress) {
                         [uploadingProgress dissMiss];
                     }
                      _failBlock(error);
                     _successBlock = NULL;
                     if (_upLoadTaskList) {
                         [_upLoadTaskList removeAllObjects];
                         _upLoadTaskList = nil;
                     }

                 }else{
                      _completeCount++;
                      [self checkHasALLBeenUploaded];
//                     NSString *key = [resp objectForKey:@"key"];
//                     if (key) {
//                        NSError *error = [qnrecord set:key data:[key dataUsingEncoding:NSUTF8StringEncoding]];
//                         if (error) {
//                             NSLog(@"%@",error);
//                         }
//                     }
                 }
                
             }
             option:opt];
            
        }

        
    } else {
        
        // 获取token
        _operation = [[JWNetClient defaultJWNetClient] GET: @"Upload/token" parameters: nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"code"]integerValue] == 0) {
                _token = [[responseObject objectForKey:@"data"]objectForKey:@"token"];
                // 在开始上传
                [self startUploadTaskListWithLoggedIn: hasLogged];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _failBlock(error);
            if (_upLoadTaskList) {
                [_upLoadTaskList removeAllObjects];
                _upLoadTaskList = nil;
            }

            if (uploadingProgress) {
                [uploadingProgress dissMiss];
            }
        }];
    }
}


// 检查是不是所有的都已经上传了
- (void)checkHasALLBeenUploaded {
    
    if (_completeCount != self.upLoadTaskList.count ) {
        return;
    }
    NSMutableArray *urls = [NSMutableArray array];
    for (UpTask *task in self.upLoadTaskList) {
        if ([NSObject nulldata:task.imageName]) {
            [urls addObject: task.imageName];
        }
    }
    

    if (_upLoadTaskList) {
        [_upLoadTaskList removeAllObjects];
        _upLoadTaskList = nil;
    }
    _failBlock = NULL;
    _token = nil;
    _successBlock(urls);
    _successBlock = NULL;
    if (uploadingProgress) {
        [uploadingProgress dissMiss];
    }

}

- (void)judgeCurrentProgress
{
    if (!self) {
        return;
    }
    float current = 0;
    
    for (int i = 0 ; i< imageCount; i++) {
        current += progressTotal[i];
    }
    if (uploadingProgress) {
        [uploadingProgress setProgress:current/imageCount];
    }
    
}



@end
