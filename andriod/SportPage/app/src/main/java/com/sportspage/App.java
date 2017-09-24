package com.sportspage;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.net.Uri;
import android.support.multidex.MultiDexApplication;

import com.baidu.mapapi.SDKInitializer;
import com.orhanobut.logger.Logger;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.message.ClubApplyMessage;
import com.sportspage.message.ClubInviteMessage;
import com.sportspage.message.CustomizeMessage;
import com.sportspage.message.ShareClubMessage;
import com.sportspage.message.ShareMessage;
import com.sportspage.receiver.ClubApplyMessageProvider;
import com.sportspage.receiver.ClubInviteMessageProvider;
import com.sportspage.receiver.ContactNotificationMessageProvider;
import com.sportspage.receiver.CustomizeMessageItemProvider;
import com.sportspage.receiver.MyConversationBehaviorListener;
import com.sportspage.receiver.MyConversationListBehaviorListener;
import com.sportspage.receiver.ShareClubMessageProvider;
import com.sportspage.receiver.ShareMessageProvider;
import com.sportspage.utils.SampleExtensionModule;
import com.sportspage.utils.Utils;
import com.tencent.bugly.crashreport.CrashReport;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.x;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import io.rong.imkit.DefaultExtensionModule;
import io.rong.imkit.IExtensionModule;
import io.rong.imkit.RongExtensionManager;
import io.rong.imkit.RongIM;
import io.rong.imlib.model.Group;
import io.rong.imlib.model.UserInfo;
import io.rong.message.ContactNotificationMessage;

