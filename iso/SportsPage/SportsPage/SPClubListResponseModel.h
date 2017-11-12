//
//  SPClubListResponseModel.h
//  SportsPage
//
//  Created by Qin on 2017/3/14.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@protocol SPClubListModel;
@interface SPClubListModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *clubId;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *clubDescription;
@property (nonatomic,copy) NSString <Optional> *capacity;
@property (nonatomic,copy) NSString <Optional> *join_type;
@property (nonatomic,copy) NSString <Optional> *invite_type;
@property (nonatomic,copy) NSString <Optional> *extend;
@property (nonatomic,copy) NSString <Optional> *level;
@property (nonatomic,copy) NSString <Optional> *portrait;
@property (nonatomic,copy) NSString <Optional> *sport_item;
@property (nonatomic,copy) NSString <Optional> *icon;
@property (nonatomic,copy) NSString <Optional> *vitality;
@property (nonatomic,copy) NSString <Optional> *question;
@property (nonatomic,copy) NSString <Optional> *answer;
@property (nonatomic,copy) NSString <Optional> *time;
@property (nonatomic,copy) NSString <Optional> *max_vitality;
@property (nonatomic,copy) NSString <Optional> *member_count;
@property (nonatomic,copy) NSString <Optional> *sport_count;

@end

@interface SPClubListResponseModel : JSONModel

@property (nonatomic,strong) NSMutableArray <SPClubListModel> *create;
@property (nonatomic,strong) NSMutableArray <SPClubListModel> *join;
@property (nonatomic,strong) NSMutableArray <SPClubListModel> *admin;

@end
