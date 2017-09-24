package com.sportspage.fragment;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.cocosw.bottomsheet.BottomSheet;
import com.orhanobut.logger.Logger;
import com.sportspage.App;
import com.sportspage.R;
import com.sportspage.activity.AboutActivity;
import com.sportspage.activity.AuthenticationActivity;
import com.sportspage.activity.ClubActivity;
import com.sportspage.activity.CreateActivity;
import com.sportspage.activity.CreateClubActivity;
import com.sportspage.activity.FeedbackActivity;
import com.sportspage.activity.MineActivity;
import com.sportspage.activity.MyClubActivity;
import com.sportspage.activity.MySportsPageActivity;
import com.sportspage.activity.SettingActivity;
import com.sportspage.activity.ShareActivity;
import com.sportspage.activity.SportsDetailActivity;
import com.sportspage.activity.SportsRecordActivity;
import com.sportspage.activity.WalletActivity;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.entity.WalletResult;
import com.sportspage.event.ClubBindSportsPageEvent;
import com.sportspage.event.UpdateMoneyEvent;
import com.sportspage.event.UpdateUserInfoEvent;
import com.sportspage.utils.DateUtils;
import com.sportspage.utils.LogicUtils;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;
import com.sportspage.view.XScrollView;
import com.tencent.connect.share.QQShare;
import com.tencent.connect.share.QzoneShare;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import com.tencent.mm.sdk.modelmsg.WXWebpageObject;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;
import com.zhy.autolayout.AutoRelativeLayout;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.rong.imkit.RongIM;
import io.rong.imlib.model.UserInfo;
import me.yokeyword.fragmentation.SupportFragment;


//我的
@ContentView(R.layout.fragment_profile)
public class ProfileFragment extends SupportFragment {
    private Activity mContent;
    @ViewInject(R.id.tv_profile_balance)
    private TextView mWalletBalance;
    @ViewInject(R.id.riv_profile_img)
    private ImageView mHeadImg;
    @ViewInject(R.id.tv_profile_username)
    private TextView mUserName;
    @ViewInject(R.id.iv_profile_authentication_status)
    private ImageView mAuthentication;
    @ViewInject(R.id.rl_profile_authentication)
    private RelativeLayout mAuthenticationLayout;
    @ViewInject(R.id.tv_profile_authentication)
    private TextView mAuthenticationText;
    @ViewInject(R.id.rl_profile_title)
    private AutoRelativeLayout mTitleLayout;
    @ViewInject(R.id.scrollView)
    private XScrollView mScrollView;

