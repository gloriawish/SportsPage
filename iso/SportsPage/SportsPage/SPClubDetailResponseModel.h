//
//  SPClubDetailResponseModel.h
//  SportsPage
//
//  Created by Qin on 2017/3/7.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "JSONModel.h"

#import "SPSportsPageResponseModel.h"

//公告Model
@protocol SPClubDetailAnnResponseModel;
@interface SPClubDetailAnnResponseModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *annId;
@property (nonatomic,copy) NSString <Optional> *club_id;
@property (nonatomic,copy) NSString <Optional> *content;
@property (nonatomic,copy) NSString <Optional> *time;

@end

//俱乐部动态Model
@protocol SPClubDetailActiveModel;
@interface SPClubDetailActiveModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *club_id;
@property (nonatomic,copy) NSString <Optional> *type;
@property (nonatomic,copy) NSString <Optional> *desc;
@property (nonatomic,copy) NSString <Optional> *time;

@end

//俱乐部详情页请求返回Model
@class SPUserInfoModel;
@protocol SPUserInfoModel;

@protocol SPSportsPageModel;

@interface SPClubDetailResponseModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *clubId;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *clubDescription;
@property (nonatomic,copy) NSString <Optional> *capacity;
@property (nonatomic,copy) NSString <Optional> *join_type;      //1 不需要审核
                                                                //2 需要审核
                                                                //3 需要回答验证问题

@property (nonatomic,copy) NSString <Optional> *invite_type;    //1 不需要审核
                                                                //2 需要审核
@property (nonatomic,copy) NSString <Optional> *extend;
@property (nonatomic,copy) NSString <Optional> *level;
@property (nonatomic,copy) NSString <Optional> *portrait;
@property (nonatomic,copy) NSString <Optional> *sport_item;
@property (nonatomic,copy) NSString <Optional> *icon;

@property (nonatomic,copy) NSString <Optional> *vitality;
@property (nonatomic,copy) NSString <Optional> *max_vitality;

@property (nonatomic,copy) NSString <Optional> *question;
@property (nonatomic,copy) NSString <Optional> *answer;
@property (nonatomic,copy) NSString <Optional> *time;

@property (nonatomic,strong) SPUserInfoModel <Optional> *leader;
@property (nonatomic,strong) NSMutableArray <SPUserInfoModel> *top_member;

@property (nonatomic,copy) NSString <Optional> *member_count;

@property (nonatomic,copy) NSString <Optional> *op_permission;      //0 非俱乐部成员
                                                                    //1 普通成员
                                                                    //2 管理员
                                                                    //3 创建人

@property (nonatomic,strong) SPClubDetailAnnResponseModel <Optional> *ann;

@property (nonatomic,strong) NSMutableArray <SPSportsPageModel> *sports;

@property (nonatomic,strong) NSMutableArray <SPClubDetailActiveModel> *actives;

@property (nonatomic,copy) NSString <Optional> *group_id;

@end
