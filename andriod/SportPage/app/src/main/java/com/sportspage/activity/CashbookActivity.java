package com.sportspage.activity;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.adapter.CashbookAdapter;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.utils.DateUtils;
import com.sportspage.utils.Utils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import me.yokeyword.swipebackfragment.SwipeBackActivity;


@ContentView(R.layout.activity_cashbook)
public class CashbookActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.rv_cashbook_record)
    private RecyclerView mCashRecord;

    private List<Map<String,String>> mDatas;

    private CashbookAdapter mAdapter;

    private Handler mHandler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            mAdapter.notifyDataSetChanged();
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText(R.string.cash_detail);
        mBackView.setVisibility(View.VISIBLE);
        mDatas = new ArrayList<>();
        mCashRecord.setLayoutManager(new LinearLayoutManager(this));
        mAdapter = new CashbookAdapter(CashbookActivity.this,mDatas);
        mCashRecord.setAdapter(mAdapter);
        getDatas();
    }

    private void getDatas(){
        mDatas.clear();
        String userId = Utils.getValue(this,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        RequestParams params = new RequestParams(API.GET_DAY_BOOKS);
        try {
            params.addQueryStringParameter("sign",Utils.getSignature(map, Constants.SECRET));
            params.addQueryStringParameter("userId",userId);
            x.http().get(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Logger.json(result);
                    try {
                        JSONObject object = new JSONObject(result);
                        if(object.getInt("code") == Constants.HTTP_OK_200){
                            JSONObject resultObject = object.getJSONObject("result");
                            JSONArray array = resultObject.getJSONArray("data");
                            for (int i=0;i<array.length();i++){
                                analysisData(array.getJSONObject(i));
                            }
                            mHandler.sendEmptyMessage(0);
                        }else{
                            Utils.showShortToast(CashbookActivity.this, object.getString("error"));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(CashbookActivity.this, getString(R.string.network_error));
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(CashbookActivity.this, getString(R.string.network_error));
                }

                @Override
                public void onFinished() {

                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void analysisData(JSONObject jsonObjet) throws JSONException {
        Map<String,String> map = new HashMap<>();
        String type = jsonObjet.getString("type");
        String remark = jsonObjet.getString("remark");
        String balance = jsonObjet.getString("balance");
        String time = DateUtils.getFormatTime(jsonObjet.getString("time"),"yyyy-MM-dd");
        String amount = jsonObjet.getString("amount");
        switch (type){
            case "1":
                amount = "+"+amount;
                break;
            case "2":
                amount = "-"+amount;
                break;
        }

        map.put("remark",remark);
        map.put("balance",balance);
        map.put("time",time);
        map.put("amount",amount);
        mDatas.add(map);
    }

    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }
}
