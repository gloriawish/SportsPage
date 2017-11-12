//
//  PathClass.h
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPPathConfig : NSObject

+ (NSString *)getGlobalConf;

#pragma mark - H5
+ (NSString *)getShareH5Url;

#pragma mark - Main
+ (NSString *)getHotEvent;
+ (NSString *)getFollowEvent;
+ (NSString *)searchEvent;

#pragma mark - SportsPage
+ (NSString *)getSport;
+ (NSString *)getLastEvent;
+ (NSString *)getMineSport;
+ (NSString *)follow;
+ (NSString *)cancelFollow;
+ (NSString *)getFollows;
+ (NSString *)activateSport;
+ (NSString *)createSport;
+ (NSString *)editSport;
+ (NSString *)getSportEvents;

#pragma mark - Event
+ (NSString *)dismissEvent;
+ (NSString *)enrollEvent;
+ (NSString *)exitEvent;
+ (NSString *)getEnrollUser;
+ (NSString *)getEvent;
+ (NSString *)getMessage;
+ (NSString *)lock;
+ (NSString *)postAppraise;
+ (NSString *)settlementEvent;
+ (NSString *)postMessage;
+ (NSString *)unlock;

#pragma mark - Location
+ (NSString *)getNearbyEvent;
+ (NSString *)getNearbyPlace;
+ (NSString *)searchPlace;

#pragma mark - Club
+ (NSString *)createClub;
+ (NSString *)publishAnnouncement;
+ (NSString *)getClubDetail;
+ (NSString *)getClubAllMemebers;
+ (NSString *)inviteJoinClub;
+ (NSString *)deleteClubMemberBatch;
+ (NSString *)setClubAdminBatch;
+ (NSString *)deleteClubAdminBatch;
+ (NSString *)getUserClubs;

+ (NSString *)updateClubJoinType;
+ (NSString *)updateClubCover;
+ (NSString *)updateClubTeamImage;
+ (NSString *)updateClubName;
+ (NSString *)updateClubEvent;
+ (NSString *)getClubBindSports;
+ (NSString *)getClubUnbindSports;
+ (NSString *)bindSportToClubBatch;
+ (NSString *)getInviteRequest;
+ (NSString *)getApplyRequest;
+ (NSString *)agreeJoinClub;
+ (NSString *)applyJoinClub;
+ (NSString *)getNotJoinClubFriends;

#pragma mark - Auth
+ (NSString *)addWxclient;
+ (NSString *)addQQclient;

+ (NSString *)checkWxRegister;
+ (NSString *)checkQQRegister;

+ (NSString *)loginWithMobile;
+ (NSString *)loginWithWeixin;
+ (NSString *)loginWithQQ;

+ (NSString *)registerByWeinxin;
+ (NSString *)registerByQQ;
+ (NSString *)registerWithMobile;

+ (NSString *)resetPassword;
+ (NSString *)updatePassword;

#pragma mark - User
+ (NSString *)bindMobile;
+ (NSString *)bindWexin;
+ (NSString *)getMineInfo;
+ (NSString *)realNameCheck;
+ (NSString *)updateCity;
+ (NSString *)updateEmail;
+ (NSString *)updateNick;
+ (NSString *)updatePortrait;
+ (NSString *)updateSex;

#pragma mark - Common
+ (NSString *)upload;
+ (NSString *)addfeedback;

#pragma mark - Notify
+ (NSString *)deleteNotify;
+ (NSString *)getNotify;
+ (NSString *)getUnreadCount;
+ (NSString *)readNotify;

#pragma mark - SMS
+ (NSString *)checkVerifyCode;
+ (NSString *)getVerify;
+ (NSString *)getVerifyWithMobile;

#pragma mark - IM
+ (NSString *)addFriend;
+ (NSString *)addFriendBatch;
+ (NSString *)createGroup;
+ (NSString *)deleteFriend;
+ (NSString *)deleteGroup;

+ (NSString *)getAllGroups;
+ (NSString *)getFriends;
+ (NSString *)exitGroup;
+ (NSString *)getGroupInfo;
+ (NSString *)getGroupMembers;
+ (NSString *)getIMToken;
+ (NSString *)getMyGroups;
+ (NSString *)joinGroupBatch;
+ (NSString *)getUserInfo;
+ (NSString *)getUserInfoByRelation;

+ (NSString *)processRequestFriend;

+ (NSString *)searchFriend;
+ (NSString *)sendSportIMMessage;

#pragma mark - Contact

#pragma mark - Discover

#pragma mark - Personal

#pragma mark - Order
+ (NSString *)getMineOrders;        //全部
+ (NSString *)getOrdersAppraise;    //待评价
+ (NSString *)getOrdersIng;         //进行中
+ (NSString *)getOrdersSettlement;  //待结算

+ (NSString *)getOrderInfo;
+ (NSString *)orderPayment;

#pragma mark - Payment
+ (NSString *)getPaymentInfo;
+ (NSString *)getPayments;

#pragma mark - PING
+ (NSString *)getPayCharge;
+ (NSString *)getPaymentCharge;

#pragma mark - Wallet
+ (NSString *)getAccountInfo;
+ (NSString *)updatePaypass;
+ (NSString *)getDaybooks;
+ (NSString *)submitWithdraw;

#pragma mark - Push
+ (NSString *)regPushService;

@end
