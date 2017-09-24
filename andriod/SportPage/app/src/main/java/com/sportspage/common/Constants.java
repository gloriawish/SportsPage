package com.sportspage.common;

/**
 * Created by Tenma on 2016/12/5.
 */

public class Constants {
    //微信APP相关
    public static final String APP_ID = "wxa71dfc4fdd43b2d3";
    public static final String APP_SECRET = "6c0316720a72953ed663f8b1dff32eba";
    //QQ相关
    public static final String QQ_APP_ID = "1105901492";

    public static final String BUGLY_APP_ID = "a358aa5964";

    /** 计算请求参数签名 */
    public static final String SECRET = "www.sportspage.cn";
    public static final String FEEDBACK_TYPE = "Android";

    /** 服务器返回的请求码 */
    public static final int HTTP_OK_200 = 200;
    public static final int HTTP_ERROR_600 = 600;
    public static final int HTTP_ERROR_500 = 500;
    public static final int HTTP_ERROR = 1000;

    public static final String KEY_CITY = "上海";

    public static final int MAP_RESULT_CODE = 100;

    public static final String PAY_CHANNEL_WX = "wx";

    public static final int EVENT_TYPE = 1001;

    public static final int SPORT_TYPE = 1002;

    public static final String WECHAT_LOGIN = "sportspagelogin";
    public static final String WECHAT_BIND = "sportspagebind";

    public static final String NOTICE_TYPE_INFO = "info";
    public static final String NOTICE_TYPE_SP = "sp";

    public static final int OPRATION_ADD_MEMBER = 1;
    public static final int OPRATION_REMOVE_MEMBER = 2;
    public static final int OPRATION_ADD_ADMIN = 3;
    public static final int OPRATION_REMOVE_ADMIN = 4;

    public static final String JOIN_TYPE_UNCONDITIONAL = "1";
    public static final String JOIN_TYPE_NEED_CHECK = "2";
    public static final String JOIN_TYPE_NEED_ANSWER = "3";

    public static final int PHOTOCLIP_16_9 = 0;
    public static final int PHOTOCLIP_UPDATE_PORTRAIT = 1;
    public static final int PHOTOCLIP_1_1 = 2;
    public static final int PHOTOCLIP_UPDATE_COVRER = 3;
    public static final int PHOTOCLIP_UPDATE_BADGE = 4;

    public static final int PERMISSION_READ = 10101;
}
