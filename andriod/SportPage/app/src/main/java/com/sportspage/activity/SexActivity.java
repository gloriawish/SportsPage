package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
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

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_sex)
public class SexActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.tv_sex_man)
    private TextView mMan;
    @ViewInject(R.id.tv_sex_woman)
    private TextView mWoman;

    private String mSex;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("更改性别");
        mBackView.setVisibility(View.VISIBLE);
    }

    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Event(value = {R.id.tv_sex_man,R.id.tv_sex_woman})
    private void comfirm(View v) {
        String userId = Utils.getValue(this,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        if (v.getId() == R.id.tv_sex_man){
            mSex = mMan.getText().toString();
        } else {
            mSex = mWoman.getText().toString();
        }
        map.put("sex",mSex);
        Xutils.getInstance(this).post(API.UPDATE_SEX, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(),"修改成功");
                Intent intent = new Intent();
                intent.putExtra("sex",mSex);
                setResult(RESULT_OK,intent);
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }
}
