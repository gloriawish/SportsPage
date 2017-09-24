package com.sportspage.activity;

import android.content.Context;
import android.graphics.PixelFormat;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.adapter.CreateGroupAdapter;
import com.sportspage.common.API;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;
import com.sportspage.view.SideBar;

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

@ContentView(R.layout.activity_create_group)
public class CreateGroupActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.tv_title_right)
    private TextView mCancel;
    @ViewInject(R.id.lv_create_group_list)
    private ListView mContactList;
    @ViewInject(R.id.sideBar)
    private SideBar indexBar;
    @ViewInject(R.id.et_group_name)
    private EditText mName;
    @ViewInject(R.id.et_group_intro)
    private EditText mIntro;
    private TextView mDialogText;
    private CreateGroupAdapter mAdapter;
    private WindowManager mWindowManager;
    private List<UserInfoResult.ResultBean> mDatas;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mWindowManager = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
        mDatas = new ArrayList<>();
        mAdapter = new CreateGroupAdapter(this, mDatas);
        mTitle.setText(R.string.create_group);
        mCancel.setText(R.string.cancel);
        mDialogText = (TextView) LayoutInflater.from(this).inflate(
                R.layout.list_position, null);
        mDialogText.setVisibility(View.INVISIBLE);
        indexBar.setTextView(mDialogText);
        indexBar.setListView(mContactList);
        mContactList.setAdapter(mAdapter);
        WindowManager.LayoutParams lp = new WindowManager.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION,
                WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
                        | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT);
        mWindowManager.addView(mDialogText, lp);
        getFriendData();
    }

    public void getFriendData() {
        String userId = Utils.getValue(x.app(), "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        Xutils.getInstance(this).get(API.GET_FRIENDS, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                try {
                    JSONObject resultObject = new JSONObject(result);
                    JSONObject data = resultObject.getJSONObject("data");
                    JSONArray value = data.getJSONArray("value");
                    mDatas.clear();
                    for (int i = 0; i < value.length(); i++) {
                        JSONArray array = value.getJSONArray(i);
                        for (int j = 0; j < array.length(); j++) {
                            JSONObject object = (JSONObject) array.get(j);
                            UserInfoResult.ResultBean bean = Utils.parseJsonWithGson(
                                    object.toString(), UserInfoResult.ResultBean.class);
                            mDatas.add(bean);
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                mAdapter.notifyDataSetChanged();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(R.id.btn_create_group)
    private void createGroup(View v){
        if (mName.getText().toString().equals("")) {
            Utils.showShortToast(this,"请输入群组名称");
            return;
        }
        if (mIntro.getText().toString().equals("")) {
            Utils.showShortToast(this,"请输入群简介");
            return;
        }
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("groupName",mName.getText().toString());
        map.put("intro",mIntro.getText().toString());
        map.put("memberIds",mAdapter.getCheckUserIds());
        Xutils.getInstance(this).post(API.CREATE_GROUP, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(CreateGroupActivity.this,"创建成功");
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(R.id.tv_title_right)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }
}
