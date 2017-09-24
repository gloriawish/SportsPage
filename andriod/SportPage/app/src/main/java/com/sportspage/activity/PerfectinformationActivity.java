package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
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

import me.yokeyword.swipebackfragment.SwipeBackActivity;


@ContentView(R.layout.activity_perfect_information)
public class PerfectinformationActivity extends SwipeBackActivity {
    /** 返回键 */
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    /** 导航栏标题 */
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    /** 手机号输入框 */
    @ViewInject(R.id.et_improve_phone)
    private EditText mPhone;
    /** 验证码输入框 */
    @ViewInject(R.id.et_improve_verify)
    private EditText mVerify;
    /** 获取验证码按钮 */
    @ViewInject(R.id.btn_improve_getverify)
    private Button mGetVerify;

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

    /**
     * 初始化
     *
     */
    private void init() {
        mBackView.setVisibility(View.VISIBLE);
        mTitle.setText(R.string.improve_info);
    }


    @Event(R.id.btn_improve)
    private void improve(View v){
        if (mPhone.getText().toString().isEmpty()){
            Utils.showShortToast(this,"请输入正确的手机号");
            return;
        }
        if (mVerify.getText().toString().isEmpty()){
            Utils.showShortToast(this,"请输入验证码");
            return;
        }

        String userId = Utils.getValue(this,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        map.put("mobile",mPhone.getText().toString());
        map.put("verify",mVerify.getText().toString());
        RequestParams params = new RequestParams(API.BIND_MOBILE);
        try {
            params.addParameter("sign", Utils.getSignature(map, Constants.SECRET));
            params.addParameter("userId",userId);
            params.addParameter("mobile",mPhone.getText().toString());
            params.addParameter("verify",mVerify.getText().toString());
            x.http().post(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    BaseResult baseResult = Utils.parseJsonWithGson(result,BaseResult.class);
                    if (baseResult.getCode()== Constants.HTTP_OK_200){
                        Utils.showShortToast(PerfectinformationActivity.this,getString(R.string.improve_success));
                        setResult(RESULT_OK,new Intent().putExtra("perfectResult",true));
                        Utils.putValue(x.app(),"phone",mPhone.getText().toString());
                        finish();
                    } else {
                        Utils.showShortToast(PerfectinformationActivity.this, baseResult.getError());
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(PerfectinformationActivity.this, getString(R.string.network_error));
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(PerfectinformationActivity.this, getString(R.string.network_error));
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
    @Event(value = {R.id.btn_improve_getverify   })
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
                        Utils.showShortToast(PerfectinformationActivity.this, baseResult.getError());
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(PerfectinformationActivity.this, getString(R.string.network_error));
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(PerfectinformationActivity.this, getString(R.string.network_error));
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

    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }
}
