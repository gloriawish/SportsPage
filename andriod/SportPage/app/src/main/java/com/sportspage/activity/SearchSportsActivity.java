package com.sportspage.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.adapter.FriendAdapter;
import com.sportspage.adapter.HotListAdapter;
import com.sportspage.common.API;
import com.sportspage.common.BaseActivity;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.EventResult;
import com.sportspage.entity.FriendsResult;
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

import cn.bingoogolapple.refreshlayout.BGANormalRefreshViewHolder;
import cn.bingoogolapple.refreshlayout.BGARefreshLayout;
import cn.bingoogolapple.refreshlayout.BGARefreshViewHolder;
import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_search_sports)
public class SearchSportsActivity extends SwipeBackActivity implements RecyclerClickListener
        , BGARefreshLayout.BGARefreshLayoutDelegate {

    @ViewInject(R.id.et_sports_search)
    private EditText mSearchText;

    @ViewInject(R.id.btn_sports_search)
    private Button mSearchBtn;

    @ViewInject(R.id.refresh_search)
    private BGARefreshLayout mRefreshLayout;

    @ViewInject(R.id.rv_sports_search)
    private RecyclerView mRecyclerView;

    private List<EventResult.DataBean> mDatas;

    private HotListAdapter mAdapter;

    private int mOffset = 0;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mDatas = new ArrayList<>();
        mAdapter = new HotListAdapter(this,mDatas);
        mRefreshLayout.setDelegate(this);
        // 设置下拉刷新和上拉加载更多的风格     参数1：应用程序上下文，参数2：是否具有上拉加载更多功能
        BGARefreshViewHolder refreshViewHolder = new BGANormalRefreshViewHolder(this, true);
        // 设置下拉刷新和上拉加载更多的风格
        mRefreshLayout.setRefreshViewHolder(refreshViewHolder);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(this));
        mRecyclerView.setAdapter(mAdapter);
        mAdapter.setmListener(this);
        mSearchText.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView textView, int i, KeyEvent keyEvent) {
                if (i == EditorInfo.IME_ACTION_SEARCH) {
                    searchAction();
                    return true;
                }
                return false;
            }
        });
    }

    @Override
    public void onRecycleItemClick(int position) {
        Intent intent = new Intent();
        intent.putExtra("eventId",mDatas.get(position).getEvent_id());
        intent.setClass(this, SportsDetailActivity.class);
        this.startActivity(intent);
        this.overridePendingTransition(R.anim.push_left_in,
                R.anim.push_left_out);
    }

    @Event(R.id.btn_sports_search)
    private void search(View v){
        searchAction();
    }

    private void searchAction() {
        if (mSearchText.getText().toString().equals("")) {
            Utils.showShortToast(this,"请输入正确的关键字");
            return;
        }
        mOffset = 0;
        mDatas.clear();
        String userId = Utils.getValue(this,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        map.put("searchKey",mSearchText.getText().toString());
        map.put("offset",mOffset+"");
        map.put("size","10");
        Xutils.getInstance(this).get(API.SEARCH_EVENT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                EventResult eventResult = Utils.parseJsonWithGson(result,EventResult.class);
                if (eventResult.getData().size() != 0){
                    mDatas.clear();
                    mDatas.addAll(eventResult.getData());
                    Utils.hideKeyBoard();
                }
            }

            @Override
            public void onFinished() {
                mRefreshLayout.endRefreshing();
                mAdapter.notifyDataSetChanged();
            }
        });
    }

    @Override
    public void onBGARefreshLayoutBeginRefreshing(BGARefreshLayout refreshLayout) {
        mRefreshLayout.endRefreshing();
    }

    @Override
    public boolean onBGARefreshLayoutBeginLoadingMore(BGARefreshLayout refreshLayout) {
        mOffset += 10;
        String userId = Utils.getValue(this, "userId","");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("offset", mOffset + "");
        map.put("size", "10");
        Xutils.getInstance(this).get(API.SEARCH_EVENT, map, new Xutils.XCallBack() {
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
        return true;
    }
}
