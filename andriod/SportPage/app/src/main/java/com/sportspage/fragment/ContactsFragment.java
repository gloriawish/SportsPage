package com.sportspage.fragment;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.activity.GroupListActivity;
import com.sportspage.activity.UserDetailActivity;
import com.sportspage.adapter.ContactAdapter;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;
import com.sportspage.view.SideBar;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import me.yokeyword.fragmentation.SupportFragment;


//通讯录
@ContentView(R.layout.fragment_contacts)
public class ContactsFragment extends SupportFragment {
    private Activity mContent;
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.lv_contact)
    private ListView mContactList;
    @ViewInject(R.id.sideBar)
    private SideBar indexBar;
    private TextView mDialogText;
    private ContactAdapter mAdapter;
    private WindowManager mWindowManager;
    private List<UserInfoResult.ResultBean> mDatas;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = x.view().inject(this, inflater, container);
        mContent = this.getActivity();
        mWindowManager = (WindowManager) mContent
                .getSystemService(Context.WINDOW_SERVICE);
        mDatas = new ArrayList<>();
        initViews();
        initData();
        return view;
    }

    private void initViews() {
        mAdapter = new ContactAdapter(mContent, mDatas);
        mDialogText = (TextView) LayoutInflater.from(getActivity()).inflate(
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
        try{mWindowManager.addView(mDialogText, lp);}catch (Exception e){}

        mTitle.setText(R.string.constacts);
    }

    private void initData() {
        getFriendData();
    }

    private void refresh() {
        mDatas.clear();
        initData();
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }


    public void getFriendData() {
        String userId = Utils.getValue(mContent, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        Xutils.getInstance(mContent).get(API.GET_FRIENDS, map, new Xutils.XCallBack() {
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


    @Event(value = R.id.lv_contact, type = AdapterView.OnItemClickListener.class)
    private void itemClick(AdapterView<?> parent, View view, int position, long id) {
        Logger.d("parent: " + parent.getId() + "\n view: " + view.getId() + "\n position: " + position + "\n id" + id);
        Intent intent = new Intent();
        intent.putExtra("userId", mDatas.get(position).getId());
        intent.putExtra("nick", mDatas.get(position).getNick());
        intent.putExtra("email", mDatas.get(position).getEmail());
        intent.putExtra("city", mDatas.get(position).getCity());
        intent.putExtra("portrait", mDatas.get(position).getPortrait());
        intent.setClass(mContent, UserDetailActivity.class);
        Utils.start_Activity(mContent, intent);
    }

    @Event(R.id.ll_contacts_group)
    private void goGroupList(View v){
        Utils.start_Activity(mContent, GroupListActivity.class);
    }


}