    private UserInfoResult.ResultBean mInfo;
    private Tencent mTencent;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = x.view().inject(this, inflater, container);
        mContent = this.getActivity();
        EventBus.getDefault().register(this);
        init();
        getWalletInfo();
        return view;
    }

    private void init() {
        mTencent = Tencent.createInstance(Constants.QQ_APP_ID, mContent);
        String userId = Utils.getValue(mContent, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        Xutils.getInstance(mContent, false).get(API.GET_USERINFO, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                mInfo = Utils.parseJsonWithGson(result, UserInfoResult.ResultBean.class);
                Utils.putValue(x.app(), "userId", mInfo.getId());
                Utils.putValue(x.app(), "nick", mInfo.getNick());
                Utils.putValue(x.app(), "portrait", mInfo.getPortrait());
                Utils.putValue(x.app(), "mobile", mInfo.getMobile());
                RongIM.getInstance().refreshUserInfoCache(new UserInfo(mInfo.getId(),
                        mInfo.getNick(), Uri.parse(mInfo.getPortrait())));
                LogicUtils.loadImageFromUrl(mHeadImg, mInfo.getPortrait());
                mUserName.setText(Utils.getValue(mContent, "nick"));
                if (mInfo.getValid().equals("1")) {
                    mAuthentication.setImageResource(R.drawable.mine_more);
                    mAuthenticationText.setText("未认证");
                } else if (mInfo.getValid().equals("2")) {
                    mAuthentication.setImageResource(R.drawable.authenticating);
                    mAuthenticationText.setText("认证中");
                    mAuthenticationLayout.setEnabled(false);
                } else {
                    mAuthentication.setImageResource(R.drawable.authenticated);
                    mAuthenticationText.setText("已认证");
                    mAuthenticationLayout.setEnabled(false);
                }
            }

            @Override
            public void onFinished() {
            }
        });
    }

    @Event(value = R.id.rl_profile_wallet)
    private void goMyWallet(View v) {
        Utils.start_Activity(mContent, WalletActivity.class);

    }

    @Override
    public void onResume() {
        super.onResume();
    }

    private void getWalletInfo() {
        String userId = Utils.getValue(mContent, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        Xutils.getInstance(mContent).get(API.GET_ACCOUNT_INFO, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                WalletResult walletResult = Utils.parseJsonWithGson(result, WalletResult.class);
                String balance = walletResult.getBalance();
                Utils.putFloatValue(mContent, "balance", Float.parseFloat(balance));
                mWalletBalance.setText(getResources().getString(R.string.balance) + " " + balance);
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(R.id.riv_profile_img)
    private void goMine(View v) {
        Utils.start_Activity(mContent, MineActivity.class);
    }

    @Event(R.id.ll_profile_proceed)
    private void proceed(View v) {
        Intent intent = new Intent();
        intent.putExtra("index", 1);
        intent.setClass(mContent, SportsRecordActivity.class);
        Utils.start_Activity(mContent, intent);
    }

    @Event(R.id.ll_profile_settle)
    private void settle(View v) {
        Intent intent = new Intent();
        intent.putExtra("index", 2);
        intent.setClass(mContent, SportsRecordActivity.class);
        Utils.start_Activity(mContent, intent);
    }

    @Event(R.id.ll_profile_evaluation)
    private void evaluation(View v) {
        Intent intent = new Intent();
        intent.putExtra("index", 3);
        intent.setClass(mContent, SportsRecordActivity.class);
        Utils.start_Activity(mContent, intent);
    }

    @Event(R.id.ll_profile_all_record)
    private void all(View v) {
        Intent intent = new Intent();
        intent.putExtra("index", 0);
        intent.setClass(mContent, SportsRecordActivity.class);
        Utils.start_Activity(mContent, intent);
    }

    @Event(R.id.rl_profile_club)
    private void goClubList(View view) {
        Utils.start_Activity(mContent, MyClubActivity.class);
    }

    @Event(R.id.tv_profile_setting)
    private void goSetting(View v) {
        Utils.start_Activity(mContent, SettingActivity.class);
    }

    @Event(R.id.ll_profile_sportspage)
    private void goSportPageRecord(View v) {
        Utils.start_Activity(mContent, MySportsPageActivity.class);
    }

    @Event(R.id.ll_profile_create)
    private void goCreate(View v) {
        Utils.start_Activity(mContent, CreateActivity.class);
    }

    @Event(R.id.rl_profile_authentication)
    private void goAuthentication(View v) {
        Utils.start_Activity(mContent, AuthenticationActivity.class);
    }

    @Event(R.id.rl_profile_feedback)
    private void goFeedback(View v) {
        Utils.start_Activity(mContent, FeedbackActivity.class);
    }

    @Event(R.id.rl_profile_about)
    private void goAbout(View v) {
        Utils.start_Activity(mContent, AboutActivity.class);
    }

    @Event(R.id.rl_profile_share)
    private void goShare(View v) {
        WXWebpageObject webpage = new WXWebpageObject();
        webpage.webpageUrl = getShareH5Url();
        WXMediaMessage msg = new WXMediaMessage(webpage);
        msg.title = "运动页";
        msg.description = "您的运动管理平台";
        Bitmap thumb = Utils.drawableToBitmap(mContent.getResources().getDrawable(R.mipmap.ic_launcher));
        Bitmap thumbBitmap = Bitmap.createScaledBitmap(thumb, 50, 50, true);
        msg.thumbData = Utils.bmpToByteArray(thumbBitmap, true);
        final SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = Utils.buildTransaction("webpage");
        req.message = msg;
        BottomSheet bottomSheet = new BottomSheet.Builder(mContent,R.style.BottomSheet_StyleDialog).title("分享运动页到")
                .sheet(R.menu.share_list)
                .listener(new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        switch (which) {
                            case R.id.friend:
                                req.scene = SendMessageToWX.Req.WXSceneSession;
                                App.api.sendReq(req);
                                break;
                            case R.id.dicover:
                                req.scene = SendMessageToWX.Req.WXSceneTimeline;
                                App.api.sendReq(req);
                                break;
                            case R.id.qq:
                                shareToQQ();
                                break;
                            case R.id.qzone:
                                shareToQzone();
                                break;
                        }
                    }
                }).grid().build();
        bottomSheet.getMenu().removeItem(R.id.sportspage);
        bottomSheet.show();
        bottomSheet.invalidate();
    }

    public void shareToQQ()
    {
        final Bundle params = new Bundle();
        params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_DEFAULT);
        params.putString(QQShare.SHARE_TO_QQ_TITLE, "运动页");
        params.putString(QQShare.SHARE_TO_QQ_SUMMARY,  "您的运动管理平台");
        params.putString(QQShare.SHARE_TO_QQ_TARGET_URL,  getShareH5Url());
        params.putString(QQShare.SHARE_TO_QQ_IMAGE_URL,
                "http://www.sportspage.cn/home/Tpl//Index/images/logo.jpg");
        params.putString(QQShare.SHARE_TO_QQ_APP_NAME,  "运动页");
        params.putInt(QQShare.SHARE_TO_QQ_EXT_INT,  11);
        mTencent.shareToQQ(mContent, params, mUiListener);
    }

    private String getShareH5Url() {
//        return "http://fusion.qq.com/cgi-bin/qzapps/unified_jump?appid=52416590" +
//                "&from=mqq&actionFlag=0&params=pname%3D" +
//                "com.sportspage%26versioncode%3D1%26channelid%3D%26actionflag%3D0";
        return "http://a.app.qq.com/o/simple.jsp?pkgname=com.sportspage";
    }


    private void shareToQzone () {
        Bundle params = new Bundle();
        ArrayList<String> imageList= new ArrayList<>();
        imageList.add("http://www.sportspage.cn/home/Tpl//Index/images/logo.jpg");
        params.putInt(QzoneShare.SHARE_TO_QZONE_KEY_TYPE,QzoneShare.SHARE_TO_QZONE_TYPE_IMAGE_TEXT );
        params.putString(QzoneShare.SHARE_TO_QQ_TITLE, "运动页");//必填
        params.putString(QzoneShare.SHARE_TO_QQ_SUMMARY,  "您的运动管理平台");//选填
        params.putString(QzoneShare.SHARE_TO_QQ_TARGET_URL, getShareH5Url());//必填
        params.putStringArrayList(QzoneShare.SHARE_TO_QQ_IMAGE_URL, imageList);
        mTencent.shareToQzone(mContent, params, mUiListener);
    }

    private void scrollChangeTitle() {
        mScrollView.setScrollViewListener(new XScrollView.ScrollViewListener() {
            @Override
            public void onScrollChanged(XScrollView scrollView, int x, int y, int oldx, int oldy) {
                if (y > 88) {
                    mTitleLayout.setBackgroundColor(getResources().getColor(R.color.bar_color));
                } else {
                    mTitleLayout.setBackgroundColor(getResources().getColor(R.color.trans));

                }
            }
        });
    }

    @Event(R.id.rl_profile_title)
    private void clickTitle(View view) {
        mScrollView.smoothScrollTo(0, 0);
    }

    private IUiListener mUiListener = new IUiListener() {
        @Override
        public void onComplete(Object o) {
            Logger.json(o.toString());
            Logger.d("----------------------成功-----------------");
        }

        @Override
        public void onError(UiError uiError) {
            Logger.d(uiError.errorMessage);
        }

        @Override
        public void onCancel() {

        }
    };

    @Override
    public void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }

    @Subscribe
    public void onEventMainThread(UpdateUserInfoEvent event) {
        init();
    }

    @Subscribe
    public void onEventMainThread(UpdateMoneyEvent event) {
        getWalletInfo();
    }
}