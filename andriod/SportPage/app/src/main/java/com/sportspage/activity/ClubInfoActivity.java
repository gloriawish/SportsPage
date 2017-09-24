package com.sportspage.activity;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.event.PublishNoticeEvent;
import com.sportspage.event.UpdateBadgeEvent;
import com.sportspage.event.UpdateClubNameEvent;
import com.sportspage.event.UpdateClubSportItemEvent;
import com.sportspage.event.UpdateCoverEvent;
import com.sportspage.utils.BitmapUtils;
import com.sportspage.utils.LogicUtils;
import com.sportspage.utils.PhotoUtil;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.HashMap;
import java.util.Map;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_club_info)
public class ClubInfoActivity extends SwipeBackActivity  {
    @ViewInject(R.id.iv_club_info_cover)
    private ImageView mClubCover;
    @ViewInject(R.id.iv_club_info_badge)
    private ImageView mClubBadge;
    @ViewInject(R.id.tv_club_info_name)
    private TextView mClubName;
    @ViewInject(R.id.tv_club_info_type)
    private TextView mClubType;
    @ViewInject(R.id.tv_club_info_notice)
    private TextView mClubNotice;
    private PhotoUtil mPhotoUtil;

    private int mWhitch = 0;
    private final int COVER_IMG = 100;
    private final int BADGE_IMG = 200;

    private String mClubId;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        EventBus.getDefault().register(this);
        Bundle bundle = getIntent().getBundleExtra("data");
        Glide.with(ClubInfoActivity.this)
                .load(bundle.getString("cover"))
                .into(mClubCover);
        Glide.with(ClubInfoActivity.this).load(bundle.getString("badge")).into(mClubBadge);
        mClubName.setText(bundle.getString("name"));
        if (bundle.get("type").equals("20")){
            mClubType.setText(bundle.getString("extend"));
        } else {
            mClubType.setText(LogicUtils.getType(bundle.getString("type")));
        }
        if (null == bundle.getString("notice") || "".equals(bundle.getString("notice"))) {
            mClubNotice.setText("暂无公告");
        } else {
            mClubNotice.setText("\u3000\u3000"+bundle.getString("notice"));
        }
        mClubId = bundle.getString("clubId");
        mPhotoUtil = new PhotoUtil(this);
    }

    @Event(R.id.iv_club_info_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in,R.anim.push_right_out);
    }


    @Event(R.id.btn_club_info_cover)
    private void changeCover(View view) {
        mWhitch = COVER_IMG;
        mPhotoUtil.showDialog();
    }


    @Event(R.id.rl_club_info_badge)
    private void changeBadge(View v) {
        mWhitch = BADGE_IMG;
        mPhotoUtil.showDialog();
    }

    @Event(R.id.rl_club_info_name)
    private void changeName(View v) {
        Intent intent = new Intent();
        intent.putExtra("clubId",mClubId);
        intent.putExtra("clubName",mClubName.getText().toString());
        intent.setClass(this,UpdateClubNameActivity.class);
        Utils.start_Activity(this,intent);
    }

    @Event(R.id.rl_club_info_notice)
    private void changeNotice(View v) {
        Intent intent = new Intent();
        intent.putExtra("clubId",mClubId);
        intent.setClass(this,PublishClubNoticeActivity.class);
        Utils.start_Activity(this,intent);
    }

    @Event(R.id.rl_club_info_type)
    private void changeType(View v) {
        Intent intent = new Intent();
        intent.putExtra("clubId",mClubId);
        intent.putExtra("type",mClubType.getText().toString());
        intent.setClass(this,UpdateClubSportItemActivity.class);
        Utils.start_Activity(this,intent);
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
                BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
                final Bitmap bitmap = bitmapUtils.decodeFile(path);
                Map<String,String> map = new HashMap<>();
                map.put("userId",Utils.getValue(this,"userId"));
                map.put("clubId",mClubId);
                switch (mWhitch) {
                    case COVER_IMG:
                        Xutils.getInstance(this).updateFile(API.UPDATE_CLUB_PORTRAIT, map
                                , "portrait", path, new Xutils.XCallBack() {
                            @Override
                            public void onResponse(String result) {
                                Utils.showShortToast(x.app(),"修改成功");
                                EventBus.getDefault().post(new UpdateCoverEvent(path));
                                mClubCover.setImageBitmap(bitmap);
                            }

                            @Override
                            public void onFinished() {

                            }
                        });
                        break;
                    case BADGE_IMG:
                        Xutils.getInstance(this).updateFile(API.UPDATE_CLUB_ICON, map
                                , "icon", path, new Xutils.XCallBack() {
                                    @Override
                                    public void onResponse(String result) {
                                        Utils.showShortToast(x.app(),"修改成功");
                                        EventBus.getDefault().post(new UpdateBadgeEvent(path));
                                        mClubBadge.setImageBitmap(bitmap);
                                    }

                                    @Override
                                    public void onFinished() {

                                    }
                                });
                        break;
                }
            }
        }
    }

    public void startClipActivity(Uri uri) {
        Intent intent = new Intent(this, PhotoClipActivity.class);
        intent.putExtra("uri", uri);
        intent.putExtra("type", Constants.PHOTOCLIP_1_1);
        Utils.startAcitivityForResult(this,intent,PhotoUtil.PHOTO_CORPRESULT_CODE);
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }

    @Subscribe
    public void onEventMainThread(UpdateClubNameEvent event) {
        mClubName.setText(event.getName());
    }

    @Subscribe
    public void onEventMainThread(UpdateClubSportItemEvent event) {
        mClubType.setText(event.getItem());
    }

    @Subscribe
    public void onEventMainThread(PublishNoticeEvent event) {
        mClubNotice.setText("\u3000\u3000"+event.getContent());
    }
}
