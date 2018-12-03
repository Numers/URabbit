//
//  Member.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/11/23.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "Member.h"

@implementation Member
/**
 字典初始化对象
 
 @param dic 用户信息字典
 @return 用户对象
 */
-(instancetype)initWithDictionary:(NSDictionary *)dic;
{
    self = [super init];
    if (self) {
        if (dic) {
            self.memberId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            self.nickName = [dic objectForKey:@"nickname"];
            self.token = [dic objectForKey:@"token"];
            self.headIcon = [dic objectForKey:@"portrait"];
            _isVip = [[dic objectForKey:@"isVip"] boolValue];
            _vipExpire = [[dic objectForKey:@"vipExpire"] doubleValue];
            
            _accountList = [NSMutableArray array];
            NSArray *accounts = [dic objectForKey:@"account"];
            if (accounts && accounts.count > 0) {
                for (NSDictionary *accountDic in accounts) {
                    Account *account = [[Account alloc] initWithDictionary:accountDic];
                    [_accountList addObject:account];
                }
            }
            
            id templates = [dic objectForKey:@"templetId"];
            if (templates) {
                _saveTemplates = [NSMutableArray arrayWithArray:templates];
            }else{
                _saveTemplates = [NSMutableArray array];
            }
        }
    }
    return self;
}


/**
 将用户对象转义成字典
 
 @return 用户信息字典
 */
-(NSDictionary *)dictionaryInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_memberId) {
        [dic setObject:_memberId forKey:@"id"];
    }
    
    if (_nickName) {
        [dic setObject:_nickName forKey:@"nickname"];
    }
    
    if (_headIcon) {
        [dic setObject:_headIcon forKey:@"portrait"];
    }
    
    if (_token) {
        [dic setObject:_token forKey:@"token"];
    }
    
    [dic setObject:@(_isVip) forKey:@"isVip"];
    [dic setObject:@(_vipExpire) forKey:@"vipExpire"];
    
    if (_accountList && _accountList.count > 0) {
        NSMutableArray *accounts = [NSMutableArray array];
        for (Account *account in _accountList) {
            NSDictionary *accountDic = [account dictionaryInfo];
            [accounts addObject:accountDic];
        }
        [dic setObject:accounts forKey:@"account"];
    }
    
    [dic setObject:_saveTemplates forKey:@"templetId"];
    return dic;
}
@end
