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
#define UTAppKey @"app_5d3db0aa9a6b9d5a93"
#define UTAppSecret @"a0856b6e255e5fba92bdd6ec372904c9"
#define UTRSAPublicKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMExNYYe738kgPa1VEKr9cG7A9wAfDwOsa2CbtT+Kx2GKq94WQS5joc5QyEtF2Sxt62TClS66LXnrOY+h7m1VyjKS4opADWfGAucPF1C9Gwtfh+drGi4TV9cpH5ln5LvE1luW8bT7HbnxvaFQZzxQzl9+5nbpphNb+HbLAXtNG+nAgMBAAECgYEArTGxe0DGkqQmHYZoOLEyy/AdwKCKv8iojxWMyNPn0TsTj2WD4JF9bkrunJJxE2ujcC+PJnC96T3+KhfK07j3neFdUX69p/KuO42ejTV/vLUawtbdQ9Gc7jde2FurYt7DQJvhWrRSn/EucLgUz4q77i5iV5WAUHvpRigF8VpNiSkCQQDs0LXrjTw9IsOvk1xeYefpBwWQuLPzMxFSdmIGt5pJMWDK99IMv+HPcoVjbITOg3frX/ZdqQmNuHjZ8OYIMCGbAkEA0NfN2z/sAkSx2EkLiqyfz2XMqd9iqtNPGOYHyy4PKlv1dhRwShBQ4RHiwNNAuI1+9UQtHIURPg9AY8uYbokg5QJBAM652zUHE8DiqiSI5SdXHFVl1cviEOSKfeKYiTYH7N1cB3znHSwYDQ1EkYCbaMvGJFcKbEySlU5r7MOD8arQKWUCQDZr5hL6R1AYApgwALf0X/i1uG2T7qxBQF1mpCVILV+GcyKAFPrX4ZulA4foBPeSt8DGMVM7QdEAPHFE/sXfKhkCQQDalJLWlfGMYqK/oAAFbAe6vJnYPpJ0hEyTlmmPbQnbboYRPMEWxABiLl9RNRiiw0XVDB16F23kMccOjV5BSV7n"
#define NetWorkConnectFailedDescription @"网络连接失败"

typedef void (^ApiSuccessCallback)(NSNumber *statusCode,id responseObject);
typedef void (^ApiFailedCallback)(NSError *error);

typedef void (^ApiDownloadFileProgress)(NSProgress *downloadProgress);

typedef void (^APIRequstCallBack)(NSNumber *statusCode,NSNumber *code, id data, id errorMsg);

#endif /* NetWorkHelper_h */
