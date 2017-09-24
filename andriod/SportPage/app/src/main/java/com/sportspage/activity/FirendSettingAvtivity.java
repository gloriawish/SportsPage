package com.sportspage.activity;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.utils.Utils;

import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_firend_setting)
public class FirendSettingAvtivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        initView();
    }

    private void initView() {
        mBackView.setVisibility(View.VISIBLE);
        mTitle.setText(R.string.friend_setting);
    }

    @Event(value = R.id.iv_back)
    private void back(View v) {
        finish();
        this.overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Override
    public void finish() {
        super.finish();
        this.overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Event(value = R.id.btn_firendset_delete)
    private void deleteFriend(View v) {
        String userId = Utils.getValue(this, "userId");
        String friendId = getIntent().getStringExtra("friendId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("friendId", friendId);
        RequestParams params = new RequestParams(API.DELETE_FRIEND);
        try {
            params.addParameter("sign", Utils.getSignature(map, Constants.SECRET));
            params.addParameter("userId", userId);
            params.addParameter("friendId", friendId);
            x.http().post(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Logger.json(result);
                    int code = Utils.getCode(result);
                    if (code == Constants.HTTP_OK_200) {
                        Utils.showShortToast(FirendSettingAvtivity.this, getString(R.string.delete_success));
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(FirendSettingAvtivity.this, getString(R.string.network_error));
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(FirendSettingAvtivity.this, getString(R.string.network_error));
                }

                @Override
                public void onFinished() {

                }
            });
        } catch (IOException e) {
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
