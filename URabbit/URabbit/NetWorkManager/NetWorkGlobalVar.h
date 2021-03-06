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
#define UT_CategoryRecommend_API @"/category/recommend"
#define UT_NewTemplate_API @"/templet/list/new"
#define UT_ChoiceRecommend_API @"/templet/list/recommend"
/*******************************************************/

/************************分类模板API***********************/
#define UT_CategoryTemplateList_API @"/category/{id}/templet"
/*******************************************************/

/************************作者API***********************/
#define UT_Author_API @"/author/{id}"
#define UT_AuthorComposition_API @"/author/{id}/templet"
/*******************************************************/

/************************模板API***********************/
#define UT_TemplateDetails_API @"/templet/{id}"
#define UT_SaveTemplate_API @"/templet/{id}/collect/add"
#define UT_CancelSaveTemplate_API @"/templet/{id}/collect/delete"
/*******************************************************/

/************************个人中心API***********************/
#define UT_UserSavedTemplate_API @"/user/templet/list"
#define UT_VIPPriceList_API @"/vip/price"
#define UT_VIPBuy_API @"/vip/buy"
/*******************************************************/

/************************音乐列表API***********************/
#define UT_RecommendMusicList_API @"/music/list/{templetId}"
/*******************************************************/

/************************UpdateVersionAPI***********************/
#define UT_UpdateVersion_API @"/config/app/version"
/*******************************************************/

/************************ShareConfigAPI***********************/
#define UT_ShareConfig_API @"/config"
/*******************************************************/

/************************UploadRegIdAPI***********************/
#define UP_SendRegId_API @"/app/sendRegId"
/*******************************************************/
/*******************************************************/
#define UT_ServiceToken @"6c9691b1-261c-4b08-a2ef-484606f76cfe"

#endif /* NetWorkGlobalVar_h */
