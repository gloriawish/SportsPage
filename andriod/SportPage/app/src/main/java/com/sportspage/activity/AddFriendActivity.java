package com.sportspage.activity;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
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


@ContentView(R.layout.activity_add_friend)
public class AddFriendActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.et_addfriend_friendid)
    private EditText mFirendId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText(R.string.add_friend);
        mBackView.setVisibility(View.VISIBLE);
        //// TODO: 2016/12/11 使用父控件的点击时间来完成跳转，将点击事件在父控件消费
        mFirendId.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if (hasFocus){
                    Utils.start_Activity(AddFriendActivity.this,SearchActivity.class);
                }
            }
        });
    }

    @Event(value = R.id.btn_addfriend_add)
    private void addFriend(View v){
        String friendId = mFirendId.getText().toString();
        if (friendId.isEmpty()) {
            return;
        }
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("friendId", friendId);
        RequestParams params = new RequestParams(API.ADD_FRIEND);
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
                        Utils.showShortToast(AddFriendActivity.this, getString(R.string.wait_confirm));
                        finish();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Logger.d(ex.getMessage());
                    Utils.showShortToast(AddFriendActivity.this, getString(R.string.network_error));
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Logger.d(cex.getMessage());
                    Utils.showShortToast(AddFriendActivity.this, getString(R.string.network_error));
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
