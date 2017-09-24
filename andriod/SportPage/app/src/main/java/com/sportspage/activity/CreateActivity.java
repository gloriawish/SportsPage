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

import com.google.gson.Gson;
import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.utils.BitmapUtils;
import com.sportspage.utils.PhotoUtil;
import com.sportspage.utils.Utils;

import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_create)
public class CreateActivity extends SwipeBackActivity {

    @ViewInject(R.id.iv_create_addImage)
    private ImageView mAddImage;

    @ViewInject(R.id.btn_step1_next)
    private Button mNextBtn;

    @ViewInject(R.id.et_create_name)
    private EditText mSportName;

    @ViewInject(R.id.et_create_location)
    private EditText mLocation;

    @ViewInject(R.id.et_create_select)
    private EditText mSelect;

    @ViewInject(R.id.et_create_describe)
    private EditText mDescribe;

    private String mUserId;

    private String mPath;

    private String mAddress;

    private PhotoUtil mPhotoUtil;

    private View mRootView;

    private String mItem;

    private PopupWindow mPopupWindow;
    private double mLatitude;
    private double mLongitude;
    private String mSportId;

    private static final int REQUEST_CODE_PHONE = 7000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mLocation.setFocusable(false);
        mSelect.setFocusableInTouchMode(false);
    }

    @Event(R.id.iv_create_addImage)
    private void addImage(View v) {
        mPhotoUtil = new PhotoUtil(CreateActivity.this);
        mPhotoUtil.showDialog();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            if (Constants.MAP_RESULT_CODE == requestCode) {
                Bundle bundle = data.getBundleExtra("info");
                mLocation.setText(bundle.getString("name"));
                mAddress = bundle.getString("address");
                mLatitude = bundle.getDouble("latitude");
                mLongitude = bundle.getDouble("longitude");
            }
            if (PhotoUtil.CAMRA_SETRESULT_CODE == requestCode) {
               startClipActivity(mPhotoUtil.getCameraUri(data));
            } else if (PhotoUtil.PHOTO_SETRESULT_CODE == requestCode) {
               startClipActivity(mPhotoUtil.getPhotoUri());
            } else if (PhotoUtil.PHOTO_CORPRESULT_CODE == requestCode) {
                mPath = data.getStringExtra("path");
                BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
                Bitmap bitmap = bitmapUtils.decodeFile(mPath);
                mAddImage.setImageBitmap(bitmap);
            } else if (REQUEST_CODE_PHONE == requestCode) {
                boolean perfectResult = data.getBooleanExtra("perfectResult",false);
                if (perfectResult) {
                    onNext();
                }
            }
        }

    }

    @Event(R.id.et_create_location)
    private void goMap(View v) {
        Intent intent = new Intent(this, MapActivity.class);
        startActivityForResult(intent, Constants.MAP_RESULT_CODE);
    }

    @Event(R.id.et_create_select)
    private void selectSport(View v) {
        View popupView = getLayoutInflater().inflate(R.layout.popupwindow_sport_type, null);
        mRootView = findViewById(R.id.et_create_select).getRootView();
        mPopupWindow = new PopupWindow(popupView, WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT, true);
        Button mComfirmBtn = (Button) popupView.findViewById(R.id.btn_sport_type);
        mComfirmBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPopupWindow.dismiss();
                mSelect.setOnClickListener(null);
                mSelect.setFocusableInTouchMode(true);
                mSelect.requestFocus();
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
                    mSelect.setText("羽毛球");
                    mItem = "1";
                    break;
                case R.id.iv_type_2:
                    mSelect.setText("足球");
                    mItem = "2";
                    break;
                case R.id.iv_type_3:
                    mSelect.setText("篮球");
                    mItem = "3";
                    break;
                case R.id.iv_type_4:
                    mSelect.setText("网球");
                    mItem = "4";
                    break;
                case R.id.iv_type_5:
                    mSelect.setText("跑步");
                    mItem = "5";
                    break;
                case R.id.iv_type_6:
                    mSelect.setText("游泳");
                    mItem = "6";
                    break;
                case R.id.iv_type_7:
                    mSelect.setText("壁球");
                    mItem = "7";
                    break;
                case R.id.iv_type_8:
                    mSelect.setText("皮划艇");
                    mItem = "8";
                    break;
                case R.id.iv_type_9:
                    mSelect.setText("棒球");
                    mItem = "9";
                    break;
                case R.id.iv_type_10:
                    mSelect.setText("乒乓");
                    mItem = "10";
                    break;
            }
            mPopupWindow.dismiss();
        }
    };

    @Event(R.id.btn_step1_next)
    private void goNext(View v) {
        if (mAddImage.isEnabled()) {
            checkPhone();
        } else {
            onNext();
        }
    }

    private void checkPhone() {
        mUserId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", mUserId);
        RequestParams params = new RequestParams(API.GET_USERINFO);
        try {
            params.addQueryStringParameter("sign", Utils.getSignature(map, Constants.SECRET));
            params.addQueryStringParameter("userId", mUserId);
            x.http().get(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Logger.json(result);
                    UserInfoResult userInfoResult = Utils.parseJsonWithGson(result, UserInfoResult.class);
                    if (userInfoResult.getCode() == Constants.HTTP_OK_200) {
                        if (userInfoResult.getResult().getMobile() == null ||
                                userInfoResult.getResult().getMobile().isEmpty()) {
                            Intent intent = new Intent();
                            intent.setClass(CreateActivity.this, PerfectinformationActivity.class);
                            Utils.startAcitivityForResult(CreateActivity.this, intent, REQUEST_CODE_PHONE);
                        } else {
                            createSport();
                        }
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Utils.showShortToast(CreateActivity.this, getString(R.string.network_error));
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(CreateActivity.this, getString(R.string.network_error));
                }

                @Override
                public void onFinished() {

                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 创建运动页
     **/
    private void createSport() {
        if (null == mPath || mPath.isEmpty()){
            Utils.showShortToast(x.app(),"请选择图片");
            return;
        }
        if (mSportName.getText().toString().isEmpty()){
            Utils.showShortToast(x.app(),"请输入运动名称");
            return;
        }
        if (mLocation.getText().toString().isEmpty()){
            Utils.showShortToast(x.app(),"请选择地址");
            return;
        }
        if (mItem == null || mItem.isEmpty()){
            Utils.showShortToast(x.app(),"请选择运动类型");
            return;
        }else if (mItem.equals("20")){
            Utils.showShortToast(x.app(),"请输入运动类型");
            return;
        }
        Map<String, String> map = new HashMap<>();
        map.put("title", mSportName.getText().toString());
        map.put("sport_type", "1");
        map.put("sport_item", mItem);
        map.put("summary", mDescribe.getText().toString());
        map.put("location", mAddress);
        map.put("place", mLocation.getText().toString());
        map.put("latitude", mLatitude + "");
        map.put("longitude", mLongitude + "");
        if (mItem.equals("20")) {
            map.put("extend", mSelect.getText().toString());
        }
        String json = new Gson().toJson(map, Map.class);
        Map<String, String> jsonMap = new HashMap<>();
        jsonMap.put("userId", mUserId);
        jsonMap.put("json", json);
        RequestParams params = new RequestParams(API.CREATE_SPORT);
        try {
            params.addParameter("sign", Utils.getSignature(jsonMap, Constants.SECRET));
            params.addParameter("userId", mUserId);
            params.addParameter("json", json);
            File file = new File(mPath);
            params.addBodyParameter("file", file, "image/jpg", file.getName());
            x.http().post(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    try {
                        Logger.d(result);
                        JSONObject object = new JSONObject(result);
                        if (object.getInt("code") == Constants.HTTP_OK_200) {
                            mSportId = object.getString("result");
                            onNext();
                        } else {
                            Utils.showShortToast(CreateActivity.this, object.getString("error"));
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


    private void onNext() {
        mAddImage.setEnabled(false);
        mSportName.setEnabled(false);
        mLocation.setEnabled(false);
        mSelect.setEnabled(false);
        mDescribe.setEnabled(false);
        next();
    }


    private void next() {
        Intent intent = new Intent();
        intent.putExtra("path", mPath);
        intent.putExtra("sportName", mSportName.getText().toString());
        intent.putExtra("location", mLocation.getText().toString());
        intent.putExtra("address", mAddress);
        intent.putExtra("sportType", mSelect.getText().toString());
        intent.putExtra("sportId", mSportId);
        intent.putExtra("describe", mDescribe.getText().toString());
        intent.setClass(this, CreatNextActivity.class);
        Utils.start_Activity(this, intent);
        finish();
    }

    public void startClipActivity(Uri uri) {
        Intent intent = new Intent(this, PhotoClipActivity.class);
        intent.putExtra("uri", uri);
        startActivityForResult(intent, PhotoUtil.PHOTO_CORPRESULT_CODE);
    }

    @Event(R.id.iv_create_back)
    private void back(View v) {
        finish();
    }

    @Override
    public void finish() {
        super.finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }


}
