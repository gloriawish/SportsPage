package com.sportspage.fragment.discover;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.activity.SportsDetailActivity;
import com.sportspage.adapter.FollowAdapter;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.EventResult;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

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

@ContentView(R.layout.fragment_focus)
public class FocusFragment extends SupportFragment implements RecyclerClickListener,
        BGARefreshLayout.BGARefreshLayoutDelegate {

    private Activity mContext;

    private List<EventResult.DataBean> mDatas;

    @ViewInject(R.id.rv_focus_list)
    private RecyclerView mRecyclerView;

    @ViewInject(R.id.refresh_focus)
    private BGARefreshLayout mRefreshLayout;

    private int mSize;

    public FocusFragment() {
        mDatas = new ArrayList<>();
    }

    private int mOffset = 0;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = x.view().inject(this, inflater, container);
        mContext = getParentFragment().getActivity();
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
        FollowAdapter adapter = new FollowAdapter(mContext, mDatas);
        // 设置适配器
        mRecyclerView.setAdapter(adapter);
        adapter.setmListener(this);
        mRefreshLayout.beginRefreshing();
    }

    @Override
    public void onRecycleItemClick(int position) {
        Intent intent = new Intent();
        intent.putExtra("sportId",mDatas.get(position).getId());
        intent.putExtra("eventId",mDatas.get(position).getEvent_id());
        if(mDatas.get(position).getStatus().equals("0")){
            intent.putExtra("type", Constants.SPORT_TYPE);
        }
        intent.setClass(mContext,SportsDetailActivity.class);
        Utils.start_Activity(mContext,intent);
    }

    @Override
    public void onBGARefreshLayoutBeginRefreshing(BGARefreshLayout refreshLayout) {
        requestRefresh();
    }

    @Override
    public boolean onBGARefreshLayoutBeginLoadingMore(BGARefreshLayout refreshLayout) {
        loadMore();
        return true;
    }

    public void requestRefresh() {
        mOffset = 0;
        String userId = Utils.getValue(mContext, "userId","");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("offset", mOffset + "");
        map.put("size", "10");
        Xutils.getInstance(mContext).get(API.GET_FOLLOW_EVENT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                EventResult eventResult = Utils.parseJsonWithGson(result,EventResult.class);
                mDatas.clear();
                mDatas.addAll(eventResult.getData());
            }

            @Override
            public void onFinished() {
                mRefreshLayout.endRefreshing();
            }
        });
    }

    private void loadMore() {
        mOffset += 10;
        String userId = Utils.getValue(mContext, "userId","");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("offset", mOffset + "");
        map.put("size", "10");
        Xutils.getInstance(mContext).get(API.GET_FOLLOW_EVENT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                EventResult eventResult = Utils.parseJsonWithGson(result,EventResult.class);
                if (eventResult.getData().size() != 0){
                    mDatas.addAll(eventResult.getData());
                }
            }

            @Override
            public void onFinished() {
                mRefreshLayout.endLoadingMore();
            }
        });
    }


    @Override
    public void onDetach() {
        super.onDetach();
    }

}
