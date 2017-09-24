package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
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

@ContentView(R.layout.activity_mail)
public class MailActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.tv_title_right)
    private TextView mRightText;
    @ViewInject(R.id.et_mail)
    private EditText mMail;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("更改邮箱");
        mBackView.setVisibility(View.VISIBLE);
        mRightText.setVisibility(View.VISIBLE);
        mRightText.setText(R.string.comfirm);
        mMail.setText(getIntent().getStringExtra("mail"));
    }

    @Event(R.id.tv_title_right)
    private void comfirm(View v) {
        if (!Utils.isEmail(mMail.getText().toString())){
            Utils.showShortToast(this,"邮箱格式错误");
            return;
        }
        String userId = Utils.getValue(this,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        map.put("email",mMail.getText().toString());
        Xutils.getInstance(this).post(API.UPDATE_EMAIL, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(),"修改成功");
                Intent intent = new Intent();
                intent.putExtra("mail",mMail.getText().toString());
                setResult(RESULT_OK,intent);
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
