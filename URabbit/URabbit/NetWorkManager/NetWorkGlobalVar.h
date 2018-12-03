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
#define UT_Login_API @"/user/login/mobile"
#define UT_ValidateCode_API @"/checkcode/send"
#define UT_ValidateCheck_API @"checkcode/check"
#define UT_PlatformLogin_API @"/user/login/platform"
/************************首页API***********************/
#define UT_NewTemplate_API @"/templet/list/new"
#define UT_ChoiceRecommend_API @"/templet/list/recommend"
/*******************************************************/

/************************模板API***********************/
#define UT_TemplateDetails_API @"/templet/{id}"
#define UT_SaveTemplate_API @"/templet/{id}/collect/add"
#define UT_CancelSaveTemplate_API @"/templet/{id}/collect/delete"
/*******************************************************/

/************************个人中心API***********************/
#define UT_UserSavedTemplate_API @"/user/templet/list"
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
