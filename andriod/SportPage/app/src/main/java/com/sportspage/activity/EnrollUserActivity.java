package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.makeramen.roundedimageview.RoundedImageView;
import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.adapter.EnrollUserAdapter;
import com.sportspage.common.API;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.SportDetailResult;
import com.sportspage.utils.LogicUtils;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_enroll_user)
public class EnrollUserActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.rlv_enroll_user_list)
    private RecyclerView mRecyclerView;
    @ViewInject(R.id.riv_enroll_user_img)
    private RoundedImageView mPortrait;
    @ViewInject(R.id.tv_enroll_user_name)
    private TextView mName;
    @ViewInject(R.id.btn_enroll_user)
    private Button mViewInfo;
    private Gson gson = new Gson();

    private int mRelative;

    private SportDetailResult.EnrollUserBean mCreate;

    private List<SportDetailResult.EnrollUserBean> mDatas;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("已报名");
        mBackView.setVisibility(View.VISIBLE);
        mDatas = new ArrayList<>();
        mRecyclerView.setLayoutManager(new LinearLayoutManager(this));
        EnrollUserAdapter adapter = new EnrollUserAdapter(this,mDatas);
        mRecyclerView.setAdapter(adapter);
        getEnrollUserData();
        getCreaterData();
    }

    private void getCreaterData() {
        Logger.d(getIntent().getStringExtra("creator"));
        String creatorStr = getIntent().getStringExtra("creator");
        mRelative = getIntent().getIntExtra("relation",0);
        if (creatorStr !=null && !creatorStr.isEmpty()){
            mCreate = Utils.parseJsonWithGson(creatorStr,
                    SportDetailResult.EnrollUserBean.class);
            LogicUtils.loadImageFromUrl(mPortrait,mCreate.getPortrait());
            mName.setText(mCreate.getNick());
            switch (mRelative){
                case -1:
                    mViewInfo.setVisibility(View.GONE);
                    break;
                case 0:
                    mViewInfo.setText(R.string.add_friend);
                    mViewInfo.setBackgroundResource(R.drawable.btn_bg_blue);
                    break;
                case 1:
                    mViewInfo.setText(R.string.view_info);
                    break;
            }
        }
    }

    @Event(R.id.btn_enroll_user)
    private void onClick(View v){
        switch (mRelative){
            case 0:
                addFriend();
                break;
            case 1:
                viewInfo();
                break;
        }
    }

    private void viewInfo() {
        Intent intent = new Intent();
        intent.putExtra("userId",mCreate.getId());
        intent.putExtra("nick",mCreate.getNick());
        intent.putExtra("email",mCreate.getEmail());
        intent.putExtra("city",mCreate.getCity());
        intent.putExtra("portrait",mCreate.getPortrait());
        intent.setClass(this,UserDetailActivity.class);
        Utils.start_Activity(this,intent);
    }

    private void addFriend() {
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("friendId", mCreate.getId());
        Xutils.getInstance(this).post(API.ADD_FRIEND, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(),"等待对方同意");
                mViewInfo.setBackgroundResource(R.drawable.btn_bg_gray);
                mViewInfo.setEnabled(false);
            }

            @Override
            public void onFinished() {

            }
        });
    }


    private void getEnrollUserData() {
        Logger.d(getIntent().getStringExtra("enroll_user"));
        String enrollStrs = getIntent().getStringExtra("enroll_user");
        if (enrollStrs !=null && !enrollStrs.isEmpty()){
            List<SportDetailResult.EnrollUserBean> enrollUsers = gson.fromJson(enrollStrs,
                    new TypeToken<List<SportDetailResult.EnrollUserBean>>(){}.getType());
            mDatas.addAll(enrollUsers);
//            mRecyclerView.getAdapter().notifyDataSetChanged();
        }

    }

    @Event(R.id.iv_back)
    private void back(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
    }

}
