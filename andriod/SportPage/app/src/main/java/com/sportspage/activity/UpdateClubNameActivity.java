package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.event.UpdateClubNameEvent;
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

@ContentView(R.layout.activity_nick)
public class UpdateClubNameActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.tv_title_right)
    private TextView mRightText;

    @ViewInject(R.id.et_nick)
    private EditText mNick;
    @ViewInject(R.id.tv_name_desc)
    private TextView mDesc;
    private boolean isEdit = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("更改俱乐部名称");
        mDesc.setText("");
        mBackView.setVisibility(View.VISIBLE);
        mRightText.setVisibility(View.VISIBLE);
        mRightText.setText("确定");
        mNick.setText(getIntent().getStringExtra("clubName"));
        mNick.setSelection(mNick.getText().length());
        mNick.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                isEdit = true;
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }

    @Event(R.id.tv_title_right)
    private void comfirm(View v) {
        if (!isEdit){
            Utils.showShortToast(this,"没有任何改变");
            return;
        }
        String userId = Utils.getValue(this,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        map.put("clubId",getIntent().getStringExtra("clubId"));
        map.put("name",mNick.getText().toString());
        Xutils.getInstance(this).post(API.UPDATE_CLUB_NAME, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(),"修改成功");
                EventBus.getDefault().post(new UpdateClubNameEvent(mNick.getText().toString()));
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
