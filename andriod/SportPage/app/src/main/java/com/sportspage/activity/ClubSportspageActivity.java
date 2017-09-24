package com.sportspage.activity;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.cocosw.bottomsheet.BottomSheet;
import com.sportspage.R;
import com.sportspage.adapter.SportPageRecordAdapter;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.ActiveResult;
import com.sportspage.event.ClubBindSportsPageEvent;
import com.sportspage.event.UpdateClubSportItemEvent;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
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

@ContentView(R.layout.activity_club_sportspage)
public class ClubSportspageActivity extends SwipeBackActivity implements RecyclerClickListener {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.img_right)
    private ImageView mRightView;
    @ViewInject(R.id.rv_club_sportspage)
    private RecyclerView mSportspageList;

    private List<ActiveResult> mDatas;
    private SportPageRecordAdapter mAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        x.view().inject(this);
        init();
        getData();
    }

    private void init() {
        EventBus.getDefault().register(this);
        mDatas = new ArrayList<>();
        mAdapter = new SportPageRecordAdapter(this,mDatas);
        mAdapter.setmListener(this);
        mTitle.setText("关联运动页");
        mBackView.setVisibility(View.VISIBLE);
        int permission = getIntent().getIntExtra("permission",0);
        if (permission != 0 || permission != 1) {
            mRightView.setVisibility(View.VISIBLE);
        }
        mRightView.setImageResource(R.drawable.nav_more);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mSportspageList.setLayoutManager(linearLayoutManager);
    }


    private void getData() {
        Map<String,String> map = new HashMap<>();
        map.put("userId", Utils.getValue(this,"userId"));
        map.put("clubId",getIntent().getStringExtra("clubId"));
        Xutils.getInstance(this).get(API.GET_CLUB_BIND_SPORTS, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                try {
                    mDatas.clear();
                    JSONObject resultObject = new JSONObject(result);
                    JSONArray array = resultObject.getJSONArray("data");
                    for (int i = 0; i <array.length() ; i++) {
                        mDatas.add(Utils.parseJsonWithGson(array.getString(i),ActiveResult.class));
                    }
                    mSportspageList.setAdapter(mAdapter);
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
    private void goBack(View view) {
        finish();
        overridePendingTransition(R.anim.push_right_in,R.anim.push_right_out);
    }

    @Event(R.id.img_right)
    private void more(View view) {
        BottomSheet bottomSheet = new BottomSheet.Builder(this).title("操作")
                .sheet(R.menu.club_sportspage_list).listener(new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        switch (which) {
                            case R.id.addSportsPgae:
                                addSportsPage();
                                break;
                            case R.id.cancel:
                                break;
                        }
                    }
                }).build();
        String userId = Utils.getValue(this, "userId");
        //// TODO: 3/29/17 创始人和管理员判断解散和推出
        bottomSheet.show();
        bottomSheet.invalidate();
    }

    private void addSportsPage() {
        Intent intent = new Intent();
        intent.putExtra("clubId",getIntent().getStringExtra("clubId"));
        intent.setClass(this,BindSportsPageActivity.class);
        Utils.start_Activity(this,intent);
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

    @Subscribe
    public void onEventMainThread(ClubBindSportsPageEvent event) {
        getData();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }

}
