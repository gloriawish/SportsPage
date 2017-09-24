package com.sportspage.activity;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextPaint;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.BaseActivity;
import com.sportspage.common.Constants;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;
import com.tencent.connect.UserInfo;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;

import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import io.rong.imkit.RongIM;
import io.rong.imlib.RongIMClient;

@ContentView(R.layout.activity_wechat_login)
public class WeChatLoginActivity extends BaseActivity {

    @ViewInject(R.id.tv_agree_protocol)
    private TextView mProtocol;

    /** 用户信息 */
    private String mUserName;
    private String mPortrait;
    private String mPhone;

    private AlertDialog mLoadingDialog;

    private IUiListener mUiListener = new IUiListener() {
        @Override
        public void onComplete(Object o) {
            Logger.json(o.toString());
            if (o != null) {
                JSONObject jsonObject = null;
                try {
                    jsonObject = new JSONObject(o.toString());
                    mTencent.setOpenId(jsonObject.getString("openid"));
                    mTencent.setAccessToken(jsonObject.getString("access_token")
                            , jsonObject.getString("expires_in"));
                    checkQQRegister();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }

        @Override
        public void onError(UiError uiError) {
            Logger.d(uiError.errorMessage);
        }

        @Override
        public void onCancel() {

        }
    };

    private void checkQQRegister() {
        Map<String,String> map = new HashMap<>();
        map.put("openid",mTencent.getOpenId());
        RequestParams params = new RequestParams(API.CHECK_QQ_REGISTER);
        try {
            params.addQueryStringParameter("sign",Utils.getSignature(map,Constants.SECRET));
            params.addQueryStringParameter("openid",mTencent.getOpenId());
            x.http().get(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    int code = Utils.getCode(result);
                    if(code == Constants.HTTP_ERROR_600){
                        getUserInfo();
                    } else if(code == Constants.HTTP_OK_200) {
                        registerByQQ();
                    } else{
                        Utils.showShortToast(WeChatLoginActivity.this,getString(R.string.login_failure));
                        finish();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(WeChatLoginActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(WeChatLoginActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onFinished() {
                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    private void registerByQQ() {
        Map<String,String> map = new HashMap<>();
        map.put("openid",mTencent.getOpenId());
        RequestParams params = new RequestParams(API.REGISTER_BY_QQ);
        try {
            params.addParameter("sign",Utils.getSignature(map,Constants.SECRET));
            params.addParameter("openid",mTencent.getOpenId());
            x.http().post(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Logger.json(result);
                    int code = Utils.getCode(result);
                    if(code== Constants.HTTP_OK_200 || code == Constants.HTTP_ERROR_600){
                        loginWithQQ();
                    } else {
                        Utils.showShortToast(WeChatLoginActivity.this,getString(R.string.login_failure));
                        finish();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(WeChatLoginActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(WeChatLoginActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onFinished() {
                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    private void getUserInfo() {
        UserInfo userInfo = new UserInfo(WeChatLoginActivity.this, mTencent.getQQToken()); //获取用户信息
        userInfo.getUserInfo(new IUiListener() {
            @Override
            public void onComplete(Object o) {
                addQQClient(o.toString());
            }

            @Override
            public void onError(UiError uiError) {
                Logger.d(uiError.errorMessage);
            }

            @Override
            public void onCancel() {

            }
        });
    }

    private void addQQClient(String s) {
        Map<String,String> map = new HashMap<>();
        map.put("openid",mTencent.getOpenId());
        map.put("json",s);
        Xutils.getInstance(this).post(API.ADD_QQ_CLIENT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                registerByQQ();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    private void loginWithQQ() {
        Map<String,String> map = new HashMap<>();
        map.put("openid",mTencent.getOpenId());
        Xutils.getInstance(this).get(API.LOGIN_WITH_QQ, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                UserInfoResult.ResultBean resultBean = Utils.parseJsonWithGson(result, UserInfoResult.ResultBean.class);
                mUserName = resultBean.getId();
                mPortrait = resultBean.getPortrait();
                mPhone = resultBean.getMobile();
                loginByToken(resultBean.getToken());
            }

            @Override
            public void onFinished() {

            }

            });
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
                finish();
            }

            @Override
            public void onSuccess(String userId) {
                Logger.d("userId"+userId);
                Utils.putValue(WeChatLoginActivity.this,"token",token);
                Utils.putValue(WeChatLoginActivity.this,"userId",userId);
                Utils.putValue(WeChatLoginActivity.this,"nick",mUserName);
                Utils.putValue(WeChatLoginActivity.this,"portrait", mPortrait);
                Utils.putValue(WeChatLoginActivity.this,"mobile", mPhone);
                Utils.showShortToast(WeChatLoginActivity.this,getString(R.string.login_success));
                Intent intent = new Intent();
                intent.setClass(WeChatLoginActivity.this,MainActivity.class);
                Utils.start_Activity(WeChatLoginActivity.this,intent);
//                mLoadingDialog.dismiss();
                finish();
            }

            @Override
            public void onError(RongIMClient.ErrorCode errorCode) {
                finish();
            }
        });
    }

    private int keyBackClickCount = 0;
    private Tencent mTencent;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mLoadingDialog = new AlertDialog.Builder(this,R.style.dialog).create();
        mLoadingDialog.setCanceledOnTouchOutside(false);
        View content = LayoutInflater.from(this).inflate(R.layout.dialog_loading, null);
        mLoadingDialog.setView(content);
        SpannableString spanText = new SpannableString(getString(R.string.protocol));
        spanText.setSpan(new ClickableSpan() {

            @Override
            public void updateDrawState(TextPaint ds) {
                super.updateDrawState(ds);
                ds.setColor(Color.WHITE);       //设置文件颜色
                ds.setUnderlineText(true);      //设置下划线
            }

            @Override
            public void onClick(View view) {
                Utils.start_Activity(WeChatLoginActivity.this, ProtocolActivity.class);
            }
        }, spanText.length() - 8, spanText.length() - 1, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        mProtocol.setHighlightColor(Color.TRANSPARENT); //设置点击后的颜色为透明，否则会一直出现高亮
        mProtocol.setText(spanText);
        mProtocol.setMovementMethod(LinkMovementMethod.getInstance());//开始响应点击事件
    }

    /**
     * 启动微信登录（点击微信文字）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.btn_wechat_login})
    private void weChatLogin(View v) {
//        if(Utils.isWXAppInstalledAndSupported()){
//            final SendAuth.Req req = new SendAuth.Req();
//            req.scope = "snsapi_userinfo";
//            req.state = Constants.WECHAT_LOGIN;
//            App.api.sendReq(req);
//        } else {
//            Utils.showShortToast(this,getString(R.string.uninstall_wechat));
//        }
        mTencent = Tencent.createInstance("1105901492", this.getApplicationContext());
        mTencent.login(this, "all", mUiListener);
//        if (!mLoadingDialog.isShowing()){
//            mLoadingDialog.show();
//        }
    }


    /**
     * 跳转到登录（点击登录文字）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.tv_wechat_tologin})
    private void toLogin(View v) {
        Utils.start_Activity(this, LoginActivity.class);
    }

    /**
     * 跳转到注册（点击注册文字）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.tv_wechat_register})
    private void toRegister(View v) {
        Utils.start_Activity(this, RegisterActivity.class);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            switch (keyBackClickCount++) {
                case 0:
                    Toast.makeText(this, "再次按返回键退出", Toast.LENGTH_SHORT).show();
                    Timer timer = new Timer();
                    timer.schedule(new TimerTask() {
                        @Override
                        public void run() {
                            keyBackClickCount = 0;
                        }
                    }, 3000);
                    break;
                case 1:
                    finish();
                    overridePendingTransition(R.anim.push_up_in, R.anim.push_up_out);
                    break;
            }
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == com.tencent.connect.common.Constants.REQUEST_LOGIN ||
                requestCode == com.tencent.connect.common.Constants.REQUEST_APPBAR) {
            Tencent.onActivityResultData(requestCode, resultCode, data, mUiListener);
        }
        super.onActivityResult(requestCode, resultCode, data);
    }
}
