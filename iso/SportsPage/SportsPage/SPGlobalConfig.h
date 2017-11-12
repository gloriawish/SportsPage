//
//  Config.h
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface SPGlobalConfig : NSObject

+ (UIColor *)themeColor;
+ (UIColor *)anyColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (void)showTextOfHUD:(NSString *)text ToView:(UIView *)view;

+ (NSString *)convertToPinYin:(NSString *)inputString;

+ (NSString *)toJsonString:(NSDictionary *)dic;

+ (CLLocationCoordinate2D)changeCOMMONCoordinateToBaidu:(CLLocationCoordinate2D)coordinate;

@end
