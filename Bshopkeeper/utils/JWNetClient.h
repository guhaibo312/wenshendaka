//
//  JWNetClient.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"


typedef void(^responseCallBlock)( id responObject, NSString *errmsg);

@interface JWNetClient : AFHTTPRequestOperationManager

+ (instancetype)defaultJWNetClient;


/**post 请求方式 参数
 * @actionStr 方法名称  @parm   请求的参数  @object 响应的对象
 */
- (void)postNetClient:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock;

/**get 请求方式 参数
 * @actionStr 方法名称  @parm   请求的参数  @object 响应的对象
 */
- (void)getNetClient:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock;

/**put 请求方式 参数
 * @actionStr 方法名称  @parm   请求的参数  @object 响应的对象
 */
- (void)putNetClient:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock;
/**delete 请求方式 参数
 * @actionStr 方法名称  @parm   请求的参数  @object 响应的对象
 */
- (void)deleteNetClient:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock;



/* －－－－－－－－－－－－－－－－－－－－－－－－ 广场 3366 端口－－－－－－－－－－－－－－－－－－－－*/

- (AFHTTPRequestOperation *)squarePost:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock;

- (AFHTTPRequestOperation *)squareGet:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock;

- (AFHTTPRequestOperation *)squarePut:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock;

- (AFHTTPRequestOperation *)squareDelegate:(NSString *)actionStr requestParm:(NSDictionary *)parm result:(responseCallBlock)resultBlock;


 
 

@end
