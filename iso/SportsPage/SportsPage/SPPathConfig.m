//
//  PathClass.m
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPathConfig.h"

@implementation SPPathConfig

#pragma mark - Base

#if IsDevelopmentEnvironment
+ (NSString *)getService {
    return @"http://test.sportspage.cn";
}
#else
+ (NSString *)getService {
    return @"http://127.0.0.1:8080/api.php";
}
#endif

+ (NSString *)getGlobalConf {
    return @"https://api.sportspage.cn/Common/getGlobalConf";
}

#pragma mark - H5
+ (NSString *)getShareH5Url {
    return @"http://www.sportspage.cn/index.php/Share/eventDetail?type=%@&eventId=%@";
}

#pragma mark - Main
+ (NSString *)getHotEvent {
    return [NSString stringWithFormat:@"%@/Common/%@",[self getService],@"getHotEvent"];
}

+ (NSString *)getFollowEvent {
    return [NSString stringWithFormat:@"%@/Common/%@",[self getService],@"getFollowEvent"];
}

+ (NSString *)searchEvent {
    return [NSString stringWithFormat:@"%@/Common/%@",[self getService],@"searchEvent"];
}

#pragma mark - SportsPage
+ (NSString *)getSport {
    return [NSString stringWithFormat:@"%@/Sport/%@",[self getService],@"getSport"];
}

+ (NSString *)getLastEvent {
    return [NSString stringWithFormat:@"%@/Sport/%@",[self getService],@"getLastEvent"];
}

+ (NSString *)getMineSport {
    return [NSString stringWithFormat:@"%@/Sport/%@",[self getService],@"getMineSport"];
}

+ (NSString *)follow {
    return [NSString stringWithFormat:@"%@/Sport/%@",[self getService],@"follow"];
}

+ (NSString *)cancelFollow {
    return [NSString stringWithFormat:@"%@/Sport/%@",[self getService],@"cancelFollow"];
}

+ (NSString *)getFollows {
    return [NSString stringWithFormat:@"%@/Sport/%@",[self getService],@"getFollows"];
}

+ (NSString *)activateSport {
    return [NSString stringWithFormat:@"%@/Sport/%@",[self getService],@"activateSport"];
}

+ (NSString *)createSport {
    return [NSString stringWithFormat:@"%@/Sport/%@",[self getService],@"createSport"];
}

+ (NSString *)editSport {
    return [NSString stringWithFormat:@"%@/Sport/%@",[self getService],@"editSport"];
}

+ (NSString *)getSportEvents {
    return [NSString stringWithFormat:@"%@/Sport/%@",[self getService],@"getSportEvents"];
}

#pragma mark - Event
+ (NSString *)dismissEvent {
    return [NSString stringWithFormat:@"%@/Event/%@",[self getService],@"dismissEvent"];
}

+ (NSString *)enrollEvent {
    return [NSString stringWithFormat:@"%@/Event/%@",[self getService],@"enrollEvent"];
}

+ (NSString *)exitEvent {
    return [NSString stringWithFormat:@"%@/Event/%@",[self getService],@"exitEvent"];
}

+ (NSString *)getEnrollUser {
    return [NSString stringWithFormat:@"%@/Event/%@",[self getService],@"getEnrollUser"];
}

+ (NSString *)getEvent {
    return [NSString stringWithFormat:@"%@/Event/%@",[self getService],@"getEvent"];
}

+ (NSString *)getMessage {
    return [NSString stringWithFormat:@"%@/Event/%@",[self getService],@"getMessage"];
}

+ (NSString *)lock {
    return [NSString stringWithFormat:@"%@/Event/%@",[self getService],@"lock"];
}

+ (NSString *)postAppraise {
    return [NSString stringWithFormat:@"%@/Event/%@",[self getService],@"postAppraise"];
}

+ (NSString *)settlementEvent {
    return [NSString stringWithFormat:@"%@/Event/%@",[self getService],@"settlementEvent"];
}

+ (NSString *)postMessage {
    return [NSString stringWithFormat:@"%@/Event/%@",[self getService],@"postMessage"];
}

+ (NSString *)unlock {
    return [NSString stringWithFormat:@"%@/Event/%@",[self getService],@"unlock"];
}

#pragma mark - Location
+ (NSString *)getNearbyEvent {
    return [NSString stringWithFormat:@"%@/Location/%@",[self getService],@"getNearbyEvent"];
}

+ (NSString *)getNearbyPlace {
    return [NSString stringWithFormat:@"%@/Place/%@",[self getService],@"getNearbyPlace"];
}

+ (NSString *)searchPlace {
    return [NSString stringWithFormat:@"%@/Place/%@",[self getService],@"searchPlace"];
}

#pragma mark - Club
+ (NSString *)createClub {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"createClubV2"];
}

+ (NSString *)publishAnnouncement {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"publishAnnouncement"];
}

+ (NSString *)getClubDetail {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"getClubDetail"];
}

+ (NSString *)getClubAllMemebers {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"getClubAllMemebers"];
}

