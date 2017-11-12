//
//  SPIMSendMessageShareClubModel.h
//  SportsPage
//
//  Created by Qin on 2017/3/31.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPIMSendMessageShareClubModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *clubId;
@property (nonatomic,copy) NSString <Optional> *imageUrl;
@property (nonatomic,copy) NSString <Optional> *shareTitle;
@property (nonatomic,copy) NSString <Optional> *content;

@end
