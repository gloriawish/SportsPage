package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.HashMap;
import java.util.Map;

@ContentView(R.layout.activity_new_club_notice)
public class NewClubNoticeActivity extends AppCompatActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;

    @ViewInject(R.id.tv_title_right)
    private TextView mRightView;

    @ViewInject(R.id.et_new_club_notice)
    private EditText mClubNotice;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("创建俱乐部");
        mRightView.setText("跳过");
    }

    @Event(R.id.btn_commit_request)
    private void pushNotice(View v) {
        if ("".equals(mClubNotice.getText().toString())) {
            Utils.showShortToast(this,"请输入公告内容");
            return;
        }
        Map<String, String> map = new HashMap<>();
        String userId = Utils.getValue(this, "userId");
        map.put("userId",userId);
        map.put("clubId", getIntent().getStringExtra("clubId"));
        map.put("content", mClubNotice.getText().toString());
        Xutils.getInstance(this).post(API.PUBLISH_ANNOUNCEMENT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Intent intent = new Intent();
                intent.putExtra("clubId",getIntent().getStringExtra("clubId"));
                intent.setClass(NewClubNoticeActivity.this,ClubActivity.class);
                Utils.start_Activity(NewClubNoticeActivity.this,intent);
                Utils.showShortToast(x.app(),"发布成功！");
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(R.id.tv_title_right)
    private void skip(View view) {
        Intent intent = new Intent();
        intent.putExtra("clubId",getIntent().getStringExtra("clubId"));
        intent.setClass(NewClubNoticeActivity.this,ClubActivity.class);
        Utils.start_Activity(NewClubNoticeActivity.this,intent);
        finish();
    }
}
