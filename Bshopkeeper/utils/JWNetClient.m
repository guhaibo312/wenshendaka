//
//  JWNetClient.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWNetClient.h"
#import "Configurations.h"
#import "JWhttpRequestSerializer.h"

@implementation JWNetClient

+ (instancetype)defaultJWNetClient
{
    static JWNetClient *jwNetclient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jwNetclient = [[JWNetClient alloc]initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s",API_HOST]]];
    });
    return jwNetclient;
}

- (id)initWithBaseURL:(NSURL *)url {
   self = [super initWithBaseURL:url];
   if (self) {
       

       // 为了https请求正常
       self.securityPolicy.allowInvalidCertificates = YES;
       
       self.requestSerializer = [JWhttpRequestSerializer serializer];
       self.requestSerializer.timeoutInterval = 45;
       
       [self.requestSerializer setValue: @"application/json"
                     forHTTPHeaderField: @"Accept"];
       self.responseSerializer = [AFJSONResponseSerializer serializer];
   }
   
   
   return self;
}
/*
 *post 请求方式 参数
 * @actionStr 方法名称  @parm   请求的参数  @object 响应的对象
 */
- (void)postNetClient:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock
{
    [self POST:actionStr parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"]integerValue] == 0) {
            if (resultBlock) {
                resultBlock(responseObject,nil);
            }
        }else{
            NSString *err = @"操作失败";
            if ([responseObject objectForKey:@"msg"]) {
                err = responseObject[@"msg"];
            }

            resultBlock(nil,err);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.responseObject) {
            if ([[operation.responseObject objectForKey:@"code"]integerValue] == 0) {
                if (resultBlock) {
                    resultBlock(operation.responseObject,nil);
                }
            }else{
                NSString *err = @"操作失败";
                if ([operation.responseObject objectForKey:@"msg"]) {
                    err = operation.responseObject[@"msg"];
                }
                if ([error.localizedDescription rangeOfString:@"断开"].location != NSNotFound) {
                    err = @"网络异常，检查网络连接";
                }
                resultBlock(nil,err);
            }

        }else{
            NSString *err = @"操作失败";
            resultBlock(nil,err);
        }
        
    }];
    
}

/*
 *get 请求方式 参数
 * @actionStr 方法名称  @parm   请求的参数  @object 响应的对象
 */
- (void)getNetClient:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock
{
    [self GET:actionStr parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"]integerValue] == 0) {
            if (resultBlock) {
                resultBlock(responseObject,nil);
            }
        }else{
            NSString *err = @"操作失败";
            if ([responseObject objectForKey:@"msg"]) {
                err = responseObject[@"msg"];
            }
            
            resultBlock(nil,err);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.responseObject) {
            if ([[operation.responseObject objectForKey:@"code"]integerValue] == 0) {
                if (resultBlock) {
                    resultBlock(operation.responseObject,nil);
                }
            }else{
                NSString *err = @"操作失败";
                
                if ([operation.responseObject objectForKey:@"msg"]) {
                    err = operation.responseObject[@"msg"];
                }
                resultBlock(nil,err);
            }
            
        }else{
            NSString *err = @"操作失败";
            if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
                err = @"网络连接失败";
            }
            if ([error.localizedDescription rangeOfString:@"断开"].location != NSNotFound) {
                err = @"网络异常，检查网络连接";
            }
            resultBlock(nil,err);
        }

    }];
    
}

/*
 *put 请求方式 参数
 * @actionStr 方法名称  @parm   请求的参数  @object 响应的对象
 */
