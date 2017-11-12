//
//  SPClubInviteListResponseModel.h
//  SportsPage
//
//  Created by Qin on 2017/4/6.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@protocol SPClubInviteListModel;

@interface SPClubInviteListModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *requestId;
@property (nonatomic,copy) NSString <Optional> *type;
@property (nonatomic,copy) NSString <Optional> *club_id;
@property (nonatomic,copy) NSString <Optional> *from_id;
@property (nonatomic,copy) NSString <Optional> *to_id;
@property (nonatomic,copy) NSString <Optional> *extend;
@property (nonatomic,copy) NSString <Optional> *time;
@property (nonatomic,copy) NSString <Optional> *status;
@property (nonatomic,copy) NSString <Optional> *process_id;
@property (nonatomic,copy) NSString <Optional> *process_time;
@property (nonatomic,copy) NSString <Optional> *club_name;
@property (nonatomic,copy) NSString <Optional> *icon;

@end

@interface SPClubInviteListResponseModel : JSONModel

@property (nonatomic,strong) NSMutableArray <SPClubInviteListModel> *data;

@end
