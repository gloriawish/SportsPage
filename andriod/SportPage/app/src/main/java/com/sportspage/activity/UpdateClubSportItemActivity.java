package com.sportspage.activity;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.event.UpdateClubNameEvent;
import com.sportspage.event.UpdateClubSportItemEvent;
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

@ContentView(R.layout.activity_update_club_sportitem)
public class UpdateClubSportItemActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.tv_title_right)
    private TextView mRightText;
    @ViewInject(R.id.et_update_club_sportitem)
    private EditText mSportType;

    private View mRootView;

    private String mItem;

    private PopupWindow mPopupWindow;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("更改运动类型");
        mBackView.setVisibility(View.VISIBLE);
        mRightText.setVisibility(View.VISIBLE);
        mRightText.setText("确定");
        mSportType.setText(getIntent().getStringExtra("type"));
        mSportType.setFocusableInTouchMode(false);
    }

    @Event(R.id.et_update_club_sportitem)
    private void selectSport(View v) {
        View popupView = getLayoutInflater().inflate(R.layout.popupwindow_sport_type, null);
        mRootView = findViewById(R.id.et_update_club_sportitem).getRootView();
        mPopupWindow = new PopupWindow(popupView, WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT, true);
        Button mComfirmBtn = (Button) popupView.findViewById(R.id.btn_sport_type);
        mComfirmBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPopupWindow.dismiss();
                mSportType.setOnClickListener(null);
                mSportType.setFocusableInTouchMode(true);
                mSportType.requestFocus();
                mItem = "20";
            }
        });
        setSport(popupView);
        mPopupWindow.showAtLocation(mRootView, 0, 0, mRootView.getHeight());
    }

    private void setSport(View rootView) {
        ImageView badminton = (ImageView) rootView.findViewById(R.id.iv_type_1);
        badminton.setOnClickListener(imgListener);
        ImageView football = (ImageView) rootView.findViewById(R.id.iv_type_2);
        football.setOnClickListener(imgListener);
        ImageView basketball = (ImageView) rootView.findViewById(R.id.iv_type_3);
        basketball.setOnClickListener(imgListener);
        ImageView teinnis = (ImageView) rootView.findViewById(R.id.iv_type_4);
        teinnis.setOnClickListener(imgListener);
        ImageView jogging = (ImageView) rootView.findViewById(R.id.iv_type_5);
        jogging.setOnClickListener(imgListener);
        ImageView swimming = (ImageView) rootView.findViewById(R.id.iv_type_6);
        swimming.setOnClickListener(imgListener);
        ImageView squash = (ImageView) rootView.findViewById(R.id.iv_type_7);
        squash.setOnClickListener(imgListener);
        ImageView kayak = (ImageView) rootView.findViewById(R.id.iv_type_8);
        kayak.setOnClickListener(imgListener);
        ImageView baseball = (ImageView) rootView.findViewById(R.id.iv_type_9);
        baseball.setOnClickListener(imgListener);
        ImageView pingpang = (ImageView) rootView.findViewById(R.id.iv_type_10);
        pingpang.setOnClickListener(imgListener);
    }

    private View.OnClickListener imgListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            switch (v.getId()) {
                case R.id.iv_type_1:
                    mSportType.setText("羽毛球");
                    mItem = "1";
                    break;
                case R.id.iv_type_2:
                    mSportType.setText("足球");
                    mItem = "2";
                    break;
                case R.id.iv_type_3:
                    mSportType.setText("篮球");
                    mItem = "3";
                    break;
                case R.id.iv_type_4:
                    mSportType.setText("网球");
                    mItem = "4";
                    break;
                case R.id.iv_type_5:
                    mSportType.setText("跑步");
                    mItem = "5";
                    break;
                case R.id.iv_type_6:
                    mSportType.setText("游泳");
                    mItem = "6";
                    break;
                case R.id.iv_type_7:
                    mSportType.setText("壁球");
                    mItem = "7";
                    break;
                case R.id.iv_type_8:
                    mSportType.setText("皮划艇");
                    mItem = "8";
                    break;
                case R.id.iv_type_9:
                    mSportType.setText("棒球");
                    mItem = "9";
                    break;
                case R.id.iv_type_10:
                    mSportType.setText("乒乓");
                    mItem = "10";
                    break;
            }
            mPopupWindow.dismiss();
        }
    };


    @Event(R.id.tv_title_right)
    private void comfirm(View v) {
        if (mSportType.getText().toString().equals(getIntent().getStringExtra("type"))){
            Utils.showShortToast(this,"没有任何改变");
            return;
        }
        String userId = Utils.getValue(this,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        map.put("clubId",getIntent().getStringExtra("clubId"));
        map.put("sportItem",mItem);
        if (mItem.equals("20")) {
            map.put("sportItemExtend",mSportType.getText().toString());
        }
        Xutils.getInstance(this).post(API.UPDATE_CLUB_SPORT_ITEM, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(),"修改成功");
                EventBus.getDefault().post(new UpdateClubSportItemEvent(mSportType.getText().toString()));
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
