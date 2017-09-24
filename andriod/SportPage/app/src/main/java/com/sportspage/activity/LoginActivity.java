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
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.App;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.BaseActivity;
import com.sportspage.common.Constants;
import com.sportspage.entity.LoginResult;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;
import com.tencent.connect.UserInfo;
import com.tencent.mm.sdk.modelmsg.SendAuth;
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

import io.rong.imkit.RongIM;
import io.rong.imlib.RongIMClient;


@ContentView(R.layout.activity_login)
public class LoginActivity extends BaseActivity {
    /** Log标记 */
    private final String TAG = "LoginActivity";
    /** 手机号输入框 */
    @ViewInject(R.id.et_login_phone)
    private EditText mPhone;
    /** 密码输入框 */
    @ViewInject(R.id.et_login_password)
    private EditText mPassword;
    @ViewInject(R.id.tv_agree_protocol)
    private TextView mProtocol;
    private String mUserName;
    private String mPortrait;
    private String mPhoneStr;
    private Tencent mTencent;
    private AlertDialog mLoadingDialog;


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
        SpannableString spanText=new SpannableString(getString(R.string.protocol));
        spanText.setSpan(new ClickableSpan() {

            @Override
            public void updateDrawState(TextPaint ds) {
                super.updateDrawState(ds);
                ds.setColor(Color.WHITE);       //设置文件颜色
                ds.setUnderlineText(true);      //设置下划线
            }
            @Override
            public void onClick(View view) {
                Utils.start_Activity(LoginActivity.this,ProtocolActivity.class);
            }
        }, spanText.length() - 8, spanText.length()-1, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        mProtocol.setHighlightColor(Color.TRANSPARENT); //设置点击后的颜色为透明，否则会一直出现高亮
        mProtocol.setText(spanText);
        mProtocol.setMovementMethod(LinkMovementMethod.getInstance());//开始响应点击事件
    }

    /**
     * 登录（点击登录按钮）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.btn_login})
    private void login(View v){
        if (mPhone.getText().toString().isEmpty()){
            Utils.showShortToast(this,"请输入账号");
            return;
        }
        if(mPassword.getText().toString().isEmpty()){
            Utils.showShortToast(this,"请输入密码");
            return;
        }
        Map<String,String> map = new HashMap<>();
        map.put("mobile",mPhone.getText().toString());
        map.put("password",mPassword.getText().toString());
        Xutils.getInstance(this).post(API.LOGIN_WITH_MOBILE, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                LoginResult.UserInfo loginResult = Utils.parseJsonWithGson(result,LoginResult.UserInfo.class);
                Utils.showShortToast(LoginActivity.this,getString(R.string.login_success));
                mUserName = loginResult.getUserName();
                mPortrait = loginResult.getPortrait();
                loginByToken(loginResult.getToken());
        }

            @Override
            public void onFinished() {

            }
        });
    }

    /**
     * 跳转到重置密码（点击重置文字）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.tv_login_reset})
    private void resetPwd(View v){
        Utils.start_Activity(this,ResetActivity.class);
    }

    /**
     * 启动微信登录（点击微信文字）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.iv_wechat_login})
    private void toWechatLogin(View v){
        boolean isWXAppInstalledAndSupported = App.api.isWXAppInstalled()
                && App.api.isWXAppSupportAPI();
        if(isWXAppInstalledAndSupported){
            final SendAuth.Req req = new SendAuth.Req();
            req.scope = "snsapi_userinfo";
            req.state = Constants.WECHAT_LOGIN;
            App.api.sendReq(req);
        } else {
            Utils.showShortToast(this,getString(R.string.uninstall_wechat));
        }
    }

    @Event(R.id.iv_qq_login)
    private void toQQLogin(View v) {
        mTencent = Tencent.createInstance(Constants.QQ_APP_ID, this);
        mTencent.login(this, "all", mUiListener);
    }


    /**
     * 跳转到选择登录方式（点击底部文字）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.tv_login_register})
    private void toRegister(View v){
        Utils.start_Activity(this,RegisterActivity.class);
    }


    /**
     * QQ的监听
     */
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
            if (mLoadingDialog.isShowing()) {
                mLoadingDialog.hide();
            }
        }
    };

    /**
     * 检测QQ注册
     */
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
                        Utils.showShortToast(LoginActivity.this,getString(R.string.login_failure));
                        finish();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(LoginActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(LoginActivity.this, getString(R.string.network_error));
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

    /**
     * 通过QQ注册
     */
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
                        Utils.showShortToast(LoginActivity.this,getString(R.string.login_failure));
                        finish();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(LoginActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(LoginActivity.this, getString(R.string.network_error));
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

    /**
     * 获取QQ用户信息
     */
    private void getUserInfo() {
        UserInfo userInfo = new UserInfo(LoginActivity.this, mTencent.getQQToken()); //获取用户信息
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

    /**
     * 将用户信息上传到服务器
     * @param s 用户信息json
     */
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

    /**
     *  通过QQ登录
     */
    private void loginWithQQ() {
        Map<String,String> map = new HashMap<>();
        map.put("openid",mTencent.getOpenId());
        Xutils.getInstance(this).get(API.LOGIN_WITH_QQ, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                UserInfoResult.ResultBean resultBean = Utils.parseJsonWithGson(result, UserInfoResult.ResultBean.class);
                mUserName = resultBean.getId();
                mPortrait = resultBean.getPortrait();
                mPhoneStr = resultBean.getMobile();
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
                if (mLoadingDialog.isShowing()) {
                    mLoadingDialog.hide();
                }
                finish();
            }

            @Override
            public void onSuccess(String userId) {
                if (mLoadingDialog.isShowing()) {
                    mLoadingDialog.hide();
                }
                Logger.d("userId"+userId);
                Utils.putValue(LoginActivity.this,"token",token);
                Utils.putValue(LoginActivity.this,"userId",userId);
                Utils.putValue(LoginActivity.this,"nick",mUserName);
                Utils.putValue(LoginActivity.this,"portrait", mPortrait);
                Utils.putValue(LoginActivity.this,"mobile", mPhoneStr);
                Utils.showShortToast(LoginActivity.this,getString(R.string.login_success));
                Intent intent = new Intent();
                intent.setClass(LoginActivity.this,MainActivity.class);
                Utils.start_Activity(LoginActivity.this,intent);
                finish();
            }

            @Override
            public void onError(RongIMClient.ErrorCode errorCode) {
                if (mLoadingDialog.isShowing()) {
                    mLoadingDialog.hide();
                }
                finish();
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == com.tencent.connect.common.Constants.REQUEST_LOGIN ||
                requestCode == com.tencent.connect.common.Constants.REQUEST_APPBAR) {
            if (!mLoadingDialog.isShowing()) {
                mLoadingDialog.show();
            }
            Tencent.onActivityResultData(requestCode, resultCode, data, mUiListener);
        }
        super.onActivityResult(requestCode, resultCode, data);
    }


}
