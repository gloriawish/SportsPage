package com.sportspage.activity;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.makeramen.roundedimageview.RoundedImageView;
import com.orhanobut.logger.Logger;
import com.sportspage.App;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.event.UpdateUserInfoEvent;
import com.sportspage.utils.BitmapUtils;
import com.sportspage.utils.LogicUtils;
import com.sportspage.utils.PhotoUtil;
import com.sportspage.utils.StreamUtils;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;
import com.tencent.mm.sdk.modelmsg.SendAuth;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import cn.qqtheme.framework.picker.AddressPicker;
import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_mine)
public class MineActivity extends SwipeBackActivity {
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    @ViewInject(R.id.riv_mine_portrait)
    private RoundedImageView mPortrait;
    @ViewInject(R.id.tv_mine_username)
    private TextView mUserName;
    @ViewInject(R.id.tv_mine_nick)
    private TextView mNick;
    @ViewInject(R.id.tv_mine_sex)
    private TextView mSex;
    @ViewInject(R.id.tv_mine_phone)
    private TextView mPhone;
    @ViewInject(R.id.tv_mine_wechat)
    private TextView mWechat;
    @ViewInject(R.id.tv_mine_mail)
    private TextView mMail;
    @ViewInject(R.id.tv_mine_address)
    private TextView mAddress;
    @ViewInject(R.id.rl_mine_wechat)
    private RelativeLayout mWechatLayout;
    @ViewInject(R.id.iv_wechat_more)
    private ImageView mWechatMore;
    @ViewInject(R.id.iv_phone_more)
    private ImageView mPhoneMore;
    @ViewInject(R.id.rl_mine_phone)
    private RelativeLayout mPhoneLayout;

    private PhotoUtil mPhotoUtil;

    private String mPath;

    private Bitmap mBitmap;

    private UserInfoResult.ResultBean mInfo;

