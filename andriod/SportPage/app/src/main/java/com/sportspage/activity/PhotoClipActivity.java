package com.sportspage.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

import com.isseiaoki.simplecropview.CropImageView;
import com.isseiaoki.simplecropview.callback.CropCallback;
import com.isseiaoki.simplecropview.callback.LoadCallback;
import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.event.UpdateUserInfoEvent;
import com.sportspage.utils.BitmapUtils;
import com.sportspage.utils.Utils;

import org.greenrobot.eventbus.EventBus;
import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.x;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 图片剪切页面
 */
public class PhotoClipActivity extends Activity {
    private CropImageView mCropImageView;
    private Button bt_cancel, bt_ok;
    private String tempCropFilePath;
    private Context context;
    private Bitmap bitmap;
    private Uri uri;
    private int mType = Constants.PHOTOCLIP_16_9;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        setContentView(R.layout.activity_photo);
        context = this;
        init();

    }

    private void init() {
        bt_cancel = (Button) findViewById(R.id.bt_photo_cancle);
        bt_ok = (Button) findViewById(R.id.bt_photo_ok);
        Intent intent = getIntent();
        uri = (Uri) intent.getExtras().get("uri");
        mCropImageView = (CropImageView) findViewById(R.id.cropImageView);
        mType = getIntent().getIntExtra("type", Constants.PHOTOCLIP_16_9);
        if (mType == Constants.PHOTOCLIP_16_9) {
           mCropImageView.setCropMode(CropImageView.CropMode.RATIO_16_9);
        } else {
            mCropImageView.setCropMode(CropImageView.CropMode.SQUARE);
        }
        mCropImageView.startLoad(uri, new LoadCallback() {
            @Override
            public void onSuccess() {

            }

            @Override
            public void onError() {

            }
        });

        // 图片选择 需要去裁剪的图片路径
        tempCropFilePath = getFilePath();

        Logger.d("获取地址 = " + tempCropFilePath);
        bt_cancel.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                setResult(RESULT_CANCELED);
                finish();
            }
        });

        bt_ok.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // 剪切图片
                Uri outUri = Uri.parse(tempCropFilePath);
                mCropImageView.startCrop(outUri, new CropCallback() {
                    @Override
                    public void onSuccess(Bitmap cropped) {
                        bitmap = cropped;
                        result();
                    }

                    @Override
                    public void onError() {
                        Utils.showShortToast(x.app(), "剪切失败");
                    }
                }, null);

            }
        });
    }

    private void result() {
        BitmapUtils bitmaputil = new BitmapUtils(
                getApplicationContext());
        if (bitmap != null) {
            // 压缩保存图片
            bitmaputil.saveBitmapInSD(tempCropFilePath, bitmap);
            if (mType == Constants.PHOTOCLIP_16_9 || mType == Constants.PHOTOCLIP_1_1) {
                Intent intent = new Intent();
                intent.putExtra("path", tempCropFilePath);
                setResult(RESULT_OK, intent);
                finish();
                recycle();
            } else if(mType == Constants.PHOTOCLIP_UPDATE_PORTRAIT){
                uploadPortrait();
            }
        }
    }

    private void uploadPortrait() {
        String userId = Utils.getValue(x.app(), "userId");
        Map<String, String> jsonMap = new HashMap<>();
        jsonMap.put("userId", userId);
        RequestParams params = new RequestParams(API.UPDATE_PORTRAIT);
        try {
            params.addParameter("sign", Utils.getSignature(jsonMap, Constants.SECRET));
            params.addParameter("userId", userId);
            File file = new File(tempCropFilePath);
            params.addBodyParameter("file", file, "image/jpg", file.getName());
            x.http().post(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    try {
                        Logger.d(result);
                        JSONObject object = new JSONObject(result);
                        if (object.getInt("code") == Constants.HTTP_OK_200) {
                            Utils.showShortToast(x.app(), "修改成功");
                            Intent intent = new Intent();
                            intent.putExtra("path", tempCropFilePath);
                            setResult(RESULT_OK, intent);
                            finish();
                            recycle();
                            EventBus.getDefault().post(new UpdateUserInfoEvent());
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


    public String getMydir() {
        return (Environment.MEDIA_MOUNTED.equals(Environment
                .getExternalStorageState()) || !Environment
                .isExternalStorageRemovable()) ? Environment
                .getExternalStorageDirectory().getPath() + File.separator + ""
                : context.getCacheDir().getPath() + File.separator + "";
    }

    // 获取图片路径
    public String getFilePath() {
        Logger.d("根目录路径  = " + getMydir());
        String path = getMydir();
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss")
                .format(new Date());
        path = path + timeStamp + ".jpg";
        return path;
    }

    @Override
    protected void onPause() {
        mCropImageView.setImageBitmap(null);
        super.onPause();
    }

    @Override
    protected void onResume() {
        mCropImageView.startLoad(uri, new LoadCallback() {
            @Override
            public void onSuccess() {

            }

            @Override
            public void onError() {

            }
        });
        super.onResume();
    }

    @Override
    protected void onDestroy() {
        recycle();
        super.onDestroy();
    }

    public void recycle() {
        if (bitmap != null && !bitmap.isRecycled()) {
            bitmap.recycle();// 回收bitmap
            bitmap = null;
            System.gc();
        }
    }

}
