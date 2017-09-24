package com.sportspage.activity;

import android.app.Activity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.adapter.BindSportsPageRecordAdapter;
import com.sportspage.adapter.SportPageRecordAdapter;
import com.sportspage.common.API;
import com.sportspage.entity.ActiveResult;
import com.sportspage.event.ClubBindSportsPageEvent;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.greenrobot.eventbus.EventBus;
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

@ContentView(R.layout.activity_bind_sports_page)
public class BindSportsPageActivity extends SwipeBackActivity {
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.tv_title_right)
    private TextView mRightView;
    @ViewInject(R.id.bind_list)
    private RecyclerView mBindList;

    private List<ActiveResult> mDatas;

    private BindSportsPageRecordAdapter mAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        x.view().inject(this);
        init();
        initData();
    }


    private void init() {
        mDatas = new ArrayList<>();
        mTitle.setText("绑定运动页");
        mBackView.setVisibility(View.VISIBLE);
        mRightView.setText("绑定");
        mRightView.setVisibility(View.VISIBLE);
        mBindList.setLayoutManager(new LinearLayoutManager(this));
        mAdapter = new BindSportsPageRecordAdapter(this,mDatas);
        mBindList.setAdapter(mAdapter);
    }

    private void initData() {
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("clubId", getIntent().getStringExtra("clubId"));
        Xutils.getInstance(this).get(API.GET_UNBIND_SPORT, map, new Xutils.XCallBack() {
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
    private void bind(View view) {
        Map<String,String> map = new HashMap<>();
        map.put("userId",Utils.getValue(this,"userId"));
        map.put("clubId",getIntent().getStringExtra("clubId"));
        if ("".equals(mAdapter.getCheckUserIds())) {
            Utils.showShortToast(this,"还没有选择运动页");
            return;
        }
        map.put("sportIds",mAdapter.getCheckUserIds());
        Xutils.getInstance(this).post(API.BIND_SPORT_TO_CLUB_BATCH, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(),"绑定成功！");
                EventBus.getDefault().post(new ClubBindSportsPageEvent());
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(R.id.iv_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
    }

}
