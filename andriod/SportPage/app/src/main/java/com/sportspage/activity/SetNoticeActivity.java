package com.sportspage.activity;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.utils.Utils;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_notice_set)
public class SetNoticeActivity extends SwipeBackActivity {

    @ViewInject(R.id.iv_back)
    private ImageView mBackView;

    @ViewInject(R.id.txt_title)
    private TextView mTitle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mBackView.setVisibility(View.VISIBLE);
        mTitle.setText(R.string.msg_notfication);
    }

    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }
}
