package com.sportspage.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.pingplusplus.android.Pingpp;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

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

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_settle)
public class SettleActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.tv_settle_sportName)
    private TextView mSportName;
    @ViewInject(R.id.tv_settle_date)
    private TextView mDate;
    @ViewInject(R.id.tv_settle_time)
    private TextView mTime;
    @ViewInject(R.id.tv_settle_address)
    private TextView mAddress;
    @ViewInject(R.id.tv_settle_pay)
    private TextView mPay;
    @ViewInject(R.id.tv_settle_money)
    private TextView mMoney;
    @ViewInject(R.id.tv_settle_num)
    private TextView mErollNum;
    @ViewInject(R.id.tv_settle_should_pay)
    private TextView mShouldPay;
    @ViewInject(R.id.tv_settle_inall)
    private TextView mInAll;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("运动结算");
        mBackView.setVisibility(View.VISIBLE);
        mSportName.setText(getIntent().getStringExtra("sportName"));
        mDate.setText(getIntent().getStringExtra("date"));
        mTime.setText(getIntent().getStringExtra("time"));
        mAddress.setText(getIntent().getStringExtra("location"));
        mPay.setText(getIntent().getStringExtra("pay"));
        if (null==getIntent().getStringExtra("money") || getIntent().getStringExtra("money").isEmpty()) {
            mMoney.setText("免费");
        } else {
            mMoney.setText(getIntent().getStringExtra("money") + "元/人");
        }
        if (null == getIntent().getStringExtra("num") || getIntent().getStringExtra("num").isEmpty()) {
            mErollNum.setText("0");
        } else {
            mErollNum.setText(getIntent().getStringExtra("num"));
        }
        String all = getIntent().getStringExtra("all");
        if (null==all || all.equals("0.00")) {
            mShouldPay.setText(R.string.free);
        } else {
            mInAll.setText("￥" + all);
            mShouldPay.setText("￥" + all);
        }
    }

    @Event(R.id.btn_settle_pay)
    private void payWay(View v) {
        String eventId = getIntent().getStringExtra("eventId");
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("eventId", eventId);
        map.put("userId", userId);
        Xutils.getInstance(this).post(API.SETTLEMENT_EVENT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(), "结算成功");
                setResult(RESULT_OK);
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(R.id.iv_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }
}
