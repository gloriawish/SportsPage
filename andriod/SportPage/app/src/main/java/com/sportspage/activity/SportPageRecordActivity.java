package com.sportspage.activity;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.adapter.RecordAdapter;
import com.sportspage.adapter.SportPageRecordAdapter;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.ActiveResult;
import com.sportspage.entity.RecordResult;
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
import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_sport_page_record)
public class SportPageRecordActivity extends SwipeBackActivity implements
        BGARefreshLayout.BGARefreshLayoutDelegate,RecyclerClickListener {
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.rl_sportspage_record_refresh)
    private BGARefreshLayout mRefreshLayout;
    @ViewInject(R.id.rv_sportspage_record_list)
    private RecyclerView mRecyclerView;
    private List<ActiveResult> mDatas;
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
        mTitle.setText(R.string.my_sports_page);
        mBackView.setVisibility(View.VISIBLE);
        mRefreshLayout.setDelegate(this);
        // 设置下拉刷新和上拉加载更多的风格     参数1：应用程序上下文，参数2：是否具有上拉加载更多功能
        BGARefreshViewHolder refreshViewHolder = new BGANormalRefreshViewHolder(this, true);
        // 设置下拉刷新和上拉加载更多的风格
        mRefreshLayout.setRefreshViewHolder(refreshViewHolder);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(this));
        SportPageRecordAdapter adapter = new SportPageRecordAdapter(this,mDatas);
        mRecyclerView.setAdapter(adapter);
        adapter.setmListener(this);
        mRefreshLayout.beginRefreshing();
    }

    @Override
    public void onBGARefreshLayoutBeginRefreshing(BGARefreshLayout refreshLayout) {
        mOffset = 0;
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("offset", mOffset + "");
        map.put("size", "10");
        Xutils.getInstance(this).get(API.GET_MINE_SPORT, map, new Xutils.XCallBack() {
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
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("offset", mOffset + "");
        map.put("size", "10");
        Xutils.getInstance(this).get(API.GET_MINE_SPORT, map, new Xutils.XCallBack() {
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
        intent.setClass(this,SportsDetailActivity.class);
        Utils.start_Activity(this,intent);
    }

    @Event(R.id.iv_back)
    private void back(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
    }
}
