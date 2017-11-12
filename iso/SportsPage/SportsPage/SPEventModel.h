//
//  SPEventModel.h
//  SportsPage
//
//  Created by Qin on 2016/11/1.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"
#import "SPUserInfoModel.h"
#import "SPMessageModel.h"

@protocol SPUserInfoModel;
@protocol SPMessageModel;

@interface SPEventModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *sportId;            //sportId
@property (nonatomic,copy) NSString <Optional> *event_id;           //eventId

@property (nonatomic,copy) NSString <Optional> *attetion;           //关注状态 0未关注 1已关注

@property (nonatomic,copy) NSString <Optional> *relation;           //是否好友关系 -1表示自己 0非好友 1好友

@property (nonatomic,copy) NSString <Optional> *title;              //运动名
@property (nonatomic,copy) NSString <Optional> *summary;            //活动描述
@property (nonatomic,copy) NSString <Optional> *sport_type;         //运动种类
@property (nonatomic,copy) NSString <Optional> *sport_item;         //运动项目 如羽毛球 足球 篮球...1..2..3 20,自定义
@property (nonatomic,copy) NSString <Optional> *extend;             //运动项目 自定义
@property (nonatomic,copy) NSString <Optional> *team_type;          //组队类型
@property (nonatomic,copy) NSString <Optional> *charge_type;        //支付方式 1线上 2线下
@property (nonatomic,copy) NSString <Optional> *privacy;            //是否公开 1不公开 2公开
@property (nonatomic,copy) NSString <Optional> *level;              //运动等级 1简单 2一般 3困难
@property (nonatomic,copy) NSString <Optional> *grade;              //星级，返回形如"1.5","4"

@property (nonatomic,copy) NSString <Optional> *status;             //活动状态 1报名中 2已锁定 3进行中 4已取消 5已结束
@property (nonatomic,copy) NSString <Optional> *user_status;        //用户对于该活动状态 返回形如 "报名" "已报名"

@property (nonatomic,copy) NSString <Optional> *min_number;         //最小参与人数
@property (nonatomic,copy) NSString <Optional> *max_number;         //最大参与人数
@property (nonatomic,copy) NSString <Optional> *price;              //价格 元/人

@property (nonatomic,copy) NSString <Optional> *location;           //位置
@property (nonatomic,copy) NSString <Optional> *location_detail;    //位置详情
@property (nonatomic,copy) NSString <Optional> *place;              //位置描述
@property (nonatomic,copy) NSString <Optional> *latitude;           //经度
@property (nonatomic,copy) NSString <Optional> *longitude;          //维度

@property (nonatomic,copy) NSString <Optional> *start_time;         //开始时间 形如"2016-11-02 12:10:59"
@property (nonatomic,copy) NSString <Optional> *end_time;           //结束时间 形如"2016-11-02 12:10:59"
@property (nonatomic,copy) NSString <Optional> *duration;           //持续时间

@property (nonatomic,strong) SPUserInfoModel <Optional> *user_id;               //发起者,userInfoModel
@property (nonatomic,strong) NSMutableArray <SPUserInfoModel> *enrollUsers;     //参与人的userModelArray

@property (nonatomic,strong) NSMutableArray <NSString *> *_portrait;            //header,ScrollView的UrlArray
@property (nonatomic,strong) NSMutableArray <SPMessageModel> *messages;         //留言Array

@end
