//
//  SPUserInfoModel.h
//  SportsPage
//
//  Created by absolute on 2016/10/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPUserInfoModel : JSONModel

@property (nonatomic,readwrite,copy) NSString <Optional> *userId;
@property (nonatomic,readwrite,copy) NSString <Optional> *uname;
@property (nonatomic,readwrite,copy) NSString <Optional> *mobile;
//@property (nonatomic,readwrite,copy) NSString <Optional> *password;
//@property (nonatomic,readwrite,copy) NSString <Optional> *paypass;
@property (nonatomic,readwrite,copy) NSString <Optional> *nick;
@property (nonatomic,readwrite,copy) NSString <Optional> *sex;      
@property (nonatomic,readwrite,copy) NSString <Optional> *email;    
@property (nonatomic,readwrite,copy) NSString <Optional> *idcard;   
@property (nonatomic,readwrite,copy) NSString <Optional> *area;     
@property (nonatomic,readwrite,copy) NSString <Optional> *city;     
@property (nonatomic,readwrite,copy) NSString <Optional> *portrait;
@property (nonatomic,readwrite,copy) NSString <Optional> *wx_openid;
@property (nonatomic,readwrite,copy) NSString <Optional> *wxpub_openid;
@property (nonatomic,readwrite,copy) NSString <Optional> *unionid;
@property (nonatomic,readwrite,copy) NSString <Optional> *token;
@property (nonatomic,readwrite,copy) NSString <Optional> *channel;
@property (nonatomic,readwrite,copy) NSString <Optional> *login_time;
@property (nonatomic,readwrite,copy) NSString <Optional> *reg_time;
@property (nonatomic,readwrite,copy) NSString <Optional> *relation;
@property (nonatomic,readwrite,copy) NSString <Optional> *portrait_status;
@property (nonatomic,readwrite,copy) NSString <Optional> *valid;

@property (nonatomic,readwrite,copy) NSString <Ignore> *remark;
@property (nonatomic,readwrite,copy) NSString <Ignore> *pinyinNick;     //ignore contacts使用

@property (nonatomic,readwrite,copy) NSString <Ignore> *isAddIcon;

@end
