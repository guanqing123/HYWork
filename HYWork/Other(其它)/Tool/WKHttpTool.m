//
//  WKHttpTool.m
//  HYWork
//
//  Created by information on 2018/5/15.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKHttpTool.h"
#import "AFNetworking.h"

@implementation WKHttpTool

+ (void)postWithUrl:(NSString *)url param:(NSDictionary *)param success:(void (^)(id))succes failure:(void (^)(NSError *))failure {
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.发送请求
    [mgr POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        succes(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.发送请求
    [mgr GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

+ (void)getWithURLAndResponseText:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 2.发送请求
    [mgr GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    // 1.初始化 请求
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        int i = 0;
        for (UIImage *image in formDataArray) {
            i++;
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            NSString *fileName = [NSString stringWithFormat:@"fileName_%d.jpg",i];
            [formData appendPartWithFileData:data name:@"files" fileName:fileName mimeType:@"image/jpeg"];
        }
    } error:nil];
    
    // 2.创建 请求 管理对象
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }else{
            success(responseObject);
        }
    }];
    
    // 3.释放资源(我猜的)
    [uploadTask resume];
}

+ (BOOL)pifu {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"朴素风"];
}

@end
