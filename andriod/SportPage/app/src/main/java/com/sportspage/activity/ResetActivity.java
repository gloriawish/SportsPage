package com.sportspage.activity;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.BaseActivity;
import com.sportspage.common.BaseResult;
import com.sportspage.common.Constants;
import com.sportspage.utils.Utils;

import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@ContentView(R.layout.activity_reset)
public class ResetActivity extends BaseActivity {
    /** Log标记 */
    private final String TAG = "ResetActivity";
    /** 手机号输入框 */
    @ViewInject(R.id.et_reset_phone)
    private EditText mPhone;
    /** 密码输入框 */
    @ViewInject(R.id.et_reset_password)
    private EditText mPassword;
    /** 验证码输入框 */
    @ViewInject(R.id.et_reset_verify)
    private EditText mVerify;
    /** 获取验证码文字 */
    @ViewInject(R.id.tv_reset_verify)
    private TextView mGetVerify;
    /** 更新验证码倒计时handler */
    private Handler mHandler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if(msg.what != 0){
                mGetVerify.setText(msg.what+" s");
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
    }

    /**
     * 重置密码（点击重置按钮）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.btn_reset})
    private void reset(View v){
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
        Map<String,String> map = new HashMap<>();
        map.put("mobile",mPhone.getText().toString());
        map.put("password",mPassword.getText().toString());
        map.put("verify",mVerify.getText().toString());
        RequestParams params = new RequestParams(API.RESET_PASSWORD);
        try {
            params.addParameter("sign", Utils.getSignature(map, Constants.SECRET));
            params.addParameter("mobile",mPhone.getText().toString());
            params.addParameter("password",mPassword.getText().toString());
            params.addParameter("verify",mVerify.getText().toString());
            x.http().post(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    BaseResult baseResult = Utils.parseJsonWithGson(result,BaseResult.class);
                    if (baseResult.getCode()== Constants.HTTP_OK_200){
                        Utils.start_Activity(ResetActivity.this,LoginActivity.class);
                    } else {
                        Utils.showShortToast(ResetActivity.this, baseResult.getError());
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(ResetActivity.this, getString(R.string.network_error));
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(ResetActivity.this, getString(R.string.network_error));
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
     * 获取验证码（点击验证码文字）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.tv_reset_verify})
    private void getVerify(View v){
        if (mPhone.getText().toString().isEmpty()){
            Utils.showShortToast(this,"请输入正确的手机号");
            return;
        }
        calcGetVerifyTime();
        Map<String,String> map = new HashMap<>();
        map.put("mobile",mPhone.getText().toString());
        RequestParams params = new RequestParams(API.GET_VERIFY_MOBILE);
        try {
            params.addQueryStringParameter("sign",Utils.getSignature(map, Constants.SECRET));
            params.addQueryStringParameter("mobile",mPhone.getText().toString());
            x.http().get(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    BaseResult baseResult = Utils.parseJsonWithGson(result,BaseResult.class);
                    if (!(baseResult.getCode()== Constants.HTTP_OK_200)){
                        Utils.showShortToast(ResetActivity.this, baseResult.getError());
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(ResetActivity.this, getString(R.string.network_error));
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(ResetActivity.this, getString(R.string.network_error));
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
     * 退回登录（点击底部文字）
     *
     * @param v 点击视图
     */
    @Event(value = {R.id.tv_reset_back})
    private void back(View v){
        finish();
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
                for (int i=59;i>=0;i--) {
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
}
