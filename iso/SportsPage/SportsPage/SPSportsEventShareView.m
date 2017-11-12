//
//  SPSportsEventShareView.m
//  SportsPage
//
//  Created by Qin on 2016/12/14.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsEventShareView.h"
#import "SPSportsShareViewController.h"

#import "WXApi.h"

@interface SPSportsEventShareView () {
    NSString *_eventId;
    NSString *_title;
    NSString *_time;
    NSString *_location;
    UIImage *_image;
    NSString *_shareUrl;
}

@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;

@property (weak, nonatomic) IBOutlet UIButton *weChatSessionButton;
@property (weak, nonatomic) IBOutlet UILabel *weChatSessionLabel;

@property (weak, nonatomic) IBOutlet UIButton *weChatTimeLineButton;
@property (weak, nonatomic) IBOutlet UILabel *weChatTimeLineLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@end

@implementation SPSportsEventShareView

- (void)awakeFromNib {
    [super awakeFromNib];
    _leftLineView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    _rightLineView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    if (![WXApi isWXAppInstalled]) {
        _weChatSessionButton.hidden = true;
        _weChatSessionLabel.hidden = true;
        _weChatTimeLineButton.hidden = true;
        _weChatTimeLineLabel.hidden = true;
        
        _rightConstraint.constant = SCREEN_WIDTH/2-25;
    }
    
}

- (void)setUpWithTitle:(NSString *)title time:(NSString *)time location:(NSString *)location image:(UIImage *)image eventId:(NSString *)eventId {
    _eventId = eventId;
    _title = title;
    _time = [time substringWithRange:NSMakeRange(0, 16)];
    _location = location;
    _image = [self imageWithImage:image scaledToSize:CGSizeMake(100, 100)];
    _shareUrl = [NSString stringWithFormat:[SPPathConfig getShareH5Url],@"1",_eventId];
}

- (IBAction)shareWeChatFriendsAction:(id)sender {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _title;
    message.description = [NSString stringWithFormat:@"%@\n%@",_time,_location];
    [message setThumbImage:_image];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = _shareUrl;
    
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = false;
    req.message = message;
    req.scene = WXSceneSession;
    if (![WXApi sendReq:req]) {
        NSLog(@"没有成功");
    }
}

- (IBAction)shareWeChatAction:(id)sender {
    NSLog(@"分享到微信朋友圈");
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _title;
    message.description = [NSString stringWithFormat:@"%@\n%@",_time,_location];
    [message setThumbImage:_image];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = _shareUrl;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = false;
    req.message = message;
    req.scene = WXSceneTimeline;
    if (![WXApi sendReq:req]) {
        NSLog(@"没有成功");
    }
}

- (IBAction)shareWeChatSportsPageAction:(id)sender {
    NSLog(@"分享到运动页");
    SPSportsShareViewController *shareViewController = [[SPSportsShareViewController alloc] init];
    shareViewController.type = @"eventShare";
    [_sportsEventViewController.navigationController pushViewController:shareViewController animated:true];
}

- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImageJPEGRepresentation(newImage, 0.3);
    return [UIImage imageWithData:data];
}

@end