+ (NSString *)inviteJoinClub {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"inviteJoinClub"];
}

+ (NSString *)deleteClubMemberBatch {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"deleteClubMemberBatch"];
}

+ (NSString *)setClubAdminBatch {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"setClubAdminBatch"];
}

+ (NSString *)deleteClubAdminBatch {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"deleteClubAdminBatch"];
}

+ (NSString *)getUserClubs {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"getUserClubs"];
}

+ (NSString *)updateClubJoinType {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"updateJoinType"];
}

+ (NSString *)updateClubCover {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"updateClubPortrait"];
}

+ (NSString *)updateClubTeamImage {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"updateClubIcon"];
}

+ (NSString *)updateClubName {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"updateClubName"];
}

+ (NSString *)updateClubEvent {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"updateClubSportItem"];
}

+ (NSString *)getClubBindSports {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"getClubBindSports"];
}

+ (NSString *)getClubUnbindSports {
    return [NSString stringWithFormat:@"%@/Sport/%@",[self getService],@"getUnbindSport"];
}

+ (NSString *)bindSportToClubBatch {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"bindSportToClubBatch"];
}

+ (NSString *)getInviteRequest {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"getInviteRequest"];
}

+ (NSString *)getApplyRequest {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"getApplyRequest"];
}

+ (NSString *)agreeJoinClub {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"agreeJoinClub"];
}

+ (NSString *)applyJoinClub {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"applyJoinClub"];
}

+ (NSString *)getNotJoinClubFriends {
    return [NSString stringWithFormat:@"%@/Club/%@",[self getService],@"getNotJoinClubFriends"];
}

#pragma mark - Auth
+ (NSString *)addWxclient {
    return [NSString stringWithFormat:@"%@/Auth/%@",[self getService],@"addWxclient"];
}

+ (NSString *)addQQclient {
    return [NSString stringWithFormat:@"%@/Auth/%@",[self getService],@"addQQClient"];
}


+ (NSString *)checkWxRegister {
    return [NSString stringWithFormat:@"%@/Auth/%@",[self getService],@"checkWxRegister"];
}

+ (NSString *)checkQQRegister {
    return [NSString stringWithFormat:@"%@/Auth/%@",[self getService],@"checkQQRegister"];
}


+ (NSString *)loginWithMobile {
    return [NSString stringWithFormat:@"%@/Auth/%@",[self getService],@"loginWithMobile"];
}

+ (NSString *)loginWithWeixin {
    return [NSString stringWithFormat:@"%@/Auth/%@",[self getService],@"loginWithWeixin"];
}

+ (NSString *)loginWithQQ {
    return [NSString stringWithFormat:@"%@/Auth/%@",[self getService],@"loginWithQQ"];
}


+ (NSString *)registerByWeinxin {
    return [NSString stringWithFormat:@"%@/Auth/%@",[self getService],@"registerByWeinxin"];
}

+ (NSString *)registerByQQ {
    return [NSString stringWithFormat:@"%@/Auth/%@",[self getService],@"registerByQQ"];
}

+ (NSString *)registerWithMobile {
    return [NSString stringWithFormat:@"%@/Auth/%@",[self getService],@"registerWithMobile"];
}


+ (NSString *)resetPassword {
    return [NSString stringWithFormat:@"%@/Auth/%@",[self getService],@"resetPassword"];
}

+ (NSString *)updatePassword {
    return [NSString stringWithFormat:@"%@/Auth/%@",[self getService],@"updatePassword"];
}

#pragma mark - Common
+ (NSString *)upload {
    return [NSString stringWithFormat:@"%@/Common/%@",[self getService],@"upload"];
}

+ (NSString *)addfeedback {
    return [NSString stringWithFormat:@"%@/Common/%@",[self getService],@"addfeedback"];
}

#pragma mark - User
+ (NSString *)realNameCheck {
    return [NSString stringWithFormat:@"%@/User/%@",[self getService],@"realNameCheck"];
}

+ (NSString *)bindMobile {
    return [NSString stringWithFormat:@"%@/User/%@",[self getService],@"bindMobile"];
}

+ (NSString *)bindWexin {
    return [NSString stringWithFormat:@"%@/User/%@",[self getService],@"bindWexin"];
}

+ (NSString *)getMineInfo {
    return [NSString stringWithFormat:@"%@/User/%@",[self getService],@"getMineInfo"];
}

+ (NSString *)updateCity {
    return [NSString stringWithFormat:@"%@/User/%@",[self getService],@"updateCity"];
}

+ (NSString *)updateEmail {
    return [NSString stringWithFormat:@"%@/User/%@",[self getService],@"updateEmail"];
}

+ (NSString *)updateNick {
    return [NSString stringWithFormat:@"%@/User/%@",[self getService],@"updateNick"];
}

+ (NSString *)updatePortrait {
    return [NSString stringWithFormat:@"%@/User/%@",[self getService],@"updatePortrait"];
}

+ (NSString *)updateSex {
    return [NSString stringWithFormat:@"%@/User/%@",[self getService],@"updateSex"];
}

