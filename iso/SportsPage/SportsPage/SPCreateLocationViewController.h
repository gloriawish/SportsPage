//
//  SPCreateLocationViewController.h
//  SportsPage
//
//  Created by Qin on 2016/12/5.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@protocol SPSportsCreateLocationProtocol <NSObject>

- (void)receiveDataWithName:(NSString *)locationName
                    address:(NSString *)address
                   latitude:(NSString *)latitude
                  longitude:(NSString *)longitude;

@end

@interface SPCreateLocationViewController : SPBaseViewController

@property (nonatomic,weak) id <SPSportsCreateLocationProtocol> delegate;
@property (nonatomic,readwrite,strong) UIImageView *windowImageView;

@end
