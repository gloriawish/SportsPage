package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.adapter.ClubListAdapter;
import com.sportspage.common.API;
import com.sportspage.entity.ClubDetailResult;
import com.sportspage.event.CreateClubEvent;
import com.sportspage.event.UpdateBadgeEvent;
import com.sportspage.event.UpdateClubNameEvent;
import com.sportspage.event.UpdateClubSportItemEvent;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_my_club)
public class MyClubActivity extends SwipeBackActivity implements ClubListAdapter.ClubListListener {
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.tv_title_right)
    private TextView mRightText;
    @ViewInject(R.id.rv_my_club)
    private RecyclerView mClubList;
    private ClubListAdapter mAdapter;
    private List<ClubDetailResult> mDatas;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        x.view().inject(this);
        initView();
    }

    private void initView() {
        EventBus.getDefault().register(this);
        mBackView.setVisibility(View.VISIBLE);
        mTitle.setText("我的俱乐部");
        mRightText.setText("创建");
        mDatas = new ArrayList<>();
        mAdapter = new ClubListAdapter(this,mDatas);
        mAdapter.setmListener(this);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        mClubList.setLayoutManager(linearLayoutManager);
        mClubList.setAdapter(mAdapter);
        getClubs();
    }

    private void getClubs() {
        String userId = Utils.getValue(this,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        Xutils.getInstance(this).get(API.GET_USER_CLUBS, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                try {
                    mDatas.clear();
                    JSONObject resultObject = new JSONObject(result);
                    JSONArray createArray = resultObject.getJSONArray("create");
                    JSONArray joinArray = resultObject.getJSONArray("join");
                    JSONArray adminArray = resultObject.getJSONArray("admin");
                    for (int i = 0; i <createArray.length() ; i++) {
                        ClubDetailResult clubResult = Utils.parseJsonWithGson(
                                createArray.get(i).toString(),ClubDetailResult.class);
                        mDatas.add(clubResult);
                    }
                    for (int i = 0; i <adminArray.length() ; i++) {
                        ClubDetailResult clubResult = Utils.parseJsonWithGson(
                                adminArray.get(i).toString(),ClubDetailResult.class);
                        mDatas.add(clubResult);
                    }
                    for (int i = 0; i <joinArray.length() ; i++) {
                        ClubDetailResult clubResult = Utils.parseJsonWithGson(
                                joinArray.get(i).toString(),ClubDetailResult.class);
                        mDatas.add(clubResult);
                    }
                    mAdapter.setListCount(createArray.length(),adminArray.length(),joinArray.length());
                    mAdapter.notifyDataSetChanged();

                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(R.id.tv_title_right)
    private void createClub(View view) {
        Utils.start_Activity(this,CreateClubActivity.class);
    }


    @Override
    public void itemClick(int position) {
        Intent intent = new Intent();
        intent.putExtra("clubId",mDatas.get(position).getId());
        intent.setClass(this,ClubActivity.class);
        Utils.start_Activity(this,intent);
    }

    @Event(R.id.iv_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in,R.anim.push_right_out);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }

    @Subscribe
    public void onEventMainThread(UpdateBadgeEvent event) {
        getClubs();
    }

    @Subscribe
    public void onEventMainThread(UpdateClubNameEvent event) {
        getClubs();
    }

    @Subscribe
    public void onEventMainThread(UpdateClubSportItemEvent event) {
        getClubs();
    }

    @Subscribe
    public void onEventMainThread(CreateClubEvent event) {
        getClubs();
    }

}
