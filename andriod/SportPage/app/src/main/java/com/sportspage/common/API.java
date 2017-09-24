package com.sportspage.common;

/**
 * Created by Tenma on 2016/12/5.
 */

public class API {
    //public static final String BASE_URL = "https://api.sportspage.cn";

    public static final String BASE_URL = "http://10.0.2.2:8080/api.php";
//    public static final String BASE_URL = "http://test.sportspage.cn";
    public static final String GET_VERIFY_MOBILE = BASE_URL+"/SMS/getVerifyByMobile";

    //登录认证
    public static final String REGISTER_WITH_MOBILE = BASE_URL + "/Auth/registerWithMobile";
    public static final String LOGIN_WITH_MOBILE = BASE_URL + "/Auth/loginWithMobile";
    public static final String CHECK_WX_REGISTER = BASE_URL + "/Auth/checkWxRegister";
    public static final String REGISTER_WITH_WX = BASE_URL + "/Auth/registerByWeinxin";
    public static final String LOGIN_WITH_WX = BASE_URL + "/Auth/loginWithWeixin";
    public static final String ADD_WXCLIENT = BASE_URL+"/Auth/addWxclient";
    public static final String RESET_PASSWORD = BASE_URL+"/Auth/resetPassword";
    public static final String CHECK_QQ_REGISTER = BASE_URL+"/Auth/checkQQRegister";
    public static final String REGISTER_BY_QQ = BASE_URL+"/Auth/registerByQQ";
    public static final String ADD_QQ_CLIENT = BASE_URL+"/Auth/addQQClient";
    public static final String LOGIN_WITH_QQ = BASE_URL+"/Auth/loginWithQQ";

    //IM
    public static final String GET_FRIENDS = BASE_URL+"/IM/getFriends";
    public static final String DELETE_FRIEND = BASE_URL + "/IM/deleteFriend";
    public static final String ADD_FRIEND = BASE_URL + "/IM/addFriend";
    public static final String GET_USERINFO = BASE_URL + "/IM/getUserInfo";
    public static final String GET_GROUNP_INFO = BASE_URL + "/IM/getGroupInfo";
    public static final String SEARCH_FRIEND = BASE_URL + "/IM/searchFriend";
    public static final String CREATE_GROUP = BASE_URL + "/IM/createGroup";
    public static final String GET_MY_GROUPS = BASE_URL + "/IM/getMyGroups";
    public static final String PROCESS_REQUEST_FRIEND = BASE_URL + "/IM/processRequestFriend";

    //钱包
    public static final String GET_ACCOUNT_INFO = BASE_URL + "/Wallet/getAccountInfo";
    public static final String SUBMIT_WITHDRAW = BASE_URL + "/Wallet/submitWithdraw";
    public static final String GET_DAY_BOOKS = BASE_URL + "/Wallet/getDaybooks";
    public static final String UPDATE_PAYPASS = BASE_URL + "/Wallet/updatePaypass";
    public static final String ORDER_PAYMENT = BASE_URL + "/Payment/orderPayment";


    //运动
    public static final String CREATE_SPORT = BASE_URL + "/Sport/createSport";
    public static final String ACTIVATE_SPORT = BASE_URL + "/Sport/activateSport";
    public static final String GET_MINE_SPORT = BASE_URL + "/Sport/getMineSport";
    public static final String GET_UNBIND_SPORT = BASE_URL + "/Sport/getUnbindSport";
    public static final String GET_FOLLOWS = BASE_URL + "/Sport/getFollows";
    public static final String FOLLOW = BASE_URL + "/Sport/follow";
    public static final String CANCEL_FOLLOW = BASE_URL + "/Sport/cancelFollow";
    public static final String GET_SPORT = BASE_URL + "/Sport/getSport";
    public static final String GET_LAST_EVENT = BASE_URL + "/Sport/getLastEvent";

    public static final String GET_HOT_EVENT = BASE_URL + "/Common/getHotEvent";
    public static final String SEARCH_EVENT = BASE_URL + "/Common/searchEvent";
    public static final String GET_FOLLOW_EVENT = BASE_URL + "/Common/getFollowEvent";
    public static final String GET_EVENT = BASE_URL + "/Event/getEvent";
    public static final String ENROLL_EVENT = BASE_URL + "/Event/enrollEvent";
    public static final String SETTLEMENT_EVENT = BASE_URL + "/Event/settlementEvent";
    public static final String LOCK = BASE_URL + "/Event/lock";
    public static final String UNLOCK = BASE_URL + "/Event/unlock";
    public static final String EXIT_EVENT = BASE_URL + "/Event/exitEvent";
    public static final String DISMISS_EVENT = BASE_URL + "/Event/dismissEvent";
    public static final String POST_APPRAISE = BASE_URL + "/Event/postAppraise";
    public static final String POST_MESSAGE = BASE_URL + "/Event/postMessage";

