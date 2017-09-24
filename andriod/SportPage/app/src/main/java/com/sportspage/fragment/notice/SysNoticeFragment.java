package com.sportspage.fragment.notice;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.sportspage.R;
import com.sportspage.activity.SportsDetailActivity;
import com.sportspage.adapter.NoticeAdapter;
import com.sportspage.adapter.RecordAdapter;
import com.sportspage.common.API;
import com.sportspage.common.BaseFragment;
import com.sportspage.common.Constants;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.MainNoticeResult;
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

/**
 * Created by Tenma on 2016/12/25.
 */

@ContentView(R.layout.fragment_record)
public class SysNoticeFragment extends BaseFragment implements
        BGARefreshLayout.BGARefreshLayoutDelegate {

    @ViewInject(R.id.rl_record_refresh)
    private BGARefreshLayout mRefreshLayout;
    @ViewInject(R.id.rv_record_list)
    private RecyclerView mRecyclerView;
    private List<MainNoticeResult.DataBean> mDatas;
    private Activity mContext;
    private int mOffset = 0;

    public SysNoticeFragment() {
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
        NoticeAdapter adapter = new NoticeAdapter(mContext, mDatas);
        mRecyclerView.setAdapter(adapter);
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
        map.put("type", Constants.NOTICE_TYPE_INFO);
        map.put("offset", mOffset + "");
        map.put("size", "10");
        Xutils.getInstance(mContext,false).get(API.GET_NOTIFY, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                MainNoticeResult mainNoticeResult = Utils.parseJsonWithGson(result, MainNoticeResult.class);
                if (mainNoticeResult.getSize() !=0 ){
                    mDatas.clear();
                    mDatas.addAll(mainNoticeResult.getData());
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
        map.put("type", Constants.NOTICE_TYPE_INFO);
        map.put("offset", mOffset + "");
        map.put("size", "10");
        Xutils.getInstance(mContext,false).get(API.GET_NOTIFY, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                MainNoticeResult mainNoticeResult = Utils.parseJsonWithGson(result, MainNoticeResult.class);
                if (mainNoticeResult.getSize() !=0 ){
                    mDatas.addAll(mainNoticeResult.getData());
                }
            }

            @Override
            public void onFinished() {
                mRefreshLayout.endLoadingMore();
            }
        });
        return true;
    }

}