#pragma mark - Notify
+ (NSString *)deleteNotify {
    return [NSString stringWithFormat:@"%@/Notify/%@",[self getService],@"deleteNotify"];
}

+ (NSString *)getNotify {
    return [NSString stringWithFormat:@"%@/Notify/%@",[self getService],@"getNotify"];
}

+ (NSString *)getUnreadCount {
    return [NSString stringWithFormat:@"%@/Notify/%@",[self getService],@"getUnreadCount"];
}

+ (NSString *)readNotify {
    return [NSString stringWithFormat:@"%@/Notify/%@",[self getService],@"readNotify"];
}

#pragma mark - SMS
+ (NSString *)checkVerifyCode {
    return [NSString stringWithFormat:@"%@/SMS/%@",[self getService],@"checkVerifyCode"];
}

+ (NSString *)getVerify {
    return [NSString stringWithFormat:@"%@/SMS/%@",[self getService],@"getVerify"];
}

+ (NSString *)getVerifyWithMobile {
    return [NSString stringWithFormat:@"%@/SMS/%@",[self getService],@"getVerifyByMobile"];
}

#pragma mark - IM
+ (NSString *)addFriend {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"addFriend"];
}

+ (NSString *)addFriendBatch {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"addFriendBatch"];
}

+ (NSString *)createGroup {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"createGroup"];
}

+ (NSString *)deleteFriend {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"deleteFriend"];
}

+ (NSString *)deleteGroup {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"deleteGroup"];
}

+ (NSString *)getAllGroups {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"getAllGroups"];
}

+ (NSString *)getFriends {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"getFriends"];
}

+ (NSString *)exitGroup {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"exitGroup"];
}

+ (NSString *)getGroupInfo {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"getGroupInfo"];
}

+ (NSString *)getGroupMembers {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"getGroupMembers"];
}

+ (NSString *)getIMToken {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"getIMToken"];
}

+ (NSString *)getMyGroups {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"getMyGroups"];
}

+ (NSString *)joinGroupBatch {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"joinGroup"];
}

+ (NSString *)getUserInfo {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"getUserInfo"];
}

+ (NSString *)getUserInfoByRelation {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"getUserInfoWithRelation"];
}

+ (NSString *)processRequestFriend {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"processRequestFriend"];
}

+ (NSString *)searchFriend {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"searchFriend"];
}

+ (NSString *)sendSportIMMessage {
    return [NSString stringWithFormat:@"%@/IM/%@",[self getService],@"sendSportIMMessage"];
}

#pragma mark - Contact

#pragma mark - Discover

#pragma mark - Personal

#pragma mark - Order
+ (NSString *)getMineOrders {
    return [NSString stringWithFormat:@"%@/Order/%@",[self getService],@"getMineOrders"];
}

+ (NSString *)getOrdersAppraise {
    return [NSString stringWithFormat:@"%@/Order/%@",[self getService],@"getOrdersAppraise"];
}

+ (NSString *)getOrdersIng {
    return [NSString stringWithFormat:@"%@/Order/%@",[self getService],@"getOrdersIng"];
}

+ (NSString *)getOrdersSettlement {
    return [NSString stringWithFormat:@"%@/Order/%@",[self getService],@"getOrdersSettlement"];
}


+ (NSString *)getOrderInfo {
    return [NSString stringWithFormat:@"%@/Order/%@",[self getService],@"getOrderInfo"];
}

+ (NSString *)orderPayment {
    return [NSString stringWithFormat:@"%@/Order/%@",[self getService],@"orderPayment"];
}

#pragma mark - Payment
+ (NSString *)getPaymentInfo {
    return [NSString stringWithFormat:@"%@/Payment/%@",[self getService],@"getPaymentInfo"];
}

+ (NSString *)getPayments {
    return [NSString stringWithFormat:@"%@/Payment/%@",[self getService],@"getPayments"];
}

#pragma mark - PING
+ (NSString *)getPayCharge {
    return [NSString stringWithFormat:@"%@/Ping/%@",[self getService],@"getPayCharge"];
}

+ (NSString *)getPaymentCharge {
    return [NSString stringWithFormat:@"%@/Ping/%@",[self getService],@"getPaymentCharge"];
}

#pragma mark - Wallet
+ (NSString *)getAccountInfo {
    return [NSString stringWithFormat:@"%@/Wallet/%@",[self getService],@"getAccountInfo"];
}

+ (NSString *)updatePaypass {
    return [NSString stringWithFormat:@"%@/Wallet/%@",[self getService],@"updatePaypass"];
}

+ (NSString *)getDaybooks {
    return [NSString stringWithFormat:@"%@/Wallet/%@",[self getService],@"getDaybooks"];
}

+ (NSString *)submitWithdraw {
    return [NSString stringWithFormat:@"%@/Wallet/%@",[self getService],@"submitWithdraw"];
}

#pragma mark - Push
+ (NSString *)regPushService {
    return [NSString stringWithFormat:@"%@/Push/%@",[self getService],@"regPushService"];
}

@end