    //记录
    public static final String GET_MINE_ORDERS = BASE_URL + "/Order/getMineOrders";
    public static final String GET_ORDERS_APPRAISE = BASE_URL + "/Order/getOrdersAppraise";
    public static final String GET_ORDERS_ING = BASE_URL + "/Order/getOrdersIng";
    public static final String GET_ORDERS_SETTLEMENT = BASE_URL + "/Order/getOrdersSettlement";


    //反馈
    public static final String ADD_FEEDBACK = BASE_URL + "/Common/addFeedback";

    //用户
    public static final String BIND_MOBILE = BASE_URL + "/User/bindMobile";
    public static final String BIND_WEIXIN = BASE_URL + "/User/bindWexin";
    public static final String GET_MINE_INFO = BASE_URL + "/User/getMineInfo";
    public static final String REAL_NAME_CHECK = BASE_URL + "/User/realNameCheck";
    public static final String UPDATE_CITY = BASE_URL + "/User/updateCity";
    public static final String UPDATE_EMAIL = BASE_URL + "/User/updateEmail";
    public static final String UPDATE_NICK = BASE_URL + "/User/updateNick";
    public static final String UPDATE_PORTRAIT = BASE_URL + "/User/updatePortrait";
    public static final String UPDATE_SEX = BASE_URL + "/User/updateSex";

    //地址
    public static final String SEARCH_PLACE = BASE_URL + "/Place/searchPlace";

    //ping++
    public static final String GET_PAY_CHARGE = BASE_URL+"/Ping/getPayCharge";
    public static final String GET_PAYMENT_CHARGE = BASE_URL+"/Ping/getPaymentCharge";

    //通知
    public static final String GET_NOTIFY = BASE_URL+"/Notify/getNotify";

    //俱乐部
    public static final String CREATE_CLUB = BASE_URL+"/Club/createClubV2";

    public static final String PUBLISH_ANNOUNCEMENT = BASE_URL+"/Club/publishAnnouncement";
    public static final String GET_CLUB_DETAIL = BASE_URL+"/Club/getClubDetail";
    public static final String GET_CLUB_BASE = BASE_URL+"/Club/getClubBase";
    public static final String GET_USER_CLUBS = BASE_URL+"/Club/getUserClubs";
    public static final String GET_CLUB_ALL_MEMEBER = BASE_URL+"/Club/getClubAllMemebers";
    public static final String INVITE_JOIN_CLUB = BASE_URL+"/Club/inviteJoinClub";
    public static final String GET_CLUB_ADMINS = BASE_URL+"/Club/getClubAdmins";
    public static final String GET_NORMAL_MEMBERS = BASE_URL+"/Club/getNormalMembers";
    public static final String DELETE_CLUB_MEMEBER = BASE_URL+"/Club/deleteClubMemeber";
    public static final String SET_CLUB_ADMIN_BATCH = BASE_URL+"/Club/setClubAdminBatch";
    public static final String DELETE_CLUB_ADMIN_BATCH = BASE_URL+"/Club/deleteClubAdminBatch";
    public static final String DELETE_CLUB_MEMBER_BATCH = BASE_URL+"/Club/deleteClubMemberBatch";
    public static final String UPDATE_JOIN_TYPE = BASE_URL+"/Club/updateJoinType";
    public static final String UPDATE_CLUB_ICON = BASE_URL+"/Club/updateClubIcon";
    public static final String UPDATE_CLUB_PORTRAIT = BASE_URL+"/Club/updateClubPortrait";
    public static final String UPDATE_CLUB_NAME = BASE_URL+"/Club/updateClubName";
    public static final String GET_CLUB_BIND_SPORTS = BASE_URL+"/Club/getClubBindSports";
    public static final String APPLY_JOIN_CLUB = BASE_URL+"/Club/applyJoinClub";
    public static final String UPDATE_CLUB_SPORT_ITEM = BASE_URL+"/Club/updateClubSportItem";
    public static final String BIND_SPORT_TO_CLUB_BATCH = BASE_URL+"/Club/bindSportToClubBatch";
    public static final String GET_INVITE_REQUEST = BASE_URL+"/Club/getInviteRequest";
    public static final String AGREE_JOIN_CLUB = BASE_URL+"/Club/agreeJoinClub";
    public static final String GET_APPLY_REQUEST = BASE_URL+"/Club/getApplyRequest";
    public static final String GET_NOT_JOIN_CLUB_FRIENDS = BASE_URL+"/Club/getNotJoinClubFriends";

    //其他
    public static final String TEST_OTHER = BASE_URL+"/Test/testOther";
    public static final String TEST_METHOD = BASE_URL+"/Test/testMethod";
}
