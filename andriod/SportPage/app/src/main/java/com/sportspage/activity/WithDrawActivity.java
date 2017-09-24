package com.sportspage.activity;

import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.event.UpdateMoneyEvent;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;
import com.sportspage.wxapi.WXEntryActivity;

import org.greenrobot.eventbus.EventBus;
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

@ContentView(R.layout.activity_withdraw)
public class WithDrawActivity extends SwipeBackActivity {
    @ViewInject(R.id.txt_title)
    private TextView mTitle;

    @ViewInject(R.id.iv_back)
    private ImageView mBackView;

    @ViewInject(R.id.et_alipay_id)
    private EditText mAccount;

    @ViewInject(R.id.et_withdraw_name)
    private EditText mName;
    @ViewInject(R.id.et_withdraw_money)
    private EditText mMoney;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();

    }

    private void init() {
        mTitle.setText(R.string.withdraw);
        mBackView.setVisibility(View.VISIBLE);
    }

    @Event(R.id.btn_withdraw)
    private void withDraw(View v){
        if (mAccount.getText().toString().equals("")) {
            Utils.showShortToast(this,"请输入帐号");
            return;
        }
        if (mName.getText().toString().equals("")) {
            Utils.showShortToast(this,"请输入名字");
            return;
        }
        if (mMoney.getText().toString().equals("")) {
            Utils.showShortToast(this,"请输入金额");
            return;
        }
        String userId = Utils.getValue(this,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        map.put("account",mAccount.getText().toString());
        map.put("name",mName.getText().toString());
        map.put("amount",mMoney.getText().toString());
        Xutils.getInstance(this).post(API.SUBMIT_WITHDRAW, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(WithDrawActivity.this,getString(R.string.withdraw_success));
                float balance=Utils.getFloatValue(WithDrawActivity.this,"balance")
                        - Float.parseFloat(mMoney.getText().toString());
                Utils.putFloatValue(WithDrawActivity.this,"balance",balance);
                EventBus.getDefault().post(new UpdateMoneyEvent());
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Override
    public void finish() {
        super.finish();
        this.overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

}
