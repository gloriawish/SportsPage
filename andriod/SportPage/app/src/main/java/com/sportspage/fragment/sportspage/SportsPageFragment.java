package com.sportspage.fragment.sportspage;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.activity.SportsDetailActivity;
import com.sportspage.adapter.SportPageRecordAdapter;
import com.sportspage.common.API;
import com.sportspage.common.BaseFragment;
import com.sportspage.common.Constants;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.ActiveResult;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

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

import cn.bingoogolapple.refreshlayout.BGANormalRefreshViewHolder;
import cn.bingoogolapple.refreshlayout.BGARefreshLayout;
import cn.bingoogolapple.refreshlayout.BGARefreshViewHolder;

@ContentView(R.layout.fragment_sports_page)
public class SportsPageFragment extends BaseFragment implements
        BGARefreshLayout.BGARefreshLayoutDelegate, RecyclerClickListener {

    @ViewInject(R.id.rl_sportspage_record_refresh)
    private BGARefreshLayout mRefreshLayout;
    @ViewInject(R.id.rv_sportspage_record_list)
    private RecyclerView mRecyclerView;
    private List<ActiveResult> mDatas;
    private int mOffset = 0;
    private Activity mContent;


    public SportsPageFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = x.view().inject(this, inflater, container);
        mContent = this.getActivity();
        init();
        return view;
    }

    private void init() {
        mDatas = new ArrayList<>();
        mRefreshLayout.setDelegate(this);
        // 设置下拉刷新和上拉加载更多的风格     参数1：应用程序上下文，参数2：是否具有上拉加载更多功能
        BGARefreshViewHolder refreshViewHolder = new BGANormalRefreshViewHolder(mContent, true);
        // 设置下拉刷新和上拉加载更多的风格
        mRefreshLayout.setRefreshViewHolder(refreshViewHolder);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(mContent));
        SportPageRecordAdapter adapter = new SportPageRecordAdapter(mContent,mDatas);
        mRecyclerView.setAdapter(adapter);
        adapter.setmListener(this);
        mRefreshLayout.beginRefreshing();
    }

    @Override
    public void onBGARefreshLayoutBeginRefreshing(BGARefreshLayout refreshLayout) {
        mOffset = 0;
        String userId = Utils.getValue(mContent, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("offset", mOffset + "");
        map.put("size", "10");
        Xutils.getInstance(mContent).get(API.GET_MINE_SPORT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                try {
                    List<ActiveResult> datas = new ArrayList<>();
                    JSONObject resultObject = new JSONObject(result);
                    JSONArray array = resultObject.getJSONArray("data");
                    for (int i = 0; i < array.length(); i++) {
                        datas.add(Utils.parseJsonWithGson(array.getString(i),ActiveResult.class));
                    }
                    if (array.length() !=0 ){
                        mDatas.clear();
                        mDatas.addAll(datas);
                    }
                    mRecyclerView.getAdapter().notifyDataSetChanged();
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
        String userId = Utils.getValue(mContent, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("offset", mOffset + "");
        map.put("size", "10");
        Xutils.getInstance(mContent).get(API.GET_MINE_SPORT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                try {
                    List<ActiveResult> datas = new ArrayList<>();
                    JSONObject resultObject = new JSONObject(result);
                    JSONArray array = resultObject.getJSONArray("data");
                    for (int i = 0; i < array.length(); i++) {
                        datas.add(Utils.parseJsonWithGson(array.getString(i),ActiveResult.class));
                    }
                    if (array.length() !=0){
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
        intent.putExtra("sportId",mDatas.get(position).getId());
        intent.putExtra("eventId",mDatas.get(position).getEvent_id());
        if(mDatas.get(position).getStatus().equals("0")){
            intent.putExtra("type", Constants.SPORT_TYPE);
        }
        intent.putExtra("describe",mDatas.get(position).getSummary());
        intent.setClass(mContent,SportsDetailActivity.class);
        Utils.start_Activity(mContent,intent);
    }

}
