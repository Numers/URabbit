//
//  NetWorkManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 16/10/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "NetWorkManager.h"
#import "UIImage+FixImage.h"
#import "RSA.h"
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

-(NSMutableDictionary *)headerDictionary
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970] * 1000;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *token = [AppUtils token];
    if (![AppUtils isNullStr:token]) {
        [dic setObject:[AppUtils token] forKey:@"Auth-Token"];
    }
    [dic setObject:UTAppKey forKey:@"UT-App-Key"];
    [dic setObject:@"ios" forKey:@"User-Agent-Platform"];
    [dic setObject:UTAppSecret forKey:@"UT-App-Secret"];
    [dic setObject:[NSString stringWithFormat:@"%.0f",now] forKey:@"UT-Timestamp"];
    return dic;
}

-(NSString *)md5Pvk
{
    return @"13A7EF3DB15B7DF96607F204D197625F";
}

-(NSData *)decodeData:(NSData *)data{
    if (data == nil || data.length==0) {
        return data;
    }
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([str hasPrefix:@"{"] && [str hasSuffix:@"}"]) {
        return data;
    }
    NSString *ret = [[NSString alloc ] initWithData:[[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
    if (ret.length == 0) {
        return data;
    }
    ret = [ret stringByReplacingOccurrencesOfString:[self md5Pvk] withString:@""];
    ret = [RSA decryptString:ret privateKey:UTRSAPublicKey];
    NSData *retData = [ret dataUsingEncoding:NSUTF8StringEncoding];
    return retData;
}

-(NSString *)signatureStringWithDictionary:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    NSMutableString *containerString = [[NSMutableString alloc] initWithString:@"{"];
    NSArray *sortArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch|
                NSWidthInsensitiveSearch|NSForcedOrderingSearch];
    }];
    for (NSString *key in sortArray) {
        [containerString appendFormat:@"\"%@\":\"%@\"",key,[dic objectForKey:key]];
        if (![key isEqualToString:[sortArray lastObject]]) {
            [containerString appendString:@","];
        }
    }
    [containerString appendString:@"}"];
    NSString *signature = [AppUtils getMd5_32Bit:containerString];
    return signature;
}

-(void)post:(NSString *)uri parameters:(id)parameters success:(ApiSuccessCallback)success failed:(ApiFailedCallback)failed
{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_BASE,uri];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TimeOut];
    request.HTTPMethod = @"POST";
    
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *headerDic = [self headerDictionary];
    for (NSString *key in [headerDic allKeys]) {
        if (![key isEqualToString:@"UT-App-Secret"]) {
            [request setValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
        }
    }
    NSString *signature = [self signatureStringWithDictionary:headerDic];
    if (signature) {
        [request setValue:signature forHTTPHeaderField:@"UT-Signature"];
    }
    
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
                NSData *decodeData = [self decodeData:data];
                id obj = [NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableContainers error:nil];
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
    NSMutableDictionary *headerDic = [self headerDictionary];
    for (NSString *key in [headerDic allKeys]) {
        if (![key isEqualToString:@"UT-App-Secret"]) {
            [request setValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
        }
    }
    NSString *signature = [self signatureStringWithDictionary:headerDic];
    if (signature) {
        [request setValue:signature forHTTPHeaderField:@"UT-Signature"];
    }
    
    
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
            NSData *decodeData = [self decodeData:received];
            id obj = [NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableContainers error:nil];
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
    NSMutableDictionary *headerDic = [self headerDictionary];
    for (NSString *key in [headerDic allKeys]) {
        if (![key isEqualToString:@"UT-App-Secret"]) {
            [request setValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
        }
    }
    NSString *signature = [self signatureStringWithDictionary:headerDic];
    if (signature) {
        [request setValue:signature forHTTPHeaderField:@"UT-Signature"];
    }
    
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            failed(connectionError);
        }else{
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            NSInteger statusCode =  res.statusCode;
            if (data) {
                NSData *decodeData = [self decodeData:data];
                id obj = [NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableContainers error:nil];
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
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *headerDic = [self headerDictionary];
    for (NSString *key in [headerDic allKeys]) {
        if (![key isEqualToString:@"UT-App-Secret"]) {
            [request setValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
        }
    }
    NSString *signature = [self signatureStringWithDictionary:headerDic];
    if (signature) {
        [request setValue:signature forHTTPHeaderField:@"UT-Signature"];
    }
    
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
            NSData *decodeData = [self decodeData:received];
            id obj = [NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableContainers error:nil];
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
    NSMutableDictionary *headerDic = [self headerDictionary];
    for (NSString *key in [headerDic allKeys]) {
        if (![key isEqualToString:@"UT-App-Secret"]) {
            [request setValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
        }
    }
    NSString *signature = [self signatureStringWithDictionary:headerDic];
    if (signature) {
        [request setValue:signature forHTTPHeaderField:@"UT-Signature"];
    }
    
    
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
                NSData *decodeData = [self decodeData:data];
                id obj = [NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableContainers error:nil];
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
    
    // 2.设置请求头
    [requestManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *headerDic = [self headerDictionary];
    for (NSString *key in [headerDic allKeys]) {
        if (![key isEqualToString:@"UT-App-Secret"]) {
            [requestManager.requestSerializer setValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
        }
    }
    NSString *signature = [self signatureStringWithDictionary:headerDic];
    if (signature) {
        [requestManager.requestSerializer setValue:signature forHTTPHeaderField:@"UT-Signature"];
    }
    
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
        NSData *decodeData = [self decodeData:responseObject];
        id obj = [NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableContainers error:nil];
        success(@(response.statusCode),decodeData);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
    }];
}
@end
