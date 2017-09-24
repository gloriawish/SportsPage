package com.sportspage.activity;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.utils.NumAnim;
import com.sportspage.utils.Utils;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import me.yokeyword.swipebackfragment.SwipeBackActivity;


@ContentView(R.layout.activity_wallet)
public class WalletActivity extends SwipeBackActivity {
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.img_right)
    private ImageView mRightView;
    @ViewInject(R.id.tv_wallet_balance)
    private TextView mBalance;
    @ViewInject(R.id.tv_wallet_recharge)
    private TextView mRecharge;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        initTitle();
    }

    private void initTitle() {
        mTitle.setText(getString(R.string.my_wallet));
        mBackView.setVisibility(View.VISIBLE);
        mRightView.setVisibility(View.VISIBLE);
        mRightView.setImageResource(R.drawable.wallet_setting);
    }

    @Override
    protected void onResume() {
        super.onResume();
        float balance = Utils.getFloatValue(this,"balance");
        NumAnim.startAnim(mBalance, balance,800);
    }

    @Event(value = R.id.tv_wallet_recharge)
    private void goRecharge(View v){
        Utils.start_Activity(this,ReChargeActivity.class);
    }

    @Event(value = R.id.tv_wallet_withdraw)
    private void goWithdraw(View v){
        Utils.start_Activity(this,WithDrawActivity.class);
    }

    @Event(R.id.tv_wallet_cashbook)
    private void goCashBook(View v){
        Utils.start_Activity(this,CashbookActivity.class);
    }

    @Override
    public void finish() {
        super.finish();
        this.overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Event(R.id.img_right)
    private void setting(View v){
        Utils.start_Activity(this,WalletSetActivity.class);
    }

}
