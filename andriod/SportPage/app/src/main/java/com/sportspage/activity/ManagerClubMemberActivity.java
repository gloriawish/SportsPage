package com.sportspage.activity;

import android.content.Context;
import android.graphics.PixelFormat;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.adapter.CreateGroupAdapter;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
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
public class ManagerClubMemberActivity extends SwipeBackActivity {

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
    @ViewInject(R.id.btn_create_group)
    private Button mActionBtn;
    private TextView mDialogText;
    private CreateGroupAdapter mAdapter;
    private WindowManager mWindowManager;
    private List<UserInfoResult.ResultBean> mDatas;
    private String mClubId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mClubId = getIntent().getStringExtra("clubId");
        mName.setVisibility(View.GONE);
        mIntro.setVisibility(View.GONE);
        mWindowManager = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
        mDatas = new ArrayList<>();
        mAdapter = new CreateGroupAdapter(this, mDatas);
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
        setButtonAndTitle();
    }

    private void setButtonAndTitle() {
        switch (getIntent().getIntExtra("opration",1)){
            case Constants.OPRATION_ADD_MEMBER:
                mTitle.setText("邀请成员");
                getFriendData();
                break;
            case Constants.OPRATION_REMOVE_MEMBER:
                mTitle.setText("删除成员");
                getMemberData();
                break;
            case Constants.OPRATION_ADD_ADMIN:
                mTitle.setText("添加管理员");
                getMemberData();
                break;
            case Constants.OPRATION_REMOVE_ADMIN:
                mTitle.setText("删除管理员");
                getAdminData();
                break;
        }
        mActionBtn.setText("确定");
    }

    private void getAdminData() {
        Map<String, String> map = new HashMap<>();
        map.put("clubId", getIntent().getStringExtra("clubId"));
        Xutils.getInstance(this).get(API.GET_CLUB_ADMINS, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                try {
                    JSONObject resultObject = new JSONObject(result);
                    JSONArray data = resultObject.getJSONArray("data");
                    mDatas.clear();
                    for (int i = 0; i < data.length(); i++) {
                        JSONObject object = (JSONObject) data.get(i);
                        UserInfoResult.ResultBean bean = Utils.parseJsonWithGson(
                                object.toString(), UserInfoResult.ResultBean.class);
                        mDatas.add(bean);
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

    private void getMemberData() {
        String userId = Utils.getValue(this,"userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("clubId", getIntent().getStringExtra("clubId"));
        Xutils.getInstance(this).get(API.GET_NORMAL_MEMBERS, map, new Xutils.XCallBack() {
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

    public void getFriendData() {
        String userId = Utils.getValue(x.app(), "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("clubId", mClubId);
        Xutils.getInstance(this).get(API.GET_NOT_JOIN_CLUB_FRIENDS, map, new Xutils.XCallBack() {
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
    private void action(View v){
        switch (getIntent().getIntExtra("opration",1)){
            case Constants.OPRATION_ADD_MEMBER:
                addMembers();
                break;
            case Constants.OPRATION_REMOVE_MEMBER:
                removeMembers();
                break;
            case Constants.OPRATION_ADD_ADMIN:
                addAdmins();
                break;
            case Constants.OPRATION_REMOVE_ADMIN:
                removeAdmins();
                break;
        }
    }

    private void removeAdmins() {
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("clubId", mClubId);
        map.put("userId", userId);
        map.put("adminIds",mAdapter.getCheckUserIds());
        Xutils.getInstance(this).post(API.DELETE_CLUB_ADMIN_BATCH, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(ManagerClubMemberActivity.this,"操作成功");
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    private void addAdmins() {
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("clubId", mClubId);
        map.put("userId", userId);
        map.put("adminIds",mAdapter.getCheckUserIds());
        Xutils.getInstance(this).post(API.SET_CLUB_ADMIN_BATCH, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(ManagerClubMemberActivity.this,"操作成功");
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    private void removeMembers() {
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("clubId", mClubId);
        map.put("userId", userId);
        map.put("memberIds",mAdapter.getCheckUserIds());
        Xutils.getInstance(this).post(API.DELETE_CLUB_MEMBER_BATCH, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(ManagerClubMemberActivity.this,"操作成功");
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    private void addMembers() {
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("clubId", mClubId);
        map.put("userId", userId);
        map.put("targetIds",mAdapter.getCheckUserIds());
        map.put("extend","一起来俱乐部玩耍吧！");
        Xutils.getInstance(this).post(API.INVITE_JOIN_CLUB, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(ManagerClubMemberActivity.this,"等待对方同意");
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
