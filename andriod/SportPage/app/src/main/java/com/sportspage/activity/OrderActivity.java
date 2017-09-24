package com.sportspage.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.pingplusplus.android.Pingpp;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.event.UpdateMoneyEvent;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.greenrobot.eventbus.EventBus;
import org.json.JSONException;
import org.json.JSONObject;
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

@ContentView(R.layout.activity_order)
public class OrderActivity extends SwipeBackActivity {

    private static final int REQUEST_PAY_PASS = 1000;
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.tv_order_sportName)
    private TextView mSportName;
    @ViewInject(R.id.tv_order_date)
    private TextView mDate;
    @ViewInject(R.id.tv_order_time)
    private TextView mTime;
    @ViewInject(R.id.tv_order_address)
    private TextView mAddress;
    @ViewInject(R.id.tv_order_pay)
    private TextView mPay;
    @ViewInject(R.id.tv_order_money)
    private TextView mMoney;
    @ViewInject(R.id.tv_order_creater)
    private TextView mCreater;
    @ViewInject(R.id.tv_order_should_pay)
    private TextView mShouldPay;

    private View mRootView;

    private PopupWindow mPopupWindow;
    private int mBalance;
    private String mOrderNo;
    private boolean isWXPay = false;
    private int mAllMoney;
    private int mNeedPayPass;
    private AlertDialog mEditDialog;
    private EditText mPayPass;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("确认订单");
        mBackView.setVisibility(View.VISIBLE);
        mSportName.setText(getIntent().getStringExtra("sportName"));
        mDate.setText(getIntent().getStringExtra("date"));
        mTime.setText(getIntent().getStringExtra("time"));
        mAddress.setText(getIntent().getStringExtra("location"));
        mPay.setText(getIntent().getStringExtra("pay"));
        mMoney.setText(getIntent().getStringExtra("money") + "元/人");
        mCreater.setText(getIntent().getStringExtra("creater"));
        String money = getIntent().getStringExtra("money");
        if (money.equals("0.00")) {
            mShouldPay.setText(R.string.free);
        } else {
            if ("线上".equals(getIntent().getStringExtra("pay"))) {
                mShouldPay.setText("￥" + getIntent().getStringExtra("money"));
                mAllMoney = Utils.StringToInt(getIntent().getStringExtra("money"));
            } else {
                mShouldPay.setText("￥" + 0);
            }
        }
    }

    @Event(R.id.btn_order_pay)
    private void payWay(View v) {
        String eventId = getIntent().getStringExtra("eventId");
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("eventId", eventId);
        map.put("userId", userId);
        RequestParams params = new RequestParams(API.ENROLL_EVENT);
        try {
            params.addParameter("sign", Utils.getSignature(map, Constants.SECRET));
            params.addParameter("eventId", eventId);
            params.addParameter("userId", userId);
            x.http().post(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Logger.json(result);
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        if (jsonObject.getInt("code") == Constants.HTTP_OK_200) {
                            JSONObject resultObject = jsonObject.getJSONObject("result");
                            if ("线下".equals(getIntent().getStringExtra("pay"))) {
                                Utils.start_Activity(OrderActivity.this, EnrollSuccess.class);
                            } else {
                                mBalance = resultObject.getInt("balance");
                                mOrderNo = resultObject.getString("orderNo");
                                mNeedPayPass = resultObject.getInt("needPaypass");
                                setPopupWindow();
                            }
                        } else {
                            Utils.showShortToast(x.app(), jsonObject.getString("error"));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {

                }

                @Override
                public void onCancelled(CancelledException cex) {

                }

                @Override
                public void onFinished() {

                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void setPopupWindow() {
        View popupView = getLayoutInflater().inflate(R.layout.popupwindow_pay, null);
        mRootView = findViewById(R.id.btn_order_pay).getRootView();
        initWindowView(popupView);
        mPopupWindow = new PopupWindow(popupView, WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT, true);
        mPopupWindow.showAtLocation(mRootView, 0, 0, mRootView.getHeight());
    }

    private void initWindowView(View popupView) {
        TextView money = (TextView) popupView.findViewById(R.id.tv_pay_money);
        TextView balance = (TextView) popupView.findViewById(R.id.tv_pay_balance);
        final ImageView walletLogo = (ImageView) popupView.findViewById(R.id.iv_pay_wallet_logo);
        final ImageView walletImg = (ImageView) popupView.findViewById(R.id.iv_pay_wallet);
        final ImageView weixinLogo = (ImageView) popupView.findViewById(R.id.iv_pay_weixin_logo);
        final ImageView weixinImg = (ImageView) popupView.findViewById(R.id.iv_pay_weixin);
        money.setText(getIntent().getStringExtra("money"));
        if (mBalance > mAllMoney) {
            walletLogo.setImageResource(R.drawable.sports_chargetype_account_sel);
            walletImg.setImageResource(R.drawable.sports_chargetype_view_sel);
            balance.setText("账户余额 " + mBalance);
            isWXPay = false;
        } else {
            weixinLogo.setImageResource(R.drawable.sports_chargetype_wechat_sel);
            weixinImg.setImageResource(R.drawable.sports_chargetype_view_sel);
            balance.setText("账户余额不足");
            walletImg.setEnabled(false);
            isWXPay = true;
        }
        Button finishBtn = (Button) popupView.findViewById(R.id.btn_pay);
        walletImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                walletLogo.setImageResource(R.drawable.sports_chargetype_account_sel);
                walletImg.setImageResource(R.drawable.sports_chargetype_view_sel);
                weixinLogo.setImageResource(R.drawable.sports_chargetype_wechat_nor);
                weixinImg.setImageResource(R.drawable.sports_chargetype_view_nor);
                isWXPay = false;
            }
        });
        weixinImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                walletLogo.setImageResource(R.drawable.sports_chargetype_account_nor);
                walletImg.setImageResource(R.drawable.sports_chargetype_view_nor);
                weixinLogo.setImageResource(R.drawable.sports_chargetype_wechat_sel);
                weixinImg.setImageResource(R.drawable.sports_chargetype_view_sel);
                isWXPay = true;
            }
        });
        finishBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mNeedPayPass == 0) {
                    Intent intent = new Intent();
                    intent.setClass(OrderActivity.this,PayPasswordActivity.class);
                    Utils.startAcitivityForResult(OrderActivity.this, intent,REQUEST_PAY_PASS);
                } else{
                    if (isWXPay) {
                        wechatpay();
                    } else {
                        walletpay();
                    }
                }
            }
        });
    }

    private void wechatpay() {
        String userId = Utils.getValue(x.app(), "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("channel", Constants.PAY_CHANNEL_WX);
        map.put("orderNo", mOrderNo);
        RequestParams params = new RequestParams(API.GET_PAYMENT_CHARGE);
        try {
            params.addQueryStringParameter("sign", Utils.getSignature(map, Constants.SECRET));
            params.addQueryStringParameter("userId", userId);
            params.addQueryStringParameter("channel", Constants.PAY_CHANNEL_WX);
            params.addQueryStringParameter("orderNo", mOrderNo);
            x.http().get(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    try {
                        JSONObject object = new JSONObject(result);
                        if (object.getInt("code") == Constants.HTTP_OK_200) {
                            Pingpp.createPayment(OrderActivity.this, object.getString("charge"));
                        } else {
                            Utils.showShortToast(x.app(), object.getString("error"));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                }

                @Override
                public void onCancelled(CancelledException cex) {
                }

                @Override
                public void onFinished() {
                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void walletpay() {
        mEditDialog = new AlertDialog.Builder(OrderActivity.this)
                .setPositiveButton("是", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        String userId = Utils.getValue(x.app(), "userId");
                        Map<String, String> map = new HashMap<>();
                        map.put("userId", userId);
                        map.put("orderNo", mOrderNo);
                        map.put("paypass", mPayPass.getText().toString());
                        Xutils.getInstance(OrderActivity.this).post(API.ORDER_PAYMENT,
                                map, new Xutils.XCallBack() {
                                    @Override
                                    public void onResponse(String result) {
                                        Utils.start_Activity(OrderActivity.this, EnrollSuccess.class);
                                        EventBus.getDefault().post(new UpdateMoneyEvent());
                                        finish();
                                    }

                                    @Override
                                    public void onFinished() {

                                    }
                                });
                    }
                }).setNegativeButton("否", null).create();
        mPayPass = new EditText(OrderActivity.this);
        mPayPass.setHint("请输入支付密码");
        mPayPass.setInputType(InputType.TYPE_NUMBER_VARIATION_PASSWORD);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.setMargins(50, 0, 0, 50);
        mPayPass.setLayoutParams(lp);
        mEditDialog.setView(mPayPass);
    }

    /*
    * onActivityResult 获得支付结果，如果支付成功，服务器会收到ping++ 服务器发送的异步通知。
     * 最终支付成功根据异步通知为准
    */
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        //支付页面返回处理
        if (requestCode == Pingpp.REQUEST_CODE_PAYMENT) {
            if (resultCode == Activity.RESULT_OK) {
                String result = data.getExtras().getString("pay_result");
                /* 处理返回值
                 * "success" - payment succeed
                 * "fail"    - payment failed
                 * "cancel"  - user canceld
                 * "invalid" - payment plugin not installed
                 */

                String errorMsg = data.getExtras().getString("error_msg"); // 错误信息
                String extraMsg = data.getExtras().getString("extra_msg"); // 错误信息
                showMsg(result, errorMsg, extraMsg);
            }
        }

        if (requestCode == REQUEST_PAY_PASS){
            if (resultCode == RESULT_OK){
                mNeedPayPass =1;
                if (isWXPay) {
                    wechatpay();
                } else {
                    walletpay();
                }
            }
        }
    }

    public void showMsg(String title, String msg1, String msg2) {
        String str = title;
        if (null != msg1 && msg1.length() != 0) {
            str += "\n" + msg1;
        }
        if (null != msg2 && msg2.length() != 0) {
            str += "\n" + msg2;
        }
        if ("success".equals(title)) {
            finish();
            Utils.start_Activity(OrderActivity.this, EnrollSuccess.class);
        } else {
            Utils.showShortToast(x.app(),"支付失败");
        }
    }

    @Event(R.id.iv_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

}
