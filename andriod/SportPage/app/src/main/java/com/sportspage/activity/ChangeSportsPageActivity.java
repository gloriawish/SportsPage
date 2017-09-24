package com.sportspage.activity;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.app.Activity;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.event.UpdateBadgeEvent;
import com.sportspage.event.UpdateCoverEvent;
import com.sportspage.utils.BitmapUtils;
import com.sportspage.utils.LogicUtils;
import com.sportspage.utils.PhotoUtil;
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

@ContentView(R.layout.activity_change_sports_page)
public class ChangeSportsPageActivity extends SwipeBackActivity {

    @ViewInject(R.id.iv_change_sportspage_cover)
    private ImageView mCover;
    @ViewInject(R.id.tv_change_sportspage_name)
    private TextView mName;
    @ViewInject(R.id.tv_change_sportspage_desc)
    private TextView mDesc;
    private PhotoUtil mPhotoUtil;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        x.view().inject(this);
        initView();
    }

    private void initView() {
        mPhotoUtil = new PhotoUtil(this);
        LogicUtils.loadImageFromUrl(mCover,getIntent().getStringExtra("imageUrl"));
        mName.setText(getIntent().getStringExtra("name"));
        mDesc.setText(getIntent().getStringExtra("desc"));
    }

    @Event(R.id.iv_change_sportspage_back)
    private void goBack(View view) {
        finish();
    }

    @Override
    public void finish() {
        super.finish();
        overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
    }

    @Event(R.id.btn_change_sportspage_cover)
    private void changeCover(View view) {
        mPhotoUtil.showDialog();
    }

    @Event(R.id.rl_change_sportspage_name)
    private void changeName(View view) {

    }

    @Event(R.id.rl_change_sportspage_desc)
    private void changeDesc(View view) {

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
                final String path = data.getStringExtra("path");
//                BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
//                final Bitmap bitmap = bitmapUtils.decodeFile(path);
//                Map<String,String> map = new HashMap<>();
//                map.put("userId",Utils.getValue(this,"userId"));
//                map.put("clubId",getIntent().getStringExtra("id"));
//                Xutils.getInstance(this).updateFile(API.UPDATE_CLUB_PORTRAIT, map
//                        , "portrait", path, new Xutils.XCallBack() {
//                            @Override
//                            public void onResponse(String result) {
//                                Utils.showShortToast(x.app(),"修改成功");
//                                EventBus.getDefault().post(new UpdateCoverEvent(path));
//                                mCover.setImageBitmap(bitmap);
//                            }
//
//                            @Override
//                            public void onFinished() {
//
//                            }
//                        });
            }
        }
    }

    public void startClipActivity(Uri uri) {
        Intent intent = new Intent(this, PhotoClipActivity.class);
        intent.putExtra("uri", uri);
        intent.putExtra("type", Constants.PHOTOCLIP_16_9);
        Utils.startAcitivityForResult(this,intent,PhotoUtil.PHOTO_CORPRESULT_CODE);
    }


}
