package com.sportspage.activity;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.Constants;
import com.sportspage.event.CreateClubEvent;
import com.sportspage.utils.BitmapUtils;
import com.sportspage.utils.PhotoUtil;
import com.sportspage.utils.Utils;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_create_club)
public class CreateClubActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;

    @ViewInject(R.id.iv_back)
    private ImageView mBackView;

    @ViewInject(R.id.iv_badge)
    private ImageView mBadgeImage;

    @ViewInject(R.id.et_club_name)
    private EditText mClubName;

    @ViewInject(R.id.et_club_sport_type)
    private EditText mSportType;

    @ViewInject(R.id.btn_create_club_next)
    private Button mNextBtn;

    private View mRootView;

    private String mItem = "";

    private PopupWindow mPopupWindow;

    private PhotoUtil mPhotoUtil;

    private String mPath = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        EventBus.getDefault().register(this);
        mTitle.setText("创建俱乐部");
        mBackView.setVisibility(View.VISIBLE);
        mSportType.setFocusableInTouchMode(false);
    }


    @Event(R.id.iv_badge)
    private void changeBadge(View v) {
        mPhotoUtil = new PhotoUtil(CreateClubActivity.this);
        mPhotoUtil.showDialog();
    }

    @Event(R.id.et_club_sport_type)
    private void selectSport(View v) {
        View popupView = getLayoutInflater().inflate(R.layout.popupwindow_sport_type, null);
        mRootView = findViewById(R.id.et_club_sport_type).getRootView();
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

    @Event(R.id.btn_create_club_next)
    private void goNext(View v) {
        if (mPath == null || mPath.trim().equals("")) {
            Utils.showShortToast(this, "请添加队徽");
            return;
        }
        if (mClubName.getText().toString().equals("")) {
            Utils.showShortToast(this, "请输入俱乐部名称");
            return;
        }
        if (mSportType.getText().toString().equals("")) {
            if ("20".equals(mItem)) {
                Utils.showShortToast(this, "请输入自定义运动看类型");
            } else {
                Utils.showShortToast(this, "请选择运动类型");
            }
            return;
        }
        Intent intent = new Intent();
        intent.putExtra("path", mPath);
        intent.putExtra("clubName", mClubName.getText().toString());
        intent.putExtra("sportType", mItem);
        if (mItem.equals("20")) {
            intent.putExtra("extends", mSportType.getText().toString());
        }
        intent.setClass(this, ClubCoverActivity.class);
        Utils.start_Activity(this, intent);
    }

    @Event(R.id.iv_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            if (PhotoUtil.CAMRA_SETRESULT_CODE == requestCode) {
                startClipActivity(mPhotoUtil.getCameraUri(data));
            } else if (PhotoUtil.PHOTO_SETRESULT_CODE == requestCode) {
                startClipActivity(mPhotoUtil.getPhotoUri());
            } else if (PhotoUtil.PHOTO_CORPRESULT_CODE == requestCode) {
                mPath = data.getStringExtra("path");
                BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
                Bitmap bitmap = bitmapUtils.decodeFile(mPath);
                mBadgeImage.setImageBitmap(bitmap);
            }
        }
    }

    public void startClipActivity(Uri uri) {
        Intent intent = new Intent(this, PhotoClipActivity.class);
        intent.putExtra("uri", uri);
        intent.putExtra("type", Constants.PHOTOCLIP_1_1);
        startActivityForResult(intent, PhotoUtil.PHOTO_CORPRESULT_CODE);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }

    @Subscribe
    public void onEventMainThread(CreateClubEvent event) {
        finish();
    }
}