public class App extends MultiDexApplication implements
        RongIM.UserInfoProvider, RongIM.GroupInfoProvider {
    /**
     * 上下文
     */
    private static Context mContent;

    private static App instance;
    /**
     * IWXAPI 是第三方app和微信通信的openapi接口
     */
    public static IWXAPI api;


    @Override
    public void onCreate() {
        super.onCreate();
        mContent = getApplicationContext();
        //设置融云
        setRongIM();
        //Logger.init("TENMA");
        //百度地图的初始化
        SDKInitializer.initialize(this);
        //初始化xutils
        x.Ext.init(this);
        //设置为debug模式
        x.Ext.setDebug(false);
        //bugly初始化
        CrashReport.initCrashReport(getApplicationContext(),Constants.BUGLY_APP_ID, false);
        //微信api实例化
        api = WXAPIFactory.createWXAPI(this, Constants.APP_ID, true);
        api.registerApp(Constants.APP_ID);

    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        RongIM.getInstance().disconnect();
    }

    private void setRongIM() {
        if (getApplicationInfo().packageName.equals(getCurProcessName(getApplicationContext()))) {
            /**
             * IMKit SDK调用第一步 初始化
             */
            RongIM.init(this);
            RongIM.setUserInfoProvider(this, true);
            RongIM.setGroupInfoProvider(this, true);
            RongIM.registerMessageType(CustomizeMessage.class);
            RongIM.registerMessageType(ShareMessage.class);
            RongIM.registerMessageType(ShareClubMessage.class);
            RongIM.registerMessageType(ClubInviteMessage.class);
            RongIM.registerMessageType(ClubApplyMessage.class);
            RongIM.registerMessageType(ContactNotificationMessage.class);
            RongIM.registerMessageTemplate(new ShareMessageProvider());
            RongIM.registerMessageTemplate(new ShareClubMessageProvider());
            RongIM.registerMessageTemplate(new ClubInviteMessageProvider());
            RongIM.registerMessageTemplate(new ClubApplyMessageProvider());
            RongIM.registerMessageTemplate(new CustomizeMessageItemProvider());
            RongIM.registerMessageTemplate(new ContactNotificationMessageProvider());
            RongIM.setConversationBehaviorListener(new MyConversationBehaviorListener());
            RongIM.setConversationListBehaviorListener(new MyConversationListBehaviorListener());
            List<IExtensionModule> moduleList = RongExtensionManager.getInstance().getExtensionModules();
            IExtensionModule defaultModule = null;
            if (moduleList != null) {
                for (IExtensionModule module : moduleList) {
                    if (module instanceof DefaultExtensionModule) {
                        defaultModule = module;
                        break;
                    }
                }
                if (defaultModule != null) {
                    RongExtensionManager.getInstance().unregisterExtensionModule(defaultModule);
                    RongExtensionManager.getInstance().registerExtensionModule(new SampleExtensionModule());
                }
            }
        }
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        Utils.clearAllCache(this);
        System.gc();
    }

    public static App getInstance() {
        if (instance == null) {
            synchronized (App.class) {
                if (instance == null) {
                    instance = new App();
                }
            }
        }
        return instance;
    }

    // 运用list来保存们每一个activity是关键
    private List<Activity> mList = new LinkedList<Activity>();

    // add Activity
    public void addActivity(Activity activity) {
        mList.add(activity);
    }

    // 关闭每一个list内的activity
    public void exit() {
        try {
            for (Activity activity : mList) {
                if (activity != null)
                    activity.finish();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            System.exit(0);
        }
    }

    public void finishActivity() {
        try {
            for (Activity activity : mList) {
                if (activity != null)
                    activity.finish();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * 获得当前进程的名字
     *
     * @param context
     * @return
     */
    public static String getCurProcessName(Context context) {

        int pid = android.os.Process.myPid();

        ActivityManager activityManager = (ActivityManager) context
                .getSystemService(Context.ACTIVITY_SERVICE);

        for (ActivityManager.RunningAppProcessInfo appProcess : activityManager
                .getRunningAppProcesses()) {

            if (appProcess.pid == pid) {

                return appProcess.processName;
            }
        }
        return null;
    }

    @Override
    public UserInfo getUserInfo(String s) {
        Logger.d(s);
        return findUserById(s);
    }


    private UserInfo findUserById(String s) {
        final UserInfoResult.ResultBean[] user = {null};
        Map<String, String> map = new HashMap<>();
        map.put("userId", s);
        RequestParams params = new RequestParams(API.GET_USERINFO);
        try {
            params.addQueryStringParameter("sign", Utils.getSignature(map, Constants.SECRET));
            params.addQueryStringParameter("userId", s);
            x.http().get(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Logger.json(result);
                    UserInfoResult userInfoResult = Utils.parseJsonWithGson(result, UserInfoResult.class);
                    if (userInfoResult.getCode() == Constants.HTTP_OK_200) {
                        user[0] = userInfoResult.getResult();
                        RongIM.getInstance().refreshUserInfoCache(new UserInfo(user[0].getId(), user[0].getNick(), Uri.parse(user[0].getPortrait())));
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(x.app(), getString(R.string.network_error));
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(x.app(), getString(R.string.network_error));
                }

                @Override
                public void onFinished() {

                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (user[0] != null) {
            return new UserInfo(user[0].getId(), user[0].getNick(), Uri.parse(user[0].getPortrait()));
        } else {
            return null;
        }

    }


    @Override
    public Group getGroupInfo(String groupInfo) {
        return findGroupInfo(groupInfo);
    }

    private Group findGroupInfo(String groupInfo) {
        final Group[] groups = {null};
        Map<String, String> map = new HashMap<>();
        map.put("groupId", groupInfo);
        RequestParams params = new RequestParams(API.GET_GROUNP_INFO);
        try {
            params.addQueryStringParameter("sign", Utils.getSignature(map, Constants.SECRET));
            params.addQueryStringParameter("groupId", groupInfo);
            x.http().get(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Logger.json(result);
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        JSONObject resultObject = jsonObject.getJSONObject("result");
                        Group group = new Group(resultObject.getString("id")
                                , resultObject.getString("name")
                                , Uri.parse(resultObject.getString("portrait")));
                        RongIM.getInstance().refreshGroupInfoCache(group);
                        groups[0] = group;
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(x.app(), getString(R.string.network_error));
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(x.app(), getString(R.string.network_error));
                }

                @Override
                public void onFinished() {

                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (groups[0] != null) {
            return groups[0];
        } else {
            return null;
        }
    }
}
