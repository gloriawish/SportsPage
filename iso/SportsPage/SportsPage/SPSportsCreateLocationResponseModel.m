//
//  SPSportsCreateLocationResponseModel.m
//  SportsPage
//
//  Created by Qin on 2016/12/5.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsCreateLocationResponseModel.h"

@implementation SPSportsCreateLocationResponseModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _city = @"";
        _name = @"";
        _address = @"";
        _latitude = @"";
        _longitude = @"";
        _image_url = @"";
        _category = @"";
        _phone = @"";
        _geohash = @"";
    }
    return self;
}

@end
