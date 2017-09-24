package com.sportspage.activity;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.LayerDrawable;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;
import com.whinc.widget.ratingbar.RatingBar;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.HashMap;
import java.util.Map;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

/**
 * Created by sportspage on 2017/1/10.
 */
@ContentView(R.layout.activity_appraise)
public class AppraiseActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.tv_title_right)
    private TextView mRightText;

    @ViewInject(R.id.iv_appraise_img)
    private ImageView mImg;
    @ViewInject(R.id.tv_appraise_name)
    private TextView mName;
    @ViewInject(R.id.tv_appraise_location)
    private TextView mLocation;
    @ViewInject(R.id.tv_appraise_time)
    private TextView mTime;
    @ViewInject(R.id.tv_appraise_creator)
    private TextView mCreator;
    @ViewInject(R.id.rating_bar)
    private RatingBar mStar;
    @ViewInject(R.id.et_appraise_content)
    private EditText mContent;

    private int mGrade = 3;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("运动评价");
        mBackView.setVisibility(View.VISIBLE);
        mRightText.setText("发布");
        mRightText.setVisibility(View.VISIBLE);
        Intent intent = getIntent();
        Bitmap bitmap = Utils.getBitmapFromByte(getIntent().getByteArrayExtra("imageData"));
        mImg.setImageBitmap(bitmap);
        String sportName = intent.getStringExtra("sportName");
        mName.setText(sportName);
        String address = intent.getStringExtra("address");
        mLocation.setText(address);
        String time = intent.getStringExtra("time");
        mTime.setText(time);
        String creator = intent.getStringExtra("creator");
        mCreator.setText(creator);
        mStar.setOnRatingChangeListener(new RatingBar.OnRatingChangeListener() {
            @Override
            public void onChange(RatingBar ratingBar, int preCount, int curCount) {
                mGrade = curCount;
            }
        });
    }

    @Event(R.id.tv_title_right)
    private void postAppraise(View v){
        String userId = Utils.getValue(this,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        map.put("eventId",getIntent().getStringExtra("eventId"));
        map.put("grade",mGrade+"");
        map.put("content",mContent.getText().toString());
        Xutils.getInstance(this).post(API.POST_APPRAISE, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(),"评价成功");
                setResult(RESULT_OK);
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }
}
