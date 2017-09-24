package com.sportspage.activity;

import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.App;
import com.sportspage.R;
import com.sportspage.event.UpdateUserInfoEvent;
import com.sportspage.utils.Utils;

import org.greenrobot.eventbus.EventBus;
import org.xutils.ImageManager;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import io.rong.imkit.RongIM;
import me.yokeyword.swipebackfragment.SwipeBackActivity;



@ContentView(R.layout.activity_setting)
public class SettingActivity extends SwipeBackActivity {

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
        mTitle.setText(R.string.system_setting);
    }

    @Event(R.id.btn_setting_logout)
    private void clearUserInfo(View v){
        Utils.clearAllCache(this);
        Utils.removeValue(this,"token");
        RongIM.getInstance().disconnect();
        App.getInstance().finishActivity();
        Utils.start_Activity(this,LoginActivity.class);
        finish();
    }

    @Event(R.id.rl_setting_msg)
    private void goNotification(View v){
        Utils.start_Activity(this,SetNoticeActivity.class);
    }


    @Event(R.id.rl_setting_change)
    private void goChangePwd(View v){
        Utils.start_Activity(this,ChangePasswordActivity.class);
    }


    @Event(R.id.rl_setting_cache)
    private void cleanCache(View v){
        try {
            String cache = Utils.getTotalCacheSize(this);
            AlertDialog alertDialog = new AlertDialog.Builder(this)
                    .setTitle("清理缓存")
                    .setMessage("缓存大小为"+cache+"确认清理？")
                    .setPositiveButton("是", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            Utils.clearAllCache(x.app());
                            EventBus.getDefault().post(new UpdateUserInfoEvent());
                        }
                    }).setNegativeButton("否",null).show();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

}
