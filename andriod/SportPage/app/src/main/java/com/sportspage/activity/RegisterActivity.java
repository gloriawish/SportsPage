package com.sportspage.activity;

import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextPaint;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.BaseActivity;
import com.sportspage.common.BaseResult;
import com.sportspage.common.Constants;
import com.sportspage.entity.LoginResult;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@ContentView(R.layout.activity_register)
public class RegisterActivity extends BaseActivity {
    /** 手机号输入框 */
    @ViewInject(R.id.et_register_phone)
    private EditText mPhone;
    /** 密码输入框 */
    @ViewInject(R.id.et_register_password)
    private EditText mPassword;
    /** 验证码输入框 */
    @ViewInject(R.id.et_register_verify)
    private EditText mVerify;
    /** 获取验证码文字 */
    @ViewInject(R.id.tv_register_verify)
    private TextView mGetVerify;

    @ViewInject(R.id.tv_agree_protocol)
    private TextView mProtocol;
    /** 更新验证码倒计时handler */
    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (msg.what != 0) {
                mGetVerify.setText(msg.what + " s");
            } else {
                mGetVerify.setText(getString(R.string.get_verify));
                mGetVerify.setEnabled(true);
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
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
                Utils.start_Activity(RegisterActivity.this,ProtocolActivity.class);
            }
        }, spanText.length() - 8, spanText.length()-1, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        mProtocol.setHighlightColor(Color.TRANSPARENT); //设置点击后的颜色为透明，否则会一直出现高亮
        mProtocol.setText(spanText);
        mProtocol.setMovementMethod(LinkMovementMethod.getInstance());//开始响应点击事件
    }

    /**
     * 注册（点击注册按钮）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.btn_register})
    private void register(View v) {
        if(mPhone.getText().toString().isEmpty()){
            Utils.showShortToast(this,"请输入正确的手机号");
            return;
        }
        if(mPassword.getText().toString().isEmpty()){
            Utils.showShortToast(this,"请输入密码");
            return;
        }
        if(mVerify.getText().toString().isEmpty()){
            Utils.showShortToast(this,"请输入验证码");
            return;
        }
        Map<String, String> map = new HashMap<>();
        map.put("mobile", mPhone.getText().toString());
        map.put("password", mPassword.getText().toString());
        map.put("verify", mVerify.getText().toString());
        Xutils.getInstance(this).post(API.REGISTER_WITH_MOBILE, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.start_Activity(RegisterActivity.this, LoginActivity.class);
            }

            @Override
            public void onFinished() {

            }
        });
    }

    /**
     * 获取验证码（点击验证码文字）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.tv_register_verify})
    private void getVerify(View v) {
        if (mPhone.getText().toString().isEmpty()){
            Utils.showShortToast(this,"请输入正确的手机号");
            return;
        }
        calcGetVerifyTime();
        Map<String, String> map = new HashMap<>();
        map.put("mobile", mPhone.getText().toString());
        RequestParams params = new RequestParams(API.GET_VERIFY_MOBILE);
        try {
            params.addQueryStringParameter("sign", Utils.getSignature(map, Constants.SECRET));
            params.addQueryStringParameter("mobile", mPhone.getText().toString());
            x.http().get(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    BaseResult baseResult = Utils.parseJsonWithGson(result, BaseResult.class);
                    if (!(baseResult.getCode() == Constants.HTTP_OK_200)) {
                        Utils.showShortToast(RegisterActivity.this, baseResult.getError());
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(RegisterActivity.this, getString(R.string.network_error));
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(RegisterActivity.this, getString(R.string.network_error));
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
     * 计算再次获取验证码的时间
     *
     */
    private void calcGetVerifyTime() {
        mGetVerify.setEnabled(false);
        new Thread(new Runnable() {
            @Override
            public void run() {
                for (int i = 59; i >= 0; i--) {
                    try {
                        Thread.sleep(1000);
                        mHandler.sendEmptyMessage(i);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();
    }

    /**
     * 跳转到登录（点击底部文字）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.tv_register_login})
    private void goLogin(View v) {
        Utils.start_Activity(this, LoginActivity.class);
    }

}
