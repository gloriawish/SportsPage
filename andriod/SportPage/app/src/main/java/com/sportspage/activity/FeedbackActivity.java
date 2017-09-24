package com.sportspage.activity;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.entity.SimpleResult;
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

@ContentView(R.layout.activity_feedback)
public class FeedbackActivity extends SwipeBackActivity {

    @ViewInject(R.id.iv_back)
    private ImageView mBackView;

    @ViewInject(R.id.txt_title)
    private TextView mTitle;

    @ViewInject(R.id.et_feedback_content)
    private TextView mContent;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mBackView.setVisibility(View.VISIBLE);
        mTitle.setText(R.string.advice_feedback);
    }


    @Event(R.id.btn_feedback)
    private void commit(View v){
        String userId = Utils.getValue(this,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        map.put("content",mContent.getText().toString());
        map.put("type",Constants.FEEDBACK_TYPE);
        RequestParams params = new RequestParams(API.ADD_FEEDBACK);
        try {
            params.addParameter("sign", Utils.getSignature(map, Constants.SECRET));
            params.addParameter("userId",userId);
            params.addParameter("content",mContent.getText().toString());
            params.addParameter("type",Constants.FEEDBACK_TYPE);
            x.http().post(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Logger.json(result);
                    SimpleResult simpleResult = Utils.parseJsonWithGson(result,SimpleResult.class);
                    if (simpleResult.getCode()== Constants.HTTP_OK_200){
                        Utils.showShortToast(FeedbackActivity.this,getString(R.string.feedback_sucess));
                        finish();
                    } else {
                        Utils.showShortToast(FeedbackActivity.this, simpleResult.getError());
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(FeedbackActivity.this, getString(R.string.network_error));
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(FeedbackActivity.this, getString(R.string.network_error));
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
