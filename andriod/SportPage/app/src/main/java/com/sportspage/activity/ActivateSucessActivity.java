package com.sportspage.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.BaseActivity;
import com.sportspage.utils.Utils;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_activate_sucess)
public class ActivateSucessActivity extends BaseActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.tv_title_right)
    private TextView mRight;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("成功");
        mRight.setVisibility(View.VISIBLE);
        mRight.setText("返回主页");
        mRight.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Utils.start_Activity(ActivateSucessActivity.this,MainActivity.class);
                finish();
            }
        });
    }

    @Event(R.id.btn_activate_detail)
    private void goDetail(View v){
        Intent intent = new Intent();
        intent.putExtra("eventId",getIntent().getStringExtra("eventId"));
        intent.setClass(this,SportsDetailActivity.class);
        Utils.start_Activity(this,intent);
        finish();
    }
}
