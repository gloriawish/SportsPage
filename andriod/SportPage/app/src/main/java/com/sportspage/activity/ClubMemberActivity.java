package com.sportspage.activity;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.cocosw.bottomsheet.BottomSheet;
import com.sportspage.R;
import com.sportspage.adapter.ClubAllMemberAdapter;
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


@ContentView(R.layout.fragment_contacts)
public class ClubMemberActivity extends SwipeBackActivity {
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.img_right)
    private ImageView mRightView;
    @ViewInject(R.id.lv_contact)
    private ListView mContactList;
    @ViewInject(R.id.sideBar)
    private SideBar indexBar;
    @ViewInject(R.id.ll_contacts_group)
    private LinearLayout mGroupLayout;
    private TextView mDialogText;
    private ClubAllMemberAdapter mAdapter;
    private WindowManager mWindowManager;
    private List<UserInfoResult.ResultBean> mAdmins;
    private List<UserInfoResult.ResultBean> mMembers;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        x.view().inject(this);
        initView();
        initData();
    }

    private void initView() {
        mTitle.setText("成员管理");
        mBackView.setVisibility(View.VISIBLE);
        mRightView.setVisibility(View.VISIBLE);
        mRightView.setImageResource(R.drawable.nav_more);
        mWindowManager = (WindowManager)getSystemService(Context.WINDOW_SERVICE);
        mAdmins = new ArrayList<>();
        mMembers = new ArrayList<>();
        mGroupLayout.setVisibility(View.GONE);
        mAdapter = new ClubAllMemberAdapter(this, mAdmins,mMembers);
        mDialogText = (TextView) LayoutInflater.from(this).inflate(
                R.layout.list_position, null);
        mDialogText.setVisibility(View.INVISIBLE);
        mContactList.setAdapter(mAdapter);
        indexBar.setTextView(mDialogText);
        indexBar.setListView(mContactList);
        WindowManager.LayoutParams lp = new WindowManager.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION,
                WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
                        | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT);
        mWindowManager.addView(mDialogText, lp);
        if(-1 == getIntent().getIntExtra("permission",-1)) {
            mRightView.setVisibility(View.GONE);
        }
    }

    private void initData() {
        Map<String, String> map = new HashMap<>();
        map.put("clubId", getIntent().getStringExtra("clubId"));
        Xutils.getInstance(this).get(API.GET_CLUB_ALL_MEMEBER, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                try {
                    JSONObject resultObject = new JSONObject(result);
                    JSONArray admin = resultObject.getJSONArray("admin");
                    JSONObject data = resultObject.getJSONObject("member");
                    JSONArray value = data.getJSONArray("value");
                    mAdmins.clear();
                    mMembers.clear();
                    for (int i=0;i<admin.length();i++){
                        JSONObject object = (JSONObject) admin.get(i);
                        UserInfoResult.ResultBean bean = Utils.parseJsonWithGson(
                                object.toString(), UserInfoResult.ResultBean.class);
                        mAdmins.add(bean);
                    }

                    for (int i = 0; i < value.length(); i++) {
                        JSONArray array = value.getJSONArray(i);
                        for (int j = 0; j < array.length(); j++) {
                            JSONObject object = (JSONObject) array.get(j);
                            UserInfoResult.ResultBean bean = Utils.parseJsonWithGson(
                                    object.toString(), UserInfoResult.ResultBean.class);
                            mMembers.add(bean);
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

    @Event(R.id.img_right)
    private void menu(View view) {
        BottomSheet bottomSheet = new BottomSheet.Builder(this).title("操作")
                .sheet(R.menu.club_member_set_list).listener(new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        switch (which) {
                            case R.id.add_admin:
                                addAdmin();
                                break;
                            case R.id.remove_admin:
                                removeAdmin();
                                break;
                            case R.id.add_member:
                                addMember();
                                break;
                            case R.id.remove_member:
                                removeMember();
                                break;
                        }
                    }
                }).build();
        int permission = getIntent().getIntExtra("permission",-1);
        if (permission == 2) {
            bottomSheet.getMenu().removeItem(R.id.add_admin);
            bottomSheet.getMenu().removeItem(R.id.remove_admin);
        }
        bottomSheet.show();
        bottomSheet.invalidate();
    }

    private void removeMember() {
        manager(Constants.OPRATION_REMOVE_MEMBER);
    }

    private void addMember() {
        manager(Constants.OPRATION_ADD_MEMBER);
    }

    private void removeAdmin() {
        manager(Constants.OPRATION_REMOVE_ADMIN);
    }

    private void addAdmin() {
        manager(Constants.OPRATION_ADD_ADMIN);
    }

    private void manager(int opration) {
        Intent intent = new Intent();
        intent.putExtra("opration", opration);
        intent.putExtra("clubId",getIntent().getStringExtra("clubId"));
        intent.setClass(this,ManagerClubMemberActivity.class);
        Utils.start_Activity(this,intent);
    }

    @Event(R.id.iv_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
    }
}
