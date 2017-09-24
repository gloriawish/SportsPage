package com.sportspage.activity;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.event.ClubJoinWayEvent;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.greenrobot.eventbus.EventBus;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.HashMap;
import java.util.Map;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_join_club_setting)
public class JoinClubSettingActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.tv_title_right)
    private TextView mRightTxt;
    @ViewInject(R.id.iv_join_claub_allow_all)
    private ImageView mAllowAll;
    @ViewInject(R.id.iv_jonin_club_need_auth)
    private ImageView mNeedAuth;

    private String mWay;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("选择加入俱乐部方式");
        mBackView.setVisibility(View.VISIBLE);
        mRightTxt.setVisibility(View.VISIBLE);
        mRightTxt.setText("完成");
        String joinType = getIntent().getStringExtra("joinType");
        if ("1".equals(joinType)) {
            mAllowAll.setVisibility(View.VISIBLE);
        } else {
            mNeedAuth.setVisibility(View.VISIBLE);
        }
        mWay = joinType;
    }

    @Event(R.id.iv_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }


    @Event(R.id.rl_join_club_allow_all)
    private void allowAll(View v) {
        mAllowAll.setVisibility(View.VISIBLE);
        mNeedAuth.setVisibility(View.INVISIBLE);
        mWay = Constants.JOIN_TYPE_UNCONDITIONAL;
    }

    @Event(R.id.rl_jonin_club_need_auth)
    private void needAuth(View v) {
        mAllowAll.setVisibility(View.INVISIBLE);
        mNeedAuth.setVisibility(View.VISIBLE);
        mWay = Constants.JOIN_TYPE_NEED_CHECK;
    }

    @Event(R.id.tv_title_right)
    private void complete(View v) {
        Map<String,String> map = new HashMap<>();
        map.put("userId",Utils.getValue(this,"userId"));
        map.put("clubId",getIntent().getStringExtra("clubId"));
        map.put("joinType",mWay);
        Xutils.getInstance(this).post(API.UPDATE_JOIN_TYPE, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(),"修改成功");
                EventBus.getDefault().post(new ClubJoinWayEvent(mWay));
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }
}
