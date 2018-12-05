//
//  NetWorkManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 16/10/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "NetWorkManager.h"
#import "UIImage+FixImage.h"
static NetWorkManager *scNetWorkManager;
@implementation NetWorkManager
+(id)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (scNetWorkManager == nil) {
            scNetWorkManager = [[NetWorkManager alloc] init];
        }
    });
    return scNetWorkManager;
}

-(void)post:(NSString *)uri parameters:(id)parameters success:(ApiSuccessCallback)success failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,uri];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TimeOut];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[AppUtils token] forHTTPHeaderField:@"Auth-Token"];
    [request setValue:SignatureAPPKey forHTTPHeaderField:@"Glp-Appid"];

    
    //    NSData --> NSDictionary
         // NSDictionary --> NSData
    if (parameters) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = data;
    }
    
         // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failed(connectionError);
        }else{
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            NSInteger statusCode =  res.statusCode;
            if (data) {
                id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(@(statusCode),obj);
            }else{
                success(@(statusCode),nil);
            }
        }
    }];
}

-(void)postSync:(NSString *)uri parameters:(id)parameters success:(ApiSuccessCallback)success failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,uri];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TimeOut];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[AppUtils token] forHTTPHeaderField:@"Auth-Token"];
    [request setValue:SignatureAPPKey forHTTPHeaderField:@"Glp-Appid"];
    
    
    //    NSData --> NSDictionary
    // NSDictionary --> NSData
    if (parameters) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = data;
    }
    
    //第三步，连接服务器
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        failed(error);
    }else{
        if (received) {
            id obj = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
            success(nil,obj);
        }else{
            success(nil,nil);
        }
    }
}


-(void)get:(NSString *)uri parameters:(id)parameters success:(ApiSuccessCallback)success failed:(ApiFailedCallback)failed
{
    NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"%@%@",API_BASE,uri];
    if (parameters && [parameters allKeys].count > 0) {
        [url appendString:@"?"];
        for (NSString *key in [parameters allKeys]) {
            NSString *value = [parameters objectForKey:key];
            [url appendFormat:@"%@=%@",key,value];
            if (![key isEqualToString:[[parameters allKeys] lastObject]]) {
                [url appendFormat:@"&"];
            }
        }
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TimeOut];
    request.HTTPMethod = @"GET";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[AppUtils token] forHTTPHeaderField:@"Auth-Token"];
    [request setValue:SignatureAPPKey forHTTPHeaderField:@"Glp-Appid"];
    
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failed(connectionError);
        }else{
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            NSInteger statusCode =  res.statusCode;
            if (data) {
                id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(@(statusCode),obj);
            }else{
                success(@(statusCode),nil);
            }
        }
    }];

}

-(void)getSync:(NSString *)uri parameters:(id)parameters success:(ApiSuccessCallback)success failed:(ApiFailedCallback)failed
{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_BASE,uri]];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TimeOut];
    [request setHTTPMethod:@"GET"];//设置请求方式为POST，默认为GET
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[AppUtils token] forHTTPHeaderField:@"Auth-Token"];
    [request setValue:SignatureAPPKey forHTTPHeaderField:@"Glp-Appid"];
    
    if (parameters) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = data;
    }
    //第三步，连接服务器
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        failed(error);
    }else{
        if (received) {
            id obj = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
            success(nil,obj);
        }else{
            success(nil,nil);
        }
    }
}

-(void)put:(NSString *)uri parameters:(id)parameters success:(ApiSuccessCallback)success failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,uri];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TimeOut];
    request.HTTPMethod = @"PUT";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[AppUtils token] forHTTPHeaderField:@"Auth-Token"];
    [request setValue:SignatureAPPKey forHTTPHeaderField:@"Glp-Appid"];
    
    
    //    NSData --> NSDictionary
    // NSDictionary --> NSData
    if (parameters) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = data;
    }
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failed(connectionError);
        }else{
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            NSInteger statusCode =  res.statusCode;
            if (data) {
                id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(@(statusCode),obj);
            }else{
                success(@(statusCode),nil);
            }
        }
    }];
}


- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(NSURL *filePath))success
               downloadFailure:(ApiFailedCallback)failure
                      progress:(ApiDownloadFileProgress)progress
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:savedPath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (error) {
            failure(error);
        }else{
            success(filePath);
        }
    }];
    [downloadTask resume];
}


-(void)uploadImage:(UIImage *)image uri:(NSString *)uri parameters:(id)parameters  success:(ApiSuccessCallback)success failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,uri];
    AFHTTPSessionManager *requestManager = [AFHTTPSessionManager manager];
    [requestManager.requestSerializer setTimeoutInterval:TimeOut];
    [requestManager.requestSerializer setValue:[AppUtils token] forHTTPHeaderField:@"Auth-Token"];
    [requestManager.requestSerializer setValue:SignatureAPPKey forHTTPHeaderField:@"Glp-Appid"];
    [requestManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        UIImage *fixImage = [image fixOrientationWithSize:CGSizeMake(96.0f, 96.0f)];
        NSData *imageData = UIImagePNGRepresentation(fixImage);
        if (imageData == nil) {
            imageData = UIImageJPEGRepresentation(image, 1.0f);
        }
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"head.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        success(@(response.statusCode),responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
    }];
}
@end
