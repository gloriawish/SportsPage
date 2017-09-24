package com.sportspage.activity;

import android.app.Activity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.adapter.GroupAdapter;
import com.sportspage.adapter.RecordAdapter;
import com.sportspage.common.API;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.GroupResult;
import com.sportspage.entity.RecordResult;
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

import io.rong.imkit.RongIM;
import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_group_list)
public class GroupListActivity extends SwipeBackActivity implements RecyclerClickListener{

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.rlv_group_list)
    private RecyclerView mRecyclerView;
    private List<GroupResult.Group> mDatas;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
        getDatas();
    }

    private void init() {
        mDatas = new ArrayList<>();
        mTitle.setText(R.string.my_group);
        mBackView.setVisibility(View.VISIBLE);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(this));
        GroupAdapter adapter = new GroupAdapter(this, mDatas);
        mRecyclerView.setAdapter(adapter);
        adapter.setmListener(this);
    }


    private void getDatas() {
        String userId = Utils.getValue(this,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        Xutils.getInstance(this).get(API.GET_MY_GROUPS, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                GroupResult groupResult = Utils.parseJsonWithGson(result,GroupResult.class);
                mDatas.addAll(groupResult.getData());
                mRecyclerView.getAdapter().notifyDataSetChanged();
            }

            @Override
            public void onFinished() {

            }
        });

    }


    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Override
    public void onRecycleItemClick(int position) {
        RongIM.getInstance().startGroupChat(this,mDatas.get(position)
                .getId(),mDatas.get(position).getName());
    }
}
