//
//  NetWorkHelper.h
//  GLPFinance
//
//  Created by 鲍利成 on 16/10/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#ifndef NetWorkHelper_h
#define NetWorkHelper_h
#import "AFNetworking.h"
#import "NetWorkGlobalVar.h"
typedef enum{
    SUCCESSREQUEST = 2000,
    NONEDATA,
    PARAMETERERROR,
    DATAEXCEPTION,
    ILLEGALREQUEST,
    UPDATEFAILED,
    WARNTYPE
}STATUSCODE;
#define TimeOut 15.0f
#define SignatureAPPKey ISTEST ? @"GLPbf5bf2af0b74d1ea" : @"GLPa7578b3975dd6ddb"
#define NetWorkConnectFailedDescription @"网络连接失败"

typedef void (^ApiSuccessCallback)(NSNumber *statusCode,id responseObject);
typedef void (^ApiFailedCallback)(NSError *error);

typedef void (^ApiDownloadFileProgress)(NSProgress *downloadProgress);

typedef void (^APIRequstCallBack)(NSNumber *statusCode,NSNumber *code, id data, id errorMsg);

#endif /* NetWorkHelper_h */
