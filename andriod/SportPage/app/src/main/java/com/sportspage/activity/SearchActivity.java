package com.sportspage.activity;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.inputmethod.EditorInfo;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.adapter.FriendAdapter;
import com.sportspage.common.API;
import com.sportspage.common.BaseActivity;
import com.sportspage.common.RecyclerClickListener;
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

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_search)
public class SearchActivity extends SwipeBackActivity implements RecyclerClickListener {

    @ViewInject(R.id.iv_back)
    private ImageView mBackView;

    @ViewInject(R.id.txt_title)
    private TextView mTitle;

    @ViewInject(R.id.et_user_search)
    private EditText mSearch;

    @ViewInject(R.id.rlv_user_list)
    private RecyclerView mRecyclerView;

    private List<FriendsResult.User> mDatas;

    private FriendAdapter mAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("添加好友");
        mBackView.setVisibility(View.VISIBLE);
        mDatas = new ArrayList<>();
        mAdapter = new FriendAdapter(this,mDatas);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(this));
        mRecyclerView.setAdapter(mAdapter);
        mAdapter.setmListener(this);
        mSearch.setOnEditorActionListener(new TextView.OnEditorActionListener() {
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

    @Event(R.id.btn_user_search)
    private void getUserData(View v){
        searchAction();
    }

    private void searchAction() {
        if (mSearch.getText().toString().equals("")) {
            Utils.showShortToast(this,"请输入正确的关键字");
            return;
        }
        String userId = Utils.getValue(this,"userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("searchKey", mSearch.getText().toString());
        Xutils.getInstance(this).get(API.SEARCH_FRIEND, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                FriendsResult friendsResult = Utils.parseJsonWithGson(result,FriendsResult.class);
                mDatas.clear();
                mDatas.addAll(friendsResult.getData());
                mAdapter.notifyDataSetChanged();
                Utils.hideKeyBoard();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(R.id.iv_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in,R.anim.push_right_out);
    }

    @Override
    public void onRecycleItemClick(int position) {
        Intent intent = new Intent();
        intent.putExtra("userId",mDatas.get(position).getId());
        intent.putExtra("nick",mDatas.get(position).getNick());
        intent.putExtra("phone",mDatas.get(position).getMobile());
        intent.putExtra("city",mDatas.get(position).getCity());
        intent.putExtra("portrait",mDatas.get(position).getPortrait());
        intent.setClass(this,FriendDeatilActivity.class);
        Utils.start_Activity(this,intent);
        finish();
    }
}
