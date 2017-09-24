package com.sportspage.activity;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.event.CreateClubEvent;
import com.sportspage.utils.BitmapUtils;
import com.sportspage.utils.PhotoUtil;
import com.sportspage.utils.Utils;

import org.greenrobot.eventbus.EventBus;
import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import me.yokeyword.swipebackfragment.SwipeBackActivity;


@ContentView(R.layout.activity_club_cover)
public class ClubCoverActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.iv_club_cover)
    private ImageView mCoverView;

    private String mClubName = "";
    private String mSportItem = "";
    private String mBadgePath = "";
    private PhotoUtil mPhotoUtil;

    private String mCoverPath = "";
    private AlertDialog mLoadingDialog;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mTitle.setText("添加俱乐部封面");
        mBackView.setVisibility(View.VISIBLE);
        Intent intent = getIntent();
        mClubName = intent.getStringExtra("clubName");
        mSportItem = intent.getStringExtra("sportType");
        mBadgePath = intent.getStringExtra("path");
        mLoadingDialog = new AlertDialog.Builder(this,R.style.dialog).create();
        mLoadingDialog.setCanceledOnTouchOutside(false);
        View content = LayoutInflater.from(this).inflate(R.layout.dialog_loading, null);
        mLoadingDialog.setView(content);
    }

    @Event(R.id.iv_club_cover)
    private void addCover(View v) {
        mPhotoUtil = new PhotoUtil(ClubCoverActivity.this);
        mPhotoUtil.showDialog();
    }

    @Event(R.id.btn_club_cover_next)
    private void next(View v) {
        if (null == mCoverPath || "".equals(mCoverPath.trim())) {
            Utils.showShortToast(this,"请添加俱乐部封面");
            return;
        }
        if (!mLoadingDialog.isShowing()){
            mLoadingDialog.show();
        }
        Map<String, String> map = new HashMap<>();
        String userId = Utils.getValue(this, "userId");
        map.put("userId",userId);
        map.put("name", mClubName);
        map.put("sportItem", mSportItem);
        if (mSportItem.equals("20")) {
            map.put("extend",getIntent().getStringExtra("extend"));
        }
        RequestParams params = new RequestParams(API.CREATE_CLUB);
        try {
            params.addParameter("sign",Utils.getSignature(map, Constants.SECRET));
            params.addParameter("userId",userId);
            params.addParameter("name", mClubName);
            params.addParameter("sportItem", mSportItem);
            if (mSportItem.equals("20")) {
                params.addParameter("extend",getIntent().getStringExtra("extend"));
            }
            File iconFile = new File(mBadgePath);
            File portrait = new File(mCoverPath);
            params.addBodyParameter("icon", iconFile, "image/jpg", iconFile.getName());
            params.addBodyParameter("portrait", portrait, "image/jpg", portrait.getName());
            x.http().post(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    try {
                        Logger.d(result);
                        JSONObject object = new JSONObject(result);
                        if (object.getInt("code") == Constants.HTTP_OK_200) {
                            String id = object.getInt("result")+"";
                            Intent intent = new Intent();
                            intent.putExtra("clubId",id);
                            EventBus.getDefault().post(new CreateClubEvent());
                            Utils.showShortToast(x.app(),"创建成功");
                            intent.setClass(ClubCoverActivity.this,NewClubNoticeActivity.class);
                            Utils.start_Activity(ClubCoverActivity.this,intent);
                            finish();
                        } else {
                            Utils.showShortToast(ClubCoverActivity.this, object.getString("error"));
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
                    if (mLoadingDialog.isShowing()) {
                        mLoadingDialog.dismiss();
                    }
                }
            });
        } catch (FileNotFoundException e){
            e.printStackTrace();
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


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            // 相册返回
            if (PhotoUtil.CAMRA_SETRESULT_CODE == requestCode) {
                startClipActivity(mPhotoUtil.getCameraUri(data));
            } else if (PhotoUtil.PHOTO_SETRESULT_CODE == requestCode) {
                startClipActivity(mPhotoUtil.getPhotoUri());
            } else if (PhotoUtil.PHOTO_CORPRESULT_CODE == requestCode) {
                // 裁剪返回
                mCoverPath = data.getStringExtra("path");
                BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
                Bitmap bitmap = bitmapUtils.decodeFile(mCoverPath);
                mCoverView.setImageBitmap(bitmap);
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
    }

}
