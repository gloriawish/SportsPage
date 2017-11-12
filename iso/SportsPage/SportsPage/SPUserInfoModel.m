//
//  SPUserInfoModel.m
//  SportsPage
//
//  Created by absolute on 2016/10/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPUserInfoModel.h"

@implementation SPUserInfoModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _userId = @"";
        _uname = @"";
        _mobile = @"";
        _nick = @"";
        _sex = @"";
        _email = @"";
        _idcard = @"";
        _area = @"";
        _city = @"";
        _portrait = @"";
        _wx_openid = @"";
        _wxpub_openid = @"";
        _unionid = @"";
        _token = @"";
        _channel = @"";
        _login_time = @"";
        _reg_time = @"";
        _relation = @"";
        _portrait_status = @"";
        _valid = @"";
        
        _remark = @"";
        _pinyinNick = @"";
        
        _isAddIcon = @"";
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"userId":@"id"}];
}

@end
