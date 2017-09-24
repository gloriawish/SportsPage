package com.sportspage.activity;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.event.CloseConversationEvent;
import com.sportspage.utils.Utils;

import org.greenrobot.eventbus.EventBus;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import me.yokeyword.swipebackfragment.SwipeBackActivity;


/**
 * Created by tiankui on 11/11/16.
 */

@ContentView(R.layout.activity_conversation)
public class ConversationActivity extends SwipeBackActivity{

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        Window window = getWindow();
        //取消设置透明状态栏,使 ContentView 内容不再覆盖状态栏
        window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        //需要设置这个 flag 才能调用 setStatusBarColor 来设置状态栏颜色
        window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        //设置状态栏颜色
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.setStatusBarColor(getResources().getColor(R.color.status_color));
        }
        mTitle.setText( getIntent().getData().getQueryParameter("title"));
        mBackView.setVisibility(View.VISIBLE);
    }

    @Override
    public void finish() {
        EventBus.getDefault().post(new CloseConversationEvent());
        Intent intent = new Intent();
        intent.setClass(this,MainActivity.class);
        Utils.start_Activity(this,intent);
        super.finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
    }
}
