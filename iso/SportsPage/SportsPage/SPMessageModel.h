//
//  SPMessageModel.h
//  SportsPage
//
//  Created by Qin on 2016/11/2.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPMessageModel : JSONModel

@property (nonatomic,readwrite,copy) NSString <Optional> *messageId;    //messageId
@property (nonatomic,readwrite,copy) NSString <Optional> *event_id;     //eventId
@property (nonatomic,readwrite,copy) NSString <Optional> *user_id;      //留言人id
@property (nonatomic,readwrite,copy) NSString <Optional> *nick;         //昵称
@property (nonatomic,readwrite,copy) NSString <Optional> *portrait;     //留言人头像url
@property (nonatomic,readwrite,copy) NSString <Optional> *reply_id;     //回复xxId
@property (nonatomic,readwrite,copy) NSString <Optional> *content;      //内容
@property (nonatomic,readwrite,copy) NSString <Optional> *status;       //状态
@property (nonatomic,readwrite,copy) NSString <Optional> *time;         //时间

@end
