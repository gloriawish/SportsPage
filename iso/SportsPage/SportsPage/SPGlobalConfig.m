//
//  Config.m
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPGlobalConfig.h"

#import "MBProgressHUD.h"
#import "PinYin4Objc.h"

@implementation SPGlobalConfig

+ (UIColor *)themeColor {
    return [self anyColorWithRed:13.0 green:136.0 blue:235.0 alpha:1];
}

+ (UIColor *)anyColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+ (void)showTextOfHUD:(NSString *)text ToView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.label.text = text;
    hud.mode = MBProgressHUDModeText;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:true];
    });
}

+ (NSString *)convertToPinYin:(NSString *)inputString {
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:inputString withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
    return outputPinyin;
}

+ (NSString *)toJsonString:(NSDictionary *)dic {
    NSArray *allKeys = [dic allKeys];
    NSMutableString *jsonString = [[NSMutableString alloc] initWithString:@"{"];
    for (int i=0; i<allKeys.count; i++) {
        NSString *key = allKeys[i];
        [jsonString appendFormat:@"\"%@\":\"%@\"",key,dic[key]];
        if (i != allKeys.count-1) {
            [jsonString appendString:@","];
        } else {
            [jsonString appendString:@"}"];
        }
    }
    return jsonString;
}

+ (CLLocationCoordinate2D)changeCOMMONCoordinateToBaidu:(CLLocationCoordinate2D)coordinate {
    double PI = 3.14159265358979324 * 3000.0 / 180.0;
    double longitude = coordinate.longitude;
    double latitude = coordinate.latitude;
    double parameter = sqrt(longitude * longitude + latitude * latitude) + 0.00002 * sin(latitude * PI);
    double theta = atan2(latitude, longitude) + 0.000003 * cos(longitude * PI);
    double Baidu_longitude = parameter * cos(theta) + 0.0065;
    double Baidu_latitude = parameter * sin(theta)+ 0.006;
    CLLocationCoordinate2D  Baidu_Coordinate = CLLocationCoordinate2DMake(Baidu_latitude, Baidu_longitude);
    return Baidu_Coordinate;
}

@end
