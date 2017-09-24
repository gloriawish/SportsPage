package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.adapter.ApplyListAdapter;
import com.sportspage.adapter.InviteListAdapter;
import com.sportspage.common.API;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.InviteRequestResult;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

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

@ContentView(R.layout.activity_invite_list)
public class ApplyListActivity extends SwipeBackActivity implements RecyclerClickListener {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.rv_invite_list)
    private RecyclerView mInviteList;

    private List<InviteRequestResult> mDatas;

    private ApplyListAdapter mAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        x.view().inject(this);
        init();
        getData();
    }

    private void init() {
        mDatas = new ArrayList<>();
        mAdapter = new ApplyListAdapter(this,mDatas);
        mAdapter.setmListener(this);
        mTitle.setText("俱乐部申请");
        mBackView.setVisibility(View.VISIBLE);
        mInviteList.setLayoutManager(new LinearLayoutManager(this));
        mInviteList.setAdapter(mAdapter);
    }

    private void getData() {
        Map<String,String> map = new HashMap<>();
        map.put("userId", Utils.getValue(this,"userId"));
        Xutils.getInstance(this).get(API.GET_APPLY_REQUEST, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                try {
                    JSONObject resultObject = new JSONObject(result);
                    String data = resultObject.getString("data");
                    List<InviteRequestResult> datas = Utils.jsonToArrayList(data,InviteRequestResult.class);
                    mDatas.addAll(datas);
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


    @Event(R.id.iv_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Override
    public void onRecycleItemClick(int position) {
        Intent intent = new Intent();
        intent.putExtra("userId",mDatas.get(position).getFrom_id());
        intent.putExtra("opration",false);
        intent.setClass(this,UserDetailActivity.class);
        Utils.start_Activity(this,intent);
    }
}
