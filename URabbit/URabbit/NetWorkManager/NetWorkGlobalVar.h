//
//  NetWorkGlobalVar.h
//  GLPFinance
//
//  Created by 鲍利成 on 16/10/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#ifndef NetWorkGlobalVar_h
#define NetWorkGlobalVar_h

/*********************API接口****************************/
/************************登录API***********************/
#define UT_Login_API @""
/************************首页API***********************/
#define UT_NewTemplate_API @"/templet/list/new"
#define UT_ChoiceRecommend_API @"/templet/list/recommend"
/*******************************************************/

/************************模板详情API***********************/
#define UP_TemplateDetails_API @"/templet/{id}"
/*******************************************************/

/************************SystemInfoAPI***********************/
#define UP_systemInfo_API @"/api/app/listApp"
#define UP_Report_API @"/api/app/report"
#define UP_Report_Customer_API @"/api/app/report/customer"
#define UP_Report_Project_API @"/api/app/report/project"
#define UP_Report_Manager_Rank_API @"/api/app/report/manager/rank/use"
/*******************************************************/

/************************UpdateVersionAPI***********************/
#define UP_UpdateVersion_API @"/account/app/version/latest"
/*******************************************************/

/************************UploadRegIdAPI***********************/
#define UP_SendRegId_API @"/app/sendRegId"
/*******************************************************/
/*******************************************************/

#endif /* NetWorkGlobalVar_h */
