package com.sportspage.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.utils.BitmapUtils;
import com.sportspage.utils.PhotoUtil;
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

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_authentication)
public class AuthenticationActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.tv_title_right)
    private TextView mRightText;

    @ViewInject(R.id.iv_auth_front)
    private ImageView mFrontImg;
    @ViewInject(R.id.iv_auth_back)
    private ImageView mBackImg;
    @ViewInject(R.id.iv_auth_handle)
    private ImageView mHandleImg;

    private PhotoUtil mPhotoUtil;

    private int mWhitch = 0;

    private String[] mPaths = new String[3];

    private final int FRONT_IMG = 100;
    private final int BACK_IMG = 101;
    private final int HANDLE_IMG = 102;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("实名认证");
        mBackView.setVisibility(View.VISIBLE);
        mRightText.setText("认证");
        mRightText.setVisibility(View.VISIBLE);
        mPhotoUtil = new PhotoUtil(this);
    }

    @Event(R.id.iv_auth_front)
    private void front(View v) {
        mWhitch = FRONT_IMG;
        mPhotoUtil.showDialog();
    }

    @Event(R.id.iv_auth_back)
    private void back(View v) {
        mWhitch = BACK_IMG;
        mPhotoUtil.showDialog();
    }

    @Event(R.id.iv_auth_handle)
    private void handle(View v) {
        mWhitch = HANDLE_IMG;
        mPhotoUtil.showDialog();
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
                String path = data.getStringExtra("path");
                BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
                Bitmap bitmap = bitmapUtils.decodeFile(path);
                switch (mWhitch) {
                    case FRONT_IMG:
                        mPaths[0] = path;
                        mFrontImg.setImageBitmap(bitmap);
                        break;
                    case BACK_IMG:
                        mPaths[1] = path;
                        mBackImg.setImageBitmap(bitmap);
                        break;
                    case HANDLE_IMG:
                        mPaths[2] = path;
                        mHandleImg.setImageBitmap(bitmap);
                        break;
                }
            }
        }

    }

    @Event(R.id.tv_title_right)
    private void comfirm(View v) {
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        RequestParams params = new RequestParams(API.REAL_NAME_CHECK);
        try {
            params.addParameter("sign", Utils.getSignature(map, Constants.SECRET));
            params.addParameter("userId", userId);
            for (int i = 0; i < mPaths.length; i++) {
                if (mPaths[i] == null || mPaths[i].isEmpty()) {
                    Utils.showShortToast(x.app(), "请按要求上传图片");
                    return;
                }
                File file = new File(mPaths[i]);
                params.addBodyParameter("file[]", file, "image/jpg", file.getName());
            }
            x.http().post(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    try {
                        Logger.d(result);
                        JSONObject object = new JSONObject(result);
                        if (object.getInt("code") == Constants.HTTP_OK_200) {
                            Utils.showShortToast(x.app(), "请等待审核");
                            Intent intent = new Intent();
                            intent.putExtra("auth", true);
                            setResult(RESULT_OK, intent);
                            finish();
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

    @Event(R.id.iv_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    public void startClipActivity(Uri uri) {
        Intent intent = new Intent(this, PhotoClipActivity.class);
        intent.putExtra("uri", uri);
        startActivityForResult(intent, PhotoUtil.PHOTO_CORPRESULT_CODE);
    }
}
