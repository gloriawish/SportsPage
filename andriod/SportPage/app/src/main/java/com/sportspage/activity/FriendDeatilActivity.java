package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.HashMap;
import java.util.Map;

import io.rong.imkit.RongIM;
import me.yokeyword.swipebackfragment.SwipeBackActivity;


@ContentView(R.layout.activity_friend_detail)
public class FriendDeatilActivity extends SwipeBackActivity {
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.iv_detail_portrait)
    private ImageView mPortrait;
    @ViewInject(R.id.tv_detail_nick)
    private TextView mNick;
    @ViewInject(R.id.tv_detail_accout)
    private TextView mPhone;
    @ViewInject(R.id.tv_detail_location)
    private TextView mLocation;
    private String mNickName;
    private String mUserId;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mBackView.setVisibility(View.VISIBLE);
        mTitle.setText(R.string.detail_info);
        Intent intent = getIntent();
        mNickName = intent.getStringExtra("nick");
        mUserId = intent.getStringExtra("userId");
        String phone= intent.getStringExtra("phone");
        String location = intent.getStringExtra("city");
        String portrait = intent.getStringExtra("portrait");
        mNick.setText(mNickName);
        mPhone.setText("手机号:"+phone);
        mLocation.setText(location);
        x.image().bind(mPortrait,portrait);

    }

    @Event(value = R.id.iv_back)
    private void back(View v){
        finish();
        this.overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }


    @Event(value = R.id.btn_detail_add)
    private void add(View v){
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("friendId", mUserId);
        Xutils.getInstance(this).post(API.ADD_FRIEND, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(), getString(R.string.wait_confirm));
                finish();
                Utils.start_Activity(FriendDeatilActivity.this,MainActivity.class);
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