- (void)putNetClient:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock
{
    [self PUT:actionStr parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"]integerValue] == 0) {
            if (resultBlock) {
                resultBlock(responseObject,nil);
            }
        }else{
            NSString *err = @"操作失败";
            if ([responseObject objectForKey:@"msg"]) {
                err = responseObject[@"msg"];
            }
            resultBlock(nil,err);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.responseObject) {
            if ([[operation.responseObject objectForKey:@"code"]integerValue] == 0) {
                if (resultBlock) {
                    resultBlock(operation.responseObject,nil);
                }
            }else{
                NSString *err = @"操作失败";
                if ([operation.responseObject objectForKey:@"msg"]) {
                    err = operation.responseObject[@"msg"];
                }
                if ([error.localizedDescription rangeOfString:@"断开"].location != NSNotFound) {
                    err = @"网络异常，检查网络连接";
                }
                resultBlock(nil,err);
            }
            
        }else{
            NSString *err = @"操作失败";
            if ([error.localizedDescription rangeOfString:@"断开"].location != NSNotFound) {
                err = @"网络异常，检查网络连接";
            }
            resultBlock(nil,err);
        }

    }];
}
/*
 *delete 请求方式 参数
 * @actionStr 方法名称  @parm   请求的参数  @object 响应的对象
 */
- (void)deleteNetClient:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock
{
    [self DELETE:actionStr parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"]integerValue] == 0) {
            if (resultBlock) {
                resultBlock(responseObject,nil);
            }
        }else{
            NSString *err = @"操作失败";
            if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
                err = @"网络连接失败";
            }
            if ([responseObject objectForKey:@"msg"]) {
                err = responseObject[@"msg"];
            }
            resultBlock(nil,err);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.responseObject) {
            if ([[operation.responseObject objectForKey:@"code"]integerValue] == 0) {
                if (resultBlock) {
                    resultBlock(operation.responseObject,nil);
                }
            }else{
                NSString *err = @"操作失败";
            
                if ([operation.responseObject objectForKey:@"msg"]) {
                    err = operation.responseObject[@"msg"];
                }
                if ([error.localizedDescription rangeOfString:@"断开"].location != NSNotFound) {
                    err = @"网络异常，检查网络连接";
                }
                resultBlock(nil,err);
            }
            
        }else{
            NSString *err = @"操作失败";
            if ([error.localizedDescription rangeOfString:@"断开"].location != NSNotFound) {
                err = @"网络异常，检查网络连接";
            }
            resultBlock(nil,err);
        }
 
    }];
}


/*---------------------------------------------3366 端口-------------------------------------*/

- (AFHTTPRequestOperation *)squarePost:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"%s%@",API_SquareHost ,actionStr];
    
   AFHTTPRequestOperation *operation =  [self POST:requestUrl parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resultActionwith:operation block:resultBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self resultActionwith:operation block:resultBlock];
    }];
    return operation;
}

- (AFHTTPRequestOperation *)squareGet:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"%s%@",API_SquareHost ,actionStr];
  return   [self GET:requestUrl parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resultActionwith:operation block:resultBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self resultActionwith:operation block:resultBlock];
    }];
}

- (AFHTTPRequestOperation *)squarePut:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock
{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%s%@",API_SquareHost ,actionStr];
   return  [self PUT:requestUrl parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self resultActionwith:operation block:resultBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self resultActionwith:operation block:resultBlock];
    }];

}

- (AFHTTPRequestOperation *)squareDelegate:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"%s%@",API_SquareHost ,actionStr];
   return  [self DELETE:requestUrl parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resultActionwith:operation block:resultBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self resultActionwith:operation block:resultBlock];
    }];
}

- (void)resultActionwith:(AFHTTPRequestOperation *)operation block:(responseCallBlock)resultBlock
{

    NSString *err = @"操作失败";
    if (operation.responseObject) {
        if ([NSObject nulldata:operation.responseObject[@"msg"]]) {
            err = operation.responseObject[@"msg"];
        }
    }
    
    if ([NSObject nulldata:operation.responseString ]) {
        NSDictionary *result =  [operation.responseString JSONValue];
        if ([[result objectForKey:@"status"]isEqualToString:@"ok"] && !operation.error) {
            if (resultBlock) {
                resultBlock(result,nil);
                return ;
            }
        }else{
            if ([NSObject nulldata:[result objectForKey:@"msg"]]) {
                err = result[@"msg"];
            }
            
            if (resultBlock) {
                resultBlock(nil, err);
            }
        }
    }else{
        resultBlock(nil,err);
    }
}


@end
