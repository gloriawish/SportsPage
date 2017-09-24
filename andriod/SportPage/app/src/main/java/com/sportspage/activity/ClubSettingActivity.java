package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.adapter.ClubSettingMemberAdapter;
import com.sportspage.common.Constants;
import com.sportspage.entity.ClubDetailResult;
import com.sportspage.event.ClubJoinWayEvent;
import com.sportspage.event.PublishNoticeEvent;
import com.sportspage.event.UpdateBadgeEvent;
import com.sportspage.event.UpdateCoverEvent;
import com.sportspage.utils.Utils;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.List;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_club_setting)
public class ClubSettingActivity extends SwipeBackActivity {

    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.img_right)
    private ImageView mRightView;
    @ViewInject(R.id.tv_club_member_num)
    private TextView mMemberNum;
    @ViewInject(R.id.rv_club_setting_member)
    private RecyclerView mMemberView;

    private Bundle mBundle;

    private ArrayList<String> mDatas;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        initData();
        initView();
    }

    private void initView() {
        EventBus.getDefault().register(this);
        mBackView.setVisibility(View.VISIBLE);
//        mRightView.setVisibility(View.VISIBLE);
        mTitle.setText("俱乐部设置");
        LinearLayoutManager linearLayout = new LinearLayoutManager(this);
        linearLayout.setOrientation(LinearLayoutManager.HORIZONTAL);
        mMemberView.setLayoutManager(linearLayout);
        mMemberView.setAdapter(new ClubSettingMemberAdapter(this, mDatas));
        mMemberNum.setText(mBundle.getString("membersCount")+"名成员");
        mBundle.remove("membersCount");
    }

    private void initData() {
        mBundle = getIntent().getBundleExtra("data");
        List<ClubDetailResult.TopMemberBean> memberBeans = Utils.jsonToArrayList(mBundle
                .getString("members"), ClubDetailResult.TopMemberBean.class);
        mDatas = new ArrayList<>();
        for (int i = 0; i < memberBeans.size(); i++) {
            mDatas.add(memberBeans.get(i).getPortrait());
        }
        mBundle.remove("members");
    }

    @Event(R.id.rl_club_setting_member)
    private void goMemberManager(View v) {
        Intent intent = new Intent();
        intent.putExtra("clubId",mBundle.getString("clubId"));
        intent.putExtra("permission",mBundle.getInt("permission"));
        intent.setClass(this,ClubMemberActivity.class);
        Utils.start_Activity(this,intent);
    }

    @Event(R.id.ll_club_join_way)
    private void goManager(View v) {
        Intent intent = new Intent();
        intent.putExtra("clubId",mBundle.getString("clubId"));
        intent.putExtra("joinType",mBundle.getString("joinType"));
        intent.setClass(this,JoinClubSettingActivity.class);
        Utils.start_Activity(this,intent);
    }

    @Event(R.id.iv_club_add_member)
    private void goAddMember(View v) {
        Intent intent = new Intent();
        intent.putExtra("clubId",mBundle.getString("clubId"));
        intent.putExtra("opration", Constants.OPRATION_ADD_MEMBER);
        intent.setClass(this,ManagerClubMemberActivity.class);
        Utils.start_Activity(this,intent);
    }

    @Event(R.id.ll_club_update)
    private void goClubUpdate(View v) {
        Intent intent = new Intent();
        intent.putExtra("data",mBundle);
        intent.setClass(this,ClubInfoActivity.class);
        Utils.start_Activity(this,intent);
    }

    @Event(R.id.iv_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
    }

    @Event(R.id.img_right)
    private void menu(View view) {

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }

    @Subscribe
    public void onEventMainThread(ClubJoinWayEvent event) {
        mBundle.putString("joinType",event.getmWay());
    }

    @Subscribe
    public void onEventMainThread(UpdateCoverEvent event) {
        mBundle.putString("cover",event.getPath());
    }

    @Subscribe
    public void onEventMainThread(UpdateBadgeEvent event) {
        mBundle.putString("badge",event.getPath());
    }
}
