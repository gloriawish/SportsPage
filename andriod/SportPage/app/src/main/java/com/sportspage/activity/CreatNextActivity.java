package com.sportspage.activity;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v7.app.AlertDialog;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.fourmob.datetimepicker.date.DatePickerDialog;
import com.google.gson.Gson;
import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.entity.LastEventResult;
import com.sportspage.utils.DateUtils;
import com.sportspage.utils.LogicUtils;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.io.IOException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import ch.ielse.view.SwitchView;
import cn.carbswang.android.numberpickerview.library.NumberPickerView;

@ContentView(R.layout.activity_creat_next)
public class CreatNextActivity extends FragmentActivity implements View.OnClickListener,
        DatePickerDialog.OnDateSetListener, NumberPickerView.OnValueChangeListener,
        RadioGroup.OnCheckedChangeListener {

    private PopupWindow mPopupWindow;

    private View mRootView;

    @ViewInject(R.id.iv_step2_addImage)
    private ImageView mTitleImg;

    @ViewInject(R.id.iv_step2_level)
    private ImageView mLevelImg;
    @ViewInject(R.id.iv_step2_date)
    private ImageView mDateImg;
    @ViewInject(R.id.iv_step2_time)
    private ImageView mTimeImg;
    @ViewInject(R.id.iv_step2_person)
    private ImageView mPersonImg;
    @ViewInject(R.id.iv_step2_charge)
    private ImageView mChargeImg;
    @ViewInject(R.id.iv_step2_way)
    private ImageView mWayImg;
    @ViewInject(R.id.iv_step2_private)
    private ImageView mPrivateImg;

    @ViewInject(R.id.tv_step2_name)
    private TextView mSportsName;

    @ViewInject(R.id.tv_step2_location)
    private TextView mSLocation;

    @ViewInject(R.id.rg_create_level)
    private RadioGroup mSLevel;

    @ViewInject(R.id.tv_step2_date)
    private TextView mSDate;

    @ViewInject(R.id.tv_step2_time)
    private TextView mSTime;

    @ViewInject(R.id.tv_step2_person)
    private TextView mSPerson;

    @ViewInject(R.id.et_step2_money)
    private EditText mSMoney;

    @ViewInject(R.id.rg_step2_pay)
    private RadioGroup mSPay;

    @ViewInject(R.id.sv_step2_private)
    private SwitchView mSIsOpen;

    private DatePickerDialog mDatePickerDialog;

    private AlertDialog mPersonDialog;

    private AlertDialog mTimeDialog;

    private int min = 4, max = 8;
    private NumberPickerView mMinPicker;
    private NumberPickerView mMaxPicker;
    private NumberPickerView mHourPicker;
    private NumberPickerView mMinutePicker;
    private NumberPickerView mDuringPicker;

    private String mSportType;


    /**
     * popupWindow 确认信息控件
     */
    private TextView mName, mType, mLocation, mTime, mDate,
            mLevel, mPerson, mPay, mMoney, mIsOpen, mDescribe;

    private CharSequence mLevelStr;
    private String mLevelNum;
    private CharSequence mPayStr;
    private String mPayNum;
    private String mIsOpenStr;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    /**
     * 初始化
     */
    private void init() {
        Intent intent = getIntent();
        String path = getIntent().getStringExtra("path");
        Glide.with(this).load(path).into(mTitleImg);
        String sportName = intent.getStringExtra("sportName");
        String address = intent.getStringExtra("address");
        mSportType = intent.getStringExtra("sportType");
        mSLevel.setOnCheckedChangeListener(this);
        mSPay.setOnCheckedChangeListener(this);
        mSMoney.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() > 0) {
                    mChargeImg.setImageResource(R.drawable.sports_create_step2_charge_blue);
                } else {
                    mChargeImg.setImageResource(R.drawable.sports_create_step2_charge);
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        mSIsOpen.setOnClickListener(this);
        mSportsName.setText(sportName);
        mSLocation.setText(address);
        Button completeBtn = (Button) findViewById(R.id.btn_step2_complete);
        completeBtn.setOnClickListener(this);
        mSDate.setOnClickListener(this);
        Calendar calendar = Calendar.getInstance();
        mDatePickerDialog = DatePickerDialog.newInstance(this,
                calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH),
                calendar.get(Calendar.DAY_OF_MONTH), false);
        mSTime.setOnClickListener(this);
        mSPerson.setOnClickListener(this);
        initTime();
        initPersonNum();
        getlastEventData();
    }

    private void getlastEventData() {
        String userId = Utils.getValue(this, "userId");
        String sportId = getIntent().getStringExtra("sportId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("sportId", sportId);
        Xutils.getInstance(this).get(API.GET_LAST_EVENT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                if ("false".equals(result)) {
                    return;
                } else {
                    LastEventResult lastResult = Utils.parseJsonWithGson(result, LastEventResult.class);
                    if (lastResult.getLevel().equals("1")) {
                        mSLevel.check(R.id.rb_level_simple);
                    } else if (lastResult.getLevel().equals("2")) {
                        mSLevel.check(R.id.rb_level_normal);
                    } else {
                        mSLevel.check(R.id.rb_level_hard);
                    }
                    mSTime.setText(DateUtils.getFormatTime(lastResult.getStart_time(), "hh:mm")
                            + "  时长" + lastResult.getDuration() + "小时");

                    mSPerson.setText(Utils.StringToInt(lastResult.getMin_number())
                            + "人 ~ " + Utils.StringToInt(lastResult.getMax_number()) + "人");

                    mSMoney.setText(Utils.StringToInt(lastResult.getPrice())+"");
                    if (lastResult.getCharge_type().equals("1")) {
                        mSPay.check(R.id.rb_pay_online);
                    } else {
                        mSPay.check(R.id.rb_pay_offline);
                    }
                    if (lastResult.getPrivacy().equals("1")) {
                        mSIsOpen.setOpened(true);
                    } else {
                        mSIsOpen.setOpened(false);
                    }
                    setIconBlue();
                }
            }

            @Override
            public void onFinished() {

            }
        });
    }

    private void setIconBlue() {
        mLevelImg.setImageResource(R.drawable.sports_create_step2_lv_blue);
        mDateImg.setImageResource(R.drawable.sports_create_step2_date_blue);
        mTimeImg.setImageResource(R.drawable.sports_create_step2_time_blue);
        mPersonImg.setImageResource(R.drawable.sports_create_step2_person_blue);
        mChargeImg.setImageResource(R.drawable.sports_create_step2_charge_blue);
        mWayImg.setImageResource(R.drawable.sports_create_step2_charge_blue);
    }

    /**
     * 时间选择
     */
    private void initTime() {
        View view = View.inflate(this, R.layout.dialog_time_select, null);
        mHourPicker = (NumberPickerView) view.findViewById(R.id.np_select_hour);
        mMinutePicker = (NumberPickerView) view.findViewById(R.id.np_select_minute);
        mDuringPicker = (NumberPickerView) view.findViewById(R.id.np_select_during);
        String[] hours = new String[24];
        final String[] minutes = new String[4];
        String[] durings = new String[20];
        for (int i = 0; i < hours.length; i++) {
            hours[i] = i + "时";
            if (i < 20) {
                durings[i] = ((i + 1) * 0.5) + "小时";
            }
            if (i < 4) {
                minutes[i] = i * 15 + "分";
            }
        }
        mHourPicker.refreshByNewDisplayedValues(hours);
        mMinutePicker.refreshByNewDisplayedValues(minutes);
        mDuringPicker.refreshByNewDisplayedValues(durings);
        mHourPicker.setValue(8);
        mMinutePicker.setValue(2);
        mDuringPicker.setValue(3);
        mTimeDialog = new AlertDialog.Builder(this)
                .setView(view)
                .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        mSTime.setText(mHourPicker.getValue() + ":" + (mMinutePicker.getValue() * 15) + "  时长" +
                                mDuringPicker.getContentByCurrValue());
                        mTimeImg.setImageResource(R.drawable.sports_create_step2_time_blue);
                    }
                }).create();
        mTimeDialog.setCanceledOnTouchOutside(false);
    }

    /**
     * 人数选择
     */
    private void initPersonNum() {
        View view = View.inflate(this, R.layout.dialog_number_select, null);
        mMinPicker = (NumberPickerView) view.findViewById(R.id.np_select_min);
        mMaxPicker = (NumberPickerView) view.findViewById(R.id.np_select_max);
        mMinPicker.setOnValueChangedListener(this);
        mMaxPicker.setOnValueChangedListener(this);
        String[] minStrings = new String[199];
        String[] maxStrings = new String[199];
        for (int i = 0; i < minStrings.length; i++) {
            minStrings[i] = (i + 1) + "人";
            maxStrings[i] = (i + 2) + "人";
        }
        mMinPicker.refreshByNewDisplayedValues(minStrings);
        mMaxPicker.refreshByNewDisplayedValues(maxStrings);
        mMinPicker.setValue(4);
        mMaxPicker.setValue(8);
        mPersonDialog = new AlertDialog.Builder(this)
                .setView(view)
                .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        mSPerson.setText(mMinPicker.getContentByCurrValue()
                                + " ~ "
                                + mMaxPicker.getContentByCurrValue());
                        mPersonImg.setImageResource(R.drawable.sports_create_step2_person_blue);
                    }
                }).create();
        mPersonDialog.setCanceledOnTouchOutside(false);
    }

    /**
     * 完成
     */
    private void complete() {
        View popupView = getLayoutInflater().inflate(R.layout.popupwindow_create, null);
        mRootView = findViewById(R.id.btn_step2_complete).getRootView();
        Button mComfirmBtn = (Button) popupView.findViewById(R.id.btn_step3_comfirm);
        mComfirmBtn.setOnClickListener(this);
        ImageView closeView = (ImageView) popupView.findViewById(R.id.iv_create_close);
        closeView.setOnClickListener(this);
        setPopupWindow(popupView);
        mPopupWindow = new PopupWindow(popupView, WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT, true);
        mPopupWindow.showAtLocation(mRootView, 0, 0, mRootView.getHeight());
    }

    private void setPopupWindow(View popupView) {
        mName = (TextView) popupView.findViewById(R.id.tv_step3_name);
        mType = (TextView) popupView.findViewById(R.id.tv_step3_type);
        mLocation = (TextView) popupView.findViewById(R.id.tv_step3_location);
        mTime = (TextView) popupView.findViewById(R.id.tv_step3_time);
        mDate = (TextView) popupView.findViewById(R.id.tv_step3_date);
        mLevel = (TextView) popupView.findViewById(R.id.tv_step3_level);
        mPerson = (TextView) popupView.findViewById(R.id.tv_step3_person);
        mPay = (TextView) popupView.findViewById(R.id.tv_step3_pay);
        mMoney = (TextView) popupView.findViewById(R.id.tv_step3_money);
        mIsOpen = (TextView) popupView.findViewById(R.id.tv_step3_isOpen);
        mDescribe = (TextView) popupView.findViewById(R.id.tv_step3_describe);
        mName.setText(mSportsName.getText());
        mType.setText(mSportType);
        mLocation.setText(mSLocation.getText());
        mTime.setText(mSTime.getText());
        mDate.setText(mSDate.getText());
        mLevel.setText(mLevelStr);
        mPerson.setText(mSPerson.getText());
        mPay.setText(mPayStr);
        if (mSMoney.getText().toString().equals("0")) {
            mMoney.setText("免费");
        } else {
            mMoney.setText(mSMoney.getText());
        }
        if (mSIsOpen.isOpened()) {
            mIsOpen.setText("是");
            mIsOpenStr = "1";
        } else {
            mIsOpen.setText("否");
            mIsOpenStr = "0";
        }
        mDescribe.setText(getIntent().getStringExtra("describe"));
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_step3_comfirm:
                activeSport();
                break;
            case R.id.iv_create_close:
                mPopupWindow.dismiss();
                break;
            case R.id.btn_step2_complete:
                complete();
                break;
            case R.id.tv_step2_date:
                if (!mDatePickerDialog.isVisible()) {
                    mDatePickerDialog.setYearRange(1990, 2036);
                    mDatePickerDialog.show(getSupportFragmentManager(), "datepicker");
                }
                break;
            case R.id.tv_step2_time:
                mTimeDialog.show();
                break;
            case R.id.tv_step2_person:
                mPersonDialog.show();
                break;
            case R.id.sv_step2_private:
                mPrivateImg.setImageResource(R.drawable.sports_create_step2_privacy_blue);
                break;
        }
    }

    private void activeSport() {
        String userId = Utils.getValue(this, "userId");
        String sportId = getIntent().getStringExtra("sportId");
        Map<String, String> map = new HashMap<>();
        map.put("date", mDate.getText().toString());
        map.put("time", mTime.getText().toString());
        map.put("memberBorder", (min + 1) + "人 ~ " + (max + 2) + "人");
        map.put("price", mSMoney.getText().toString());
        map.put("level", mLevelNum);
        map.put("chargeType", mPayNum);
        map.put("privacy", mIsOpenStr);
        //// TODO: 2017/1/12  team_type个人1，团队2
        String json = new Gson().toJson(map, Map.class);
        Map<String, String> jsonMap = new HashMap<>();
        jsonMap.put("userId", userId);
        jsonMap.put("sportId", sportId);
        jsonMap.put("json", json);
            Xutils.getInstance(this).post(API.ACTIVATE_SPORT, jsonMap, new Xutils.XCallBack() {
                @Override
                public void onResponse(String result) {
                    Utils.showShortToast(CreatNextActivity.this, "创建并激活成功");
                    mPopupWindow.dismiss();
                    Intent intent = new Intent();
                    intent.putExtra("eventId",result);
                    intent.setClass(CreatNextActivity.this,ActivateSucessActivity.class);
                    Utils.start_Activity(CreatNextActivity.this, intent);
                    finish();
                }

                @Override
                public void onFinished() {

                }
            });
    }

    @Override
    public void onDateSet(DatePickerDialog datePickerDialog, int year, int month, int day) {
        mSDate.setText(year + "-" + (month + 1) + "-" + day);
        mDateImg.setImageResource(R.drawable.sports_create_step2_date_blue);
    }

    @Override
    public void onValueChange(NumberPickerView picker, int oldVal, int newVal) {
        switch (picker.getId()) {
            case R.id.np_select_min:
                min = newVal;
                if (max < min) {
                    mMaxPicker.smoothScrollToValue(max, min, true);
                }
                break;
            case R.id.np_select_max:
                max = newVal;
                if (max < min) {
                    mMinPicker.smoothScrollToValue(min, max, true);
                }
                break;
        }
    }

    @Override
    public void onCheckedChanged(RadioGroup group, int checkedId) {
        switch (group.getId()) {
            case R.id.rg_create_level:
                mLevelImg.setImageResource(R.drawable.sports_create_step2_lv_blue);
                RadioButton levelButton = (RadioButton) group.findViewById(checkedId);
                mLevelStr = levelButton.getText();
                if (mLevelStr.equals("")) {
                    mLevelStr = "未填写";
                    mLevelNum = "";
                } else if (mLevelStr.equals("简单")) {
                    mLevelNum = "1";
                } else if (mLevelStr.equals("一般")) {
                    mLevelNum = "2";
                } else {
                    mLevelNum = "3";
                }
                break;
            case R.id.rg_step2_pay:
                mWayImg.setImageResource(R.drawable.sports_create_step2_charge_blue);
                RadioButton payButton = (RadioButton) group.findViewById(checkedId);
                mPayStr = payButton.getText();
                if (mPayStr.equals("线上")) {
                    mPayNum = "1";
                } else if (mPayStr.equals("线下")) {
                    mPayNum = "2";
                } else {
                    mPayNum = "";
                }
                if (mSMoney.getText().toString().equals("0")) {
                    mPayNum = "2";
                }
                break;
        }
    }


    @Event(R.id.iv_create_step2_back)
    private void back(View v) {
        finish();
    }

    @Override
    public void finish() {
        super.finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Event(R.id.tv_create_step2_skip)
    private void skip(View v){
        Utils.start_Activity(this,MainActivity.class);
    }

}