    private static final int REQUEST_CODE_NICK = 1000;
    private static final int REQUEST_CODE_SEX = 2000;
    public static final int REQUEST_CODE_REGION = 3000;
    public static final int REQUEST_CODE_MAIL = 4000;
    private static final int REQUEST_CODE_PHONE = 7000;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        EventBus.getDefault().register(this);
        init();
    }

    private void init() {
        mTitle.setText(R.string.personal_info);
        mBackView.setVisibility(View.VISIBLE);
        String userId = Utils.getValue(x.app(), "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        Xutils.getInstance(this).get(API.GET_USERINFO, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                mInfo = Utils.parseJsonWithGson(result, UserInfoResult.ResultBean.class);
                setData();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    private void setData() {
        LogicUtils.loadImageFromUrl(mPortrait, mInfo.getPortrait());
        mUserName.setText(mInfo.getUname());
        mNick.setText(mInfo.getNick());
        mSex.setText(mInfo.getSex());
        if (mInfo.getMobile() == null || mInfo.getMobile().isEmpty()) {
            mPhone.setText("未绑定");
            mPhoneMore.setVisibility(View.VISIBLE);
        } else {
            mPhone.setText("已绑定");
            mPhoneLayout.setEnabled(false);
        }
        if (Utils.isWXAppInstalledAndSupported()) {
            if (mInfo.getWx_openid() == null || mInfo.getWx_openid().isEmpty()) {
                mWechat.setText("未绑定");
                mWechatMore.setVisibility(View.VISIBLE);
            } else {
                Utils.putBooleanValue(x.app(),"bind",true);
                mWechat.setText("已绑定");
                mWechatMore.setVisibility(View.INVISIBLE);
                mWechatLayout.setEnabled(false);
            }
        } else {
            mWechat.setText("未安装微信");
            mWechatMore.setVisibility(View.VISIBLE);
        }
        if (mInfo.getEmail() == null || mInfo.getEmail().isEmpty() || mInfo.equals("保密")) {
            mMail.setText("未填写");
        } else {
            mMail.setText(mInfo.getEmail());
        }
        mAddress.setText(mInfo.getCity());
    }


    @Event(R.id.rl_mine_phone)
    private void bindMobile(View v){
        Intent intent = new Intent();
        intent.setClass(this, PerfectinformationActivity.class);
        Utils.startAcitivityForResult(this, intent, REQUEST_CODE_PHONE);
    }

    @Event(R.id.riv_mine_portrait)
    private void changePortrait(View v) {
        mPhotoUtil = new PhotoUtil(this);
        mPhotoUtil.showDialog();
    }

    @Event(R.id.rl_mine_nick)
    private void changeNick(View v) {
        Intent intent = new Intent();
        intent.putExtra("nick", mInfo.getNick());
        intent.setClass(this, NickActivity.class);
        Utils.startAcitivityForResult(this, intent, REQUEST_CODE_NICK);
    }

    @Event(R.id.rl_mine_sex)
    private void changeSex(View v) {
        Intent intent = new Intent();
        intent.putExtra("nick", mInfo.getNick());
        intent.setClass(this, SexActivity.class);
        Utils.startAcitivityForResult(this, intent, REQUEST_CODE_SEX);
    }

    @Event(R.id.rl_mine_mail)
    private void changeMail(View v) {
        Intent intent = new Intent();
        if (mInfo.getEmail() != null && !mInfo.getEmail().isEmpty()) {
            intent.putExtra("mail", mInfo.getEmail());
        }
        intent.setClass(this, MailActivity.class);
        Utils.startAcitivityForResult(this, intent, REQUEST_CODE_MAIL);
    }

    @Event(R.id.rl_mine_wechat)
    private void bindWechat(View v){
        if(Utils.isWXAppInstalledAndSupported()){
            final SendAuth.Req req = new SendAuth.Req();
            req.scope = "snsapi_userinfo";
            req.state = Constants.WECHAT_BIND;
            App.api.sendReq(req);
        } else {
            Utils.showShortToast(this,getString(R.string.uninstall_wechat));
        }
    }

    @Event(R.id.rl_mine_address)
    private void changeCity(View v) {
        String[] tmp = mInfo.getCity().split(" ");
        ArrayList<AddressPicker.Province> data = new ArrayList<AddressPicker.Province>();
        String json = StreamUtils.get(this,R.raw.city);
        data.addAll(Utils.jsonToArrayList(json, AddressPicker.Province.class));
        AddressPicker picker = new AddressPicker(this, data);
        if (tmp.length > 0) {
            picker.setSelectedItem(tmp[0], tmp[1]);
        }
        picker.setHideCounty(true);//加上此句举将只显示省级及地级
        picker.setOnAddressPickListener(new AddressPicker.OnAddressPickListener() {
            @Override
            public void onAddressPicked(final String province, final String city, String county) {
                String userId = Utils.getValue(MineActivity.this,"userId");
                Map<String,String> map = new HashMap<>();
                map.put("userId",userId);
                map.put("city",province + " " + city);
                Xutils.getInstance(MineActivity.this).post(API.UPDATE_CITY, map, new Xutils.XCallBack() {
                    @Override
                    public void onResponse(String result) {
                        Utils.showShortToast(x.app(),"修改成功");
                        mAddress.setText(province + " " + city);
                    }

                    @Override
                    public void onFinished() {

                    }
                });
            }
        });
        picker.show();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case REQUEST_CODE_NICK:
                    String nick = data.getStringExtra("nick");
                    mNick.setText(nick);
                    EventBus.getDefault().post(new UpdateUserInfoEvent());
                    break;
                case REQUEST_CODE_SEX:
                    String sex = data.getStringExtra("sex");
                    mSex.setText(sex);
                    break;
                case REQUEST_CODE_REGION:
                    String city = data.getStringExtra("result");
                    mAddress.setText(city);
                    break;
                case REQUEST_CODE_PHONE:
                    boolean perfectResult = data.getBooleanExtra("perfectResult",false);
                    if (perfectResult){
                        mPhone.setText("已绑定");
                        mPhoneMore.setVisibility(View.INVISIBLE);
                        mPhoneLayout.setEnabled(false);
                    }
                    break;
                case REQUEST_CODE_MAIL:
                    String mail = data.getStringExtra("mail");
                    mMail.setText(mail);
                    break;
                case PhotoUtil.CAMRA_SETRESULT_CODE:
                    startClipActivity(mPhotoUtil.getCameraUri(data));
                    break;
                case PhotoUtil.PHOTO_SETRESULT_CODE:
                    startClipActivity(mPhotoUtil.getPhotoUri());
                    break;
                case PhotoUtil.PHOTO_CORPRESULT_CODE:
                    mPath = data.getStringExtra("path");
                    BitmapUtils bitmapUtils = new BitmapUtils(getApplicationContext());
                    mBitmap = bitmapUtils.decodeFile(mPath);
                    mPortrait.setImageBitmap(mBitmap);
                    break;
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        boolean isBind = Utils.getBooleanValue(this,"bind",false);
        if (isBind){
            mWechat.setText("已绑定");
            mWechatMore.setVisibility(View.INVISIBLE);
            mWechatLayout.setEnabled(false);
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
        intent.putExtra("type", Constants.PHOTOCLIP_UPDATE_PORTRAIT);
        startActivityForResult(intent, PhotoUtil.PHOTO_CORPRESULT_CODE);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }

    @Subscribe
    public void onEventMainThread(UpdateUserInfoEvent event) {
        init();
    }
}
