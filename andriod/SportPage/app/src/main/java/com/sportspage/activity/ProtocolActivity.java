package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.davemorrissey.labs.subscaleview.ImageSource;
import com.davemorrissey.labs.subscaleview.SubsamplingScaleImageView;
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

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_protocol)
public class ProtocolActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.tv_title_right)
    private TextView mRightText;

    @ViewInject(R.id.iv_protocol)
    private SubsamplingScaleImageView mProtocolImg;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("运动页协议");
        mRightText.setVisibility(View.VISIBLE);
        mRightText.setText("返回");
        mProtocolImg.setImage(ImageSource.resource(R.drawable.protocol));
    }

    @Event(R.id.tv_title_right)
    private void goBack(View v) {
       finish();
    }


}
