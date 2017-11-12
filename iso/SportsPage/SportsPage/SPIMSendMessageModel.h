//
//  SPIMSendMessageModel.h
//  SportsPage
//
//  Created by Qin on 2016/12/16.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPIMSendMessageModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *eventId;
@property (nonatomic,copy) NSString <Optional> *imageUrl;
@property (nonatomic,copy) NSString <Optional> *shareTitle;
@property (nonatomic,copy) NSString <Optional> *content;

@end
