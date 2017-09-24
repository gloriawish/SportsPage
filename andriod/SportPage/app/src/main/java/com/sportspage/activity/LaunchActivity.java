package com.sportspage.activity;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.utils.PermissionUtils;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.xutils.view.annotation.ContentView;
import org.xutils.x;

import java.util.HashMap;
import java.util.Map;

import io.rong.imkit.RongIM;
import io.rong.imlib.RongIMClient;
import io.rong.imlib.model.UserInfo;

@ContentView(R.layout.activity_launch)
public class LaunchActivity extends AppCompatActivity implements BDLocationListener {

    private UserInfoResult.ResultBean mInfo;

    LocationClient baduduManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        x.view().inject(this);
        new Thread(new Runnable() {
            @Override
            public void run() {
                login();
            }
        }).start();
        setLocation();
    }

    private void login() {
        String token = Utils.getValue(this,"token");
        boolean isFirst = Utils.getBooleanValue(this,"first",true);
        if (isFirst){
            Utils.start_Activity(this,SplashActivity.class);
            Utils.putBooleanValue(this,"first",false);
        }else {
            if (token.isEmpty()){
                Utils.start_Activity(LaunchActivity.this,LoginActivity.class);
            } else{
                loginByToken(token);
            }
        }
    }

    private void setLocation() {
        if (baduduManager == null) {
            baduduManager = new LocationClient(this);
            //定位的配置
            LocationClientOption option = new LocationClientOption();
            //定位模式选择，高精度、省电、仅设备
            option.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy);
            //定位坐标系类型选取, gcj02、bd09ll、bd09
            option.setCoorType("gcj02");
            //定位时间间隔
            option.setScanSpan(1000);
            //选择定位到地址
            option.setIsNeedAddress(true);
            baduduManager.setLocOption(option);
            //注册定位的成功的回调
            baduduManager.registerLocationListener(this);
        }
        baduduManager.start();
    }

    /**
     * 通过token登录融云
     *
     * @param token token
     */
    private void loginByToken(final String token) {
        RongIM.connect(token, new RongIMClient.ConnectCallback() {
            @Override
            public void onTokenIncorrect() {
                Utils.start_Activity(LaunchActivity.this,LoginActivity.class);
                finish();
            }

            @Override
            public void onSuccess(final String userId) {
                Utils.putValue(LaunchActivity.this,"token",token);
                Map<String, String> map = new HashMap<>();
                map.put("userId", userId);
                Xutils.getInstance(LaunchActivity.this,false).get(API.GET_USERINFO, map, new Xutils.XCallBack() {
                    @Override
                    public void onResponse(String result) {
                        mInfo = Utils.parseJsonWithGson(result, UserInfoResult.ResultBean.class);
                        Utils.putValue(x.app(),"userId",userId);
                        Utils.putValue(x.app(),"nick",mInfo.getNick());
                        Utils.putValue(x.app(),"phone",mInfo.getMobile());
                        Utils.putValue(x.app(),"portrait", mInfo.getPortrait());
                        RongIM.getInstance().refreshUserInfoCache(new UserInfo(userId,
                                mInfo.getNick(), Uri.parse(mInfo.getPortrait())));
                    }

                    @Override
                    public void onFinished() {
                        Utils.showShortToast(LaunchActivity.this,getString(R.string.login_success));
                        Utils.start_Activity(LaunchActivity.this, MainActivity.class);
                        finish();

                    }
                });
            }

            @Override
            public void onError(RongIMClient.ErrorCode errorCode) {
                Utils.start_Activity(LaunchActivity.this,LoginActivity.class);
                finish();
            }
        });
    }

    @Override
    public void onReceiveLocation(BDLocation bdLocation) {
        StringBuffer sb = new StringBuffer(256);
        sb.append("time : ");
        sb.append(bdLocation.getTime());
        sb.append("\nerror code : ");
        sb.append(bdLocation.getLocType());
        sb.append("\nlatitude : ");
        sb.append(bdLocation.getLatitude());
        sb.append("\nlontitude : ");
        sb.append(bdLocation.getLongitude());
        sb.append("\nradius : ");
        sb.append(bdLocation.getRadius());
        if (bdLocation.getLocType() == BDLocation.TypeGpsLocation) {
            sb.append("\nspeed : ");
            sb.append(bdLocation.getSpeed());
            sb.append("\nsatellite : ");
            sb.append(bdLocation.getSatelliteNumber());
            sb.append("\ndirection : ");
            sb.append("\naddr : ");
            sb.append(bdLocation.getAddrStr());
            sb.append(bdLocation.getDirection());
        } else if (bdLocation.getLocType() == BDLocation.TypeNetWorkLocation) {
            sb.append("\naddr : ");
            sb.append(bdLocation.getAddrStr());
            sb.append("\noperationers : ");
            sb.append(bdLocation.getOperators());
        }
        Logger.d("百度定位\n" + sb.toString());
        Utils.putValue(this, "latitude", bdLocation.getLatitude() + "");
        Utils.putValue(this, "lontitude", bdLocation.getLongitude() + "");
        baduduManager.stop();
    }
}
