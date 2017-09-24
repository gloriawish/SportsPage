package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.utils.LogicUtils;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;
import com.zhy.autolayout.AutoRelativeLayout;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.HashMap;
import java.util.Map;

import io.rong.imkit.RongIM;
import me.yokeyword.swipebackfragment.SwipeBackActivity;


@ContentView(R.layout.activity_user_detail)
public class UserDetailActivity extends SwipeBackActivity {
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.iv_detail_portrait)
    private ImageView mPortrait;
    @ViewInject(R.id.tv_detail_nick)
    private TextView mNick;
    @ViewInject(R.id.tv_detail_accout)
    private TextView mEmail;
    @ViewInject(R.id.tv_detail_location)
    private TextView mLocation;
    @ViewInject(R.id.img_right)
    private ImageView mRightView;
    @ViewInject(R.id.rl_detail_ramark)
    private RelativeLayout mRemarkLayout;
    @ViewInject(R.id.rl_detail_more)
    private RelativeLayout mDetailLayout;
    @ViewInject(R.id.btn_detail_send)
    private Button mSendBtn;


    private String mNickName;
    private String mUserId;
    private String mLocationStr;
    private String mPortraitUrl;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mBackView.setVisibility(View.VISIBLE);
        mRightView.setVisibility(View.VISIBLE);
        mTitle.setText(R.string.detail_info);
        Intent intent = getIntent();
        mUserId = intent.getStringExtra("userId");
        if (intent.getBooleanExtra("opration",true)) {
            mNickName = intent.getStringExtra("nick");
            String email= intent.getStringExtra("email");
            mLocationStr = intent.getStringExtra("city");
            mPortraitUrl = intent.getStringExtra("portrait");
            mEmail.setText("邮箱:"+email);
            initView();
        } else {
            mRemarkLayout.setVisibility(View.GONE);
            mDetailLayout.setVisibility(View.GONE);
            mSendBtn.setVisibility(View.GONE);
            Map<String, String> map = new HashMap<>();
            map.put("userId", mUserId);
            Xutils.getInstance(this).get(API.GET_USERINFO, map, new Xutils.XCallBack() {
                @Override
                public void onResponse(String result) {
                    UserInfoResult.ResultBean mInfo = Utils.parseJsonWithGson(result,
                            UserInfoResult.ResultBean.class);
                    mNickName = mInfo.getNick();
                    mLocationStr = mInfo.getCity();
                    mPortraitUrl = mInfo.getPortrait();
                    initView();
                }

                @Override
                public void onFinished() {

                }
            });
        }
    }

    private void initView() {
        mLocation.setText(mLocationStr);
        mNick.setText(mNickName);
        LogicUtils.loadImageFromUrl(mPortrait,mPortraitUrl);
    }

    @Event(R.id.iv_back)
    private void back(View v){
        finish();
        this.overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Event(R.id.img_right)
    private void infoSetting(View v){
        Intent intent = new Intent();
        intent.putExtra("friendId",mUserId);
        intent.setClass(this,FirendSettingAvtivity.class);
        this.startActivity(intent);
        this.overridePendingTransition(R.anim.push_left_in,
                R.anim.push_left_out);
    }

    @Event(R.id.rl_detail_ramark)
    private void remark(View v){
    }

    @Event(R.id.rl_detail_more)
    private void more(View v){
    }

    @Event(R.id.btn_detail_send)
    private void sendMsg(View v){
        RongIM.getInstance().startPrivateChat(this, mUserId, mNickName);
    }

    @Override
    public void finish() {
        super.finish();
        this.overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }
}
