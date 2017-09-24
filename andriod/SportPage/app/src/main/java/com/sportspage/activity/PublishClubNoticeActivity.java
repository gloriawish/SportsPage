package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.event.CreateClubEvent;
import com.sportspage.event.PublishNoticeEvent;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.greenrobot.eventbus.EventBus;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.HashMap;
import java.util.Map;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_publish_club_notice)
public class PublishClubNoticeActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;

    @ViewInject(R.id.iv_back)
    private ImageView mBackView;

    @ViewInject(R.id.tv_title_right)
    private TextView mRightBtn;

    @ViewInject(R.id.et_publish_club_notice)
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
        mRightBtn.setText("发布");
        mRightBtn.setVisibility(View.VISIBLE);
        mBackView.setVisibility(View.VISIBLE);
    }

    @Event(R.id.btn_commit_request)
    private void pushNotice(View v) {
        if ("".equals(mClubNotice.getText().toString())) {
            Utils.showShortToast(this,"请输入公告");
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
                EventBus.getDefault().post(new PublishNoticeEvent(mClubNotice.getText().toString()));
                Utils.showShortToast(x.app(),"发布成功！");
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(R.id.iv_back)
    private void goBack (View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

}
