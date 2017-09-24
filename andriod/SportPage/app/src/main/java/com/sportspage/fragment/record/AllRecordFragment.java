package com.sportspage.fragment.record;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.activity.SportsDetailActivity;
import com.sportspage.adapter.RecordAdapter;
import com.sportspage.common.API;
import com.sportspage.common.BaseFragment;
import com.sportspage.common.Constants;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.RecordResult;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.bingoogolapple.refreshlayout.BGANormalRefreshViewHolder;
import cn.bingoogolapple.refreshlayout.BGARefreshLayout;
import cn.bingoogolapple.refreshlayout.BGARefreshViewHolder;
import me.yokeyword.fragmentation.SupportFragment;

/**
 * Created by Tenma on 2016/12/25.
 */

@ContentView(R.layout.fragment_record)
public class AllRecordFragment extends BaseFragment implements
        BGARefreshLayout.BGARefreshLayoutDelegate, RecyclerClickListener {

    @ViewInject(R.id.rl_record_refresh)
    private BGARefreshLayout mRefreshLayout;
    @ViewInject(R.id.rv_record_list)
    private RecyclerView mRecyclerView;
    private List<RecordResult> mDatas;
    private Activity mContext;
    private int mOffset = 0;

    public AllRecordFragment() {
        mDatas = new ArrayList<>();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = x.view().inject(this, inflater, container);
        mContext = getActivity();
        init();
        return view;
    }

    private void init() {
        mRefreshLayout.setDelegate(this);
        // 设置下拉刷新和上拉加载更多的风格     参数1：应用程序上下文，参数2：是否具有上拉加载更多功能
        BGARefreshViewHolder refreshViewHolder = new BGANormalRefreshViewHolder(mContext, true);
        // 设置下拉刷新和上拉加载更多的风格
        mRefreshLayout.setRefreshViewHolder(refreshViewHolder);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(mContext));
        RecordAdapter adapter = new RecordAdapter(mContext, mDatas);
        mRecyclerView.setAdapter(adapter);
        adapter.setmListener(this);
        mRefreshLayout.beginRefreshing();
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
    }

    @Override
    public void onBGARefreshLayoutBeginRefreshing(BGARefreshLayout refreshLayout) {
        String userId = Utils.getValue(mContext, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("offset", mOffset + "");
        map.put("size", "10");
        Xutils.getInstance(mContext,false).get(API.GET_MINE_ORDERS, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                try {
                    List<RecordResult> datas = new ArrayList<>();
                    JSONObject resultObject = new JSONObject(result);
                    JSONArray array = resultObject.getJSONArray("data");
                    for (int i = 0; i < array.length(); i++) {
                        datas.add(Utils.parseJsonWithGson(array.getString(i), RecordResult.class));
                    }
                    mDatas.clear();
                    mDatas.addAll(datas);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFinished() {
                mRefreshLayout.endRefreshing();
            }
        });
    }

    @Override
    public boolean onBGARefreshLayoutBeginLoadingMore(BGARefreshLayout refreshLayout) {
        mOffset += 10;
        String userId = Utils.getValue(mContext, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("offset", mOffset + "");
        map.put("size", "10");
        Xutils.getInstance(mContext,false).get(API.GET_MINE_ORDERS, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                try {
                    List<RecordResult> datas = new ArrayList<>();
                    JSONObject resultObject = new JSONObject(result);
                    JSONArray array = resultObject.getJSONArray("data");
                    for (int i = 0; i < array.length(); i++) {
                        datas.add(Utils.parseJsonWithGson(array.getString(i), RecordResult.class));
                    }
                    if (array.length() != 0) {
                        mDatas.addAll(datas);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFinished() {
                mRefreshLayout.endLoadingMore();
            }
        });
        return true;
    }

    @Override
    public void onRecycleItemClick(int position) {
        Intent intent = new Intent();
        intent.putExtra("eventId",mDatas.get(position).getEvent_id());
        intent.setClass(mContext,SportsDetailActivity.class);
        Utils.start_Activity(mContext,intent);
    }

}
