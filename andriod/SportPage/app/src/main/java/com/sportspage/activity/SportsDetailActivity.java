package com.sportspage.activity;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.cocosw.bottomsheet.BottomSheet;
import com.flyco.tablayout.SlidingTabLayout;
import com.google.gson.Gson;
import com.makeramen.roundedimageview.RoundedImageView;
import com.orhanobut.logger.Logger;
import com.sportspage.App;
import com.sportspage.R;
import com.sportspage.adapter.FragmentPagerAdapter;
import com.sportspage.common.API;
import com.sportspage.common.BaseFragment;
import com.sportspage.common.Constants;
import com.sportspage.entity.MessageResult;
import com.sportspage.entity.SportDetailResult;
import com.sportspage.entity.SportResult;
import com.sportspage.fragment.detail.EventFragment;
import com.sportspage.fragment.detail.MessageFragment;
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

import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.rong.imkit.RongIM;
import io.rong.imlib.RongIMClient;
import io.rong.imlib.model.Conversation;
import io.rong.imlib.model.MessageContent;
import me.yokeyword.swipebackfragment.SwipeBackActivity;


@ContentView(R.layout.activity_sports_detail)
public class SportsDetailActivity extends SwipeBackActivity {

    private static final int REQUEST_SETTLE_OK = 200;
    private static final int REQUEST_APPRAISE_OK = 300;

    @ViewInject(R.id.stL_sports_detail)
    private SlidingTabLayout mTabLayout;
    @ViewInject(R.id.vp_sports_detail)
    private ViewPager mViewPager;
    @ViewInject(R.id.iv_sport_detail_title)
    private ImageView mTitleImg;
    @ViewInject(R.id.tv_sports_detail_title)
    private TextView mSportName;
    @ViewInject(R.id.iv_sports_detail_star)
    private ImageView mStar;
    @ViewInject(R.id.btn_sports_detail_focus)
    private Button mFocus;
    @ViewInject(R.id.tv_table_date)
    private TextView mDate;
    @ViewInject(R.id.tv_table_time)
    private TextView mTime;
    @ViewInject(R.id.tv_table_money)
    private TextView mMoney;
    @ViewInject(R.id.tv_table_enroll)
    private TextView mTypeAndStatus;
    @ViewInject(R.id.tv_location_describe)
    private TextView mPlace;
    @ViewInject(R.id.tv_location_address)
    private TextView mAddress;
    @ViewInject(R.id.tv_location_creator)
    private TextView mCreator;
    @ViewInject(R.id.tv_location_enrollor)
    private TextView mNoOneEnroll;
    @ViewInject(R.id.ll_sports_detail_img)
    private LinearLayout mEnrollerHead;
    @ViewInject(R.id.rv_sports_detail_enrollor1)
    private RoundedImageView mEnrollor1;
    @ViewInject(R.id.rv_sports_detail_enrollor2)
    private RoundedImageView mEnrollor2;
    @ViewInject(R.id.rv_sports_detail_enrollor3)
    private RoundedImageView mEnrollor3;
    @ViewInject(R.id.rv_sports_detail_enrollor4)
    private RoundedImageView mEnrollor4;
    @ViewInject(R.id.ll_sports_detail_map)
    private LinearLayout mMapLayout;
    @ViewInject(R.id.ll_sports_detail_phone)
    private LinearLayout mPhoneLayout;
    @ViewInject(R.id.ll_sports_detail_more)
    private LinearLayout mMoreLayout;
    @ViewInject(R.id.tv_sports_detail_num)
    private TextView mEnrollerNum;
    @ViewInject(R.id.tv_sports_detail_order)
    private TextView mOrderText;
    @ViewInject(R.id.ll_sports_detail_order)
    private LinearLayout mOrderLayout;
    @ViewInject(R.id.ll_sports_detail_table)
    private LinearLayout mTableLayout;
    @ViewInject(R.id.ll_sports_detail_enrollor)
    private LinearLayout mEnrollerLayout;
    @ViewInject(R.id.iv_sports_detail_more)
    private ImageView mSetting;
    @ViewInject(R.id.ll_sports_detail_bottom)
    private LinearLayout mBottomLayout;
    @ViewInject(R.id.ll_sports_detail_item)
    private LinearLayout mItemLayout;
    @ViewInject(R.id.activity_sports_detail)
    private RelativeLayout mParentLayout;
    @ViewInject(R.id.ll_sports_detail_active)
    private LinearLayout mActiveLayout;
    @ViewInject(R.id.tv_sports_detail_item)
    private TextView mItemName;
    @ViewInject(R.id.iv_sports_detail_itemImg)
    private ImageView mItemImg;
    @ViewInject(R.id.tv_sports_detail_active_times)
    private TextView mActiveTimes;
    @ViewInject(R.id.et_sports_detail_message)
    private EditText mMessage;
    @ViewInject(R.id.ll_message)
    private LinearLayout mMessageLayout;
    @ViewInject(R.id.rl_sportsdetail_title)
    private AutoRelativeLayout mTitleLayout;
    @ViewInject(R.id.scrollView)
    private XScrollView mScrollView;


    private SportDetailResult mDetailResult;
    private SportResult mSportResult;
    private ArrayList<BaseFragment> mFagments = new ArrayList<>();
    private String[] mTitles = {"活动详情", "留言"};
    private FragmentPagerAdapter adapter;
    private EventFragment mEventFragment = new EventFragment();
    private MessageFragment mMessageFragment = new MessageFragment();
    private int mType = Constants.EVENT_TYPE;
    private static final int REQUEST_CODE_PHONE = 7000;
    private Tencent mTencent;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        scrollChangeTitle();
        mTencent = Tencent.createInstance(Constants.QQ_APP_ID, this);
        mType = getIntent().getIntExtra("type", Constants.EVENT_TYPE);
        if (mType == Constants.SPORT_TYPE) {
//            getSportData();
            mFagments.add(mEventFragment);
            String[] titles = {"活动详情"};
            adapter = new FragmentPagerAdapter(getSupportFragmentManager(), mFagments, titles);
            mViewPager.setAdapter(adapter);
            mTabLayout.setViewPager(mViewPager, titles);
            mParentLayout.setBackgroundColor(getResources().getColor(R.color.white));
            mBottomLayout.setVisibility(View.GONE);
            mTableLayout.setVisibility(View.GONE);
            mEnrollerLayout.setVisibility(View.GONE);
//            mSetting.setVisibility(View.GONE);
            mItemLayout.setVisibility(View.VISIBLE);
            mActiveLayout.setVisibility(View.VISIBLE);
        } else {
//            getDetailData();
            mFagments.add(mEventFragment);
            mFagments.add(mMessageFragment);
            adapter = new FragmentPagerAdapter(getSupportFragmentManager(), mFagments, mTitles);
            mViewPager.setAdapter(adapter);
            mTabLayout.setViewPager(mViewPager, mTitles);
        }
    }

    private void scrollChangeTitle() {
        mScrollView.setScrollViewListener(new XScrollView.ScrollViewListener() {
            @Override
            public void onScrollChanged(XScrollView scrollView, int x, int y, int oldx, int oldy) {
                if (y>88){
                    mTitleLayout.setBackgroundColor(getResources().getColor(R.color.bar_color));
                } else {
                    Utils.setBackground(SportsDetailActivity.this,mTitleLayout,R.drawable.nav_shadow);
                }
            }
        });
    }

    private void getSportData() {
        String sportId = getIntent().getStringExtra("sportId");
        if (sportId == null || sportId.isEmpty()) {
            Utils.showShortToast(this, "数据错误，请刷新后重试");
            finish();
            return;
        }
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("sportId", sportId);
        map.put("userId", userId);
        Xutils.getInstance(this).get(API.GET_SPORT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                mSportResult = Utils.parseJsonWithGson(result, SportResult.class);
                setSportData();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    private void setSportData() {
        LogicUtils.loadImageFromUrl(mTitleImg, mSportResult.getPortrait());
        mSportName.setText(mSportResult.getTitle());
        mStar.setImageResource(LogicUtils.getStarId(mSportResult.getGrade()));
        if (mSportResult.isAttetion()) {
            mFocus.setText("已关注");
            mFocus.setBackgroundColor(getResources().getColor(R.color.gray));
            mFocus.setEnabled(false);
        }
        mPlace.setText("地点描述:" + mSportResult.getPlace());
        mAddress.setText(mSportResult.getLocation());
        mCreator.setText(mSportResult.getUser_id().getNick());
        mItemName.setText(LogicUtils.getType(mSportResult.getSport_item()));
        mItemImg.setImageResource(LogicUtils.getTypeId(mSportResult.getSport_item()));
        if (!mSportResult.getActive_times().equals("0")) {
            mActiveTimes.setText("(已激活" + mSportResult.getActive_times() + "次)");
        }
        String userId = Utils.getValue(this, "userId");
        if (!mSportResult.getUser_id().getId().equals(userId)) {
            mActiveLayout.setVisibility(View.GONE);
        }
        if (!mSportResult.getSummary().isEmpty()) {
            mEventFragment.setDescribe(mSportResult.getSummary());
        }
    }

    private void getDetailData() {
        String eventId = getIntent().getStringExtra("eventId");
        if (eventId == null || eventId.isEmpty()) {
            Utils.showShortToast(this, "数据错误，请刷新后重试");
            finish();
            return;
        }
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("eventId", eventId);
        map.put("userId", userId);
        Xutils.getInstance(this).get(API.GET_EVENT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                mDetailResult = Utils.parseJsonWithGson(result, SportDetailResult.class);
                setDetailData();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    private void setDetailData() {
        LogicUtils.loadImageFromUrl(mTitleImg, mDetailResult.getPortrait());
        mMessageFragment.setmDatas(mDetailResult.get_message());
        mSportName.setText(mDetailResult.getTitle());
        mStar.setImageResource(LogicUtils.getStarId(mDetailResult.getGrade()));
        if (mDetailResult.isAttetion()) {
            mFocus.setText("已关注");
            mFocus.setBackgroundColor(getResources().getColor(R.color.gray));
            mFocus.setEnabled(false);
        }
        mDate.setText(DateUtils.getFormatTime(mDetailResult.getStart_time(), "EEEE")
                + "\n" + DateUtils.getFormatTime(mDetailResult.getStart_time(), "MM月dd日"));

        mTime.setText(DateUtils.getFormatTime(mDetailResult.getStart_time(), "HH:mm")
                + "\n至" + DateUtils.getFormatTime(mDetailResult.getEnd_time(), "HH:mm"));

        mMoney.setText(mDetailResult.getPrice() + "元/人\n" + (mDetailResult
                .getCharge_type().equals("1") ? "线上支付" : "线下支付"));

        mTypeAndStatus.setText(LogicUtils.getType(mDetailResult.getSport_item())
                + "\n" + LogicUtils.getStatus(mDetailResult.getStatus()));

        mPlace.setText("地点描述:" + mDetailResult.getPlace());
        mAddress.setText(mDetailResult.getLocation());
        mCreator.setText(mDetailResult.getUser().getNick());
        if (mDetailResult.get_enroll_user() == null || mDetailResult.get_enroll_user().size() == 0) {
            mEnrollerNum.setText("已报名(" + 0 + "/" + mDetailResult.getMax_number() + ")");
            mNoOneEnroll.setVisibility(View.VISIBLE);
            mEnrollerHead.setVisibility(View.GONE);
        } else {
            int num = mDetailResult.get_enroll_user().size();
            mEnrollerNum.setText("已报名(" + num + "/" + mDetailResult.getMax_number() + ")");
            mNoOneEnroll.setVisibility(View.GONE);
            mEnrollerHead.setVisibility(View.VISIBLE);
            switch (num) {
                case 1:
                    LogicUtils.loadImageFromUrl(mEnrollor1,
                            mDetailResult.get_enroll_user().get(0).getPortrait());
                    mEnrollor2.setVisibility(View.GONE);
                    mEnrollor3.setVisibility(View.GONE);
                    mEnrollor4.setVisibility(View.GONE);
                    break;
                case 2:
                    LogicUtils.loadImageFromUrl(mEnrollor1,
                            mDetailResult.get_enroll_user().get(0).getPortrait());
                    LogicUtils.loadImageFromUrl(mEnrollor2,
                            mDetailResult.get_enroll_user().get(1).getPortrait());
                    mEnrollor3.setVisibility(View.GONE);
                    mEnrollor4.setVisibility(View.GONE);
                    break;
                case 3:
                    LogicUtils.loadImageFromUrl(mEnrollor1,
                            mDetailResult.get_enroll_user().get(0).getPortrait());
                    LogicUtils.loadImageFromUrl(mEnrollor2,
                            mDetailResult.get_enroll_user().get(1).getPortrait());
                    LogicUtils.loadImageFromUrl(mEnrollor3,
                            mDetailResult.get_enroll_user().get(2).getPortrait());
                    mEnrollor4.setVisibility(View.GONE);
                    break;
                case 4:
                    LogicUtils.loadImageFromUrl(mEnrollor1,
                            mDetailResult.get_enroll_user().get(0).getPortrait());
                    LogicUtils.loadImageFromUrl(mEnrollor2,
                            mDetailResult.get_enroll_user().get(1).getPortrait());
                    LogicUtils.loadImageFromUrl(mEnrollor3,
                            mDetailResult.get_enroll_user().get(2).getPortrait());
                    LogicUtils.loadImageFromUrl(mEnrollor4,
                            mDetailResult.get_enroll_user().get(3).getPortrait());
                    break;
                default:
                    LogicUtils.loadImageFromUrl(mEnrollor1,
                            mDetailResult.get_enroll_user().get(0).getPortrait());
                    LogicUtils.loadImageFromUrl(mEnrollor2,
                            mDetailResult.get_enroll_user().get(1).getPortrait());
                    LogicUtils.loadImageFromUrl(mEnrollor3,
                            mDetailResult.get_enroll_user().get(2).getPortrait());
                    LogicUtils.loadImageFromUrl(mEnrollor4,
                            mDetailResult.get_enroll_user().get(3).getPortrait());
            }
        }
        setOrderBtnText();
        if (!mDetailResult.getSummary().isEmpty()){
            mEventFragment.setDescribe(mDetailResult.getSummary());
        }
    }

    private void setOrderBtnText() {
        switch (mDetailResult.getUser_status()) {
            case "已报名":
            case "已评价":
            case "已结束":
            case "已取消":
            case "进行中":
                mOrderLayout.setBackgroundColor(getResources().getColor(R.color.gray));
                mOrderLayout.setEnabled(false);
                break;
            default:
                break;
        }
        if ("进行中".equals(mDetailResult.getUser_status())) {
            mOrderText.setText("待发起人结算");
        } else {
            mOrderText.setText(mDetailResult.getUser_status());
        }
    }

    @Event(R.id.ll_sports_detail_map)
    private void openMap(View v) {
        String latitude = "999";
        String longitude = "999";
        BottomSheet bottomSheet = new BottomSheet.Builder(this)
                .title("选择地图")
                .listener(new MenuItem.OnMenuItemClickListener() {
                    @Override
                    public boolean onMenuItemClick(MenuItem item) {
                        if (item.getTitle().equals("百度地图")){
                            baiduMap();
                        }else if(item.getTitle().equals("高德地图")){
                            amap();
                        }
                        return true;
                    }
                }).build();
        if (Utils.isAvilible(this, "com.baidu.BaiduMap")) {//传入指定应用包名
            bottomSheet.getMenu().add("百度地图");
        }
        if (Utils.isAvilible(this, "com.autonavi.minimap")) {
           bottomSheet.getMenu().add("高德地图");
        }
        bottomSheet.show();
        bottomSheet.invalidate();
    }
    private void baiduMap() {
        String latitude = "999";
        String longitude = "999";
        Intent intent = new Intent();
        if (mType == Constants.SPORT_TYPE) {
            latitude = mSportResult.getLatitude();
            longitude = mSportResult.getLongitude();

        } else {
            latitude = mDetailResult.getLatitude();
            longitude = mDetailResult.getLongitude();
        }
        intent.setData(Uri.parse("baidumap://map/direction?region=shanghai"
                + "&destination="
                + latitude + ","
                + longitude
                + "&mode=driving"));
        startActivity(intent); //启动调用
    }

    private void amap() {
        String latitude = "999";
        String longitude = "999";
        Intent intent = new Intent();
        if (mType == Constants.SPORT_TYPE) {
            latitude = mSportResult.getLatitude();
            longitude = mSportResult.getLongitude();

        } else {
            latitude = mDetailResult.getLatitude();
            longitude = mDetailResult.getLongitude();
        }
        intent.setAction(Intent.ACTION_VIEW);
        intent.addCategory(Intent.CATEGORY_DEFAULT);
        Uri uri = Uri.parse("androidamap://navi?sourceApplication=sportspage"
                + "&lat="+latitude + "&lon="+longitude+"&dev=1&style=0");
        intent.setData(uri);
        startActivity(intent);
    }


    @Event(R.id.ll_sports_detail_phone)
    private void callCreator(View v) {
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_DIAL);
        //url:统一资源定位符
        //uri:统一资源标示符（更广）
        if (mType == Constants.SPORT_TYPE) {
            intent.setData(Uri.parse("tel:" + mSportResult.getUser_id().getMobile()));
        } else {
            intent.setData(Uri.parse("tel:" + mDetailResult.getUser().getMobile()));
        }
        //开启系统拨号器
        startActivity(intent);
    }

    @Event(R.id.ll_sports_detail_more)
    private void viewMore(View v) {
        Gson gson = new Gson();
        Intent intent = new Intent();
        intent.putExtra("creator", gson.toJson(mDetailResult.getUser()));
        intent.putExtra("enroll_user", new Gson().toJson(mDetailResult.get_enroll_user()));
        intent.putExtra("relation", mDetailResult.getRelation());
        intent.setClass(this, EnrollUserActivity.class);
        Utils.start_Activity(this, intent);
    }


    @Event(R.id.ll_sports_detail_order)
    private void orderBtnClick(View v) {
        switch (mOrderText.getText().toString()) {
            case "报名":
                goOrder();
                break;
            case "去评价":
                goAppraise();
                break;
            case "锁定":
                lock();
                break;
            case "解锁":
                unlock();
                break;
            case "结算":
                goSettle();
                break;
            default:
                break;
        }
    }

    private void goSettle() {
        Intent intent = new Intent();
        intent.putExtra("eventId", mDetailResult.getEvent_id());
        intent.putExtra("sportName", mSportName.getText().toString());
        intent.putExtra("date", DateUtils.getFormatTime(mDetailResult.getStart_time(), "yyyy-MM-dd"));
        intent.putExtra("time", DateUtils.getFormatTime(mDetailResult.getStart_time(), "HH-mm-ss") + "-"
                + DateUtils.getFormatTime(mDetailResult.getEnd_time(), "HH-mm-ss"));
        intent.putExtra("location", mDetailResult.getLocation());
        intent.putExtra("pay", mDetailResult.getCharge_type().equals("1") ? "线上" : "线下");
        intent.putExtra("money", mDetailResult.getPrice());
        intent.putExtra("creater", mDetailResult.getUser().getNick());
        intent.putExtra("num", mDetailResult.get_enroll_user().size() + "");
        if (mDetailResult.getCharge_type().equals("1")) {
            intent.putExtra("all", (mDetailResult.get_enroll_user().size()
                    * (int) Float.parseFloat(mDetailResult.getPrice())) + "");
        } else {
            intent.putExtra("all", "0");
        }

        intent.setClass(this, SettleActivity.class);
        Utils.startAcitivityForResult(this, intent, REQUEST_SETTLE_OK);
    }

    private void unlock() {
        String userId = Utils.getValue(this, "userId");
        String eventId = getIntent().getStringExtra("eventId");
        if (eventId == null || eventId.isEmpty()) {
            Utils.showShortToast(this, "数据错误，请刷新后重试");
            finish();
            return;
        }
        Map<String, String> map = new HashMap<>();
        map.put("eventId", eventId);
        map.put("userId", userId);
        Xutils.getInstance(this).get(API.UNLOCK, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(), "解锁成功");
                mOrderText.setText("锁定");
            }

            @Override
            public void onFinished() {

            }
        });
    }

    private void lock() {
        String userId = Utils.getValue(this, "userId");
        String eventId = getIntent().getStringExtra("eventId");
        if (eventId == null || eventId.isEmpty()) {
            Utils.showShortToast(this, "数据错误，请刷新后重试");
            finish();
            return;
        }
        Map<String, String> map = new HashMap<>();
        map.put("eventId", eventId);
        map.put("userId", userId);
        Xutils.getInstance(this).get(API.LOCK, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(), "锁定成功");
                mOrderText.setText("解锁");
            }

            @Override
            public void onFinished() {

            }
        });
    }

    private void goAppraise() {
        Intent intent = new Intent();
        intent.putExtra("imageData", Utils.drawableToByteArray(mTitleImg.getDrawable()));
        intent.putExtra("sportName", mSportName.getText().toString());
        intent.putExtra("address", mDetailResult.getLocation());
        intent.putExtra("time", mDetailResult.getStart_time());
        intent.putExtra("creator", mDetailResult.getUser().getNick());
        intent.putExtra("eventId", mDetailResult.getEvent_id());
        intent.setClass(this, AppraiseActivity.class);
        Utils.startAcitivityForResult(this, intent, REQUEST_APPRAISE_OK);
    }

    private void goOrder() {
        if (Utils.getValue(this, "mobile").isEmpty()) {
            Intent intent = new Intent();
            intent.setClass(this, PerfectinformationActivity.class);
            Utils.startAcitivityForResult(this, intent, REQUEST_CODE_PHONE);
        } else {
            oreder();
        }
    }

    private void oreder() {
        Intent intent = new Intent();
        intent.putExtra("eventId", mDetailResult.getEvent_id());
        intent.putExtra("sportName", mSportName.getText().toString());
        intent.putExtra("date", DateUtils.getFormatTime(mDetailResult.getStart_time(), "yyyy-MM-dd"));
        intent.putExtra("time", DateUtils.getFormatTime(mDetailResult.getStart_time(), "HH:mm:ss") + "-"
                + DateUtils.getFormatTime(mDetailResult.getEnd_time(), "HH-mm-ss"));
        intent.putExtra("location", mDetailResult.getLocation());
        intent.putExtra("pay", mDetailResult.getCharge_type().equals("1") ? "线上" : "线下");
        intent.putExtra("money", mDetailResult.getPrice());
        intent.putExtra("creater", mDetailResult.getUser().getNick());
        intent.setClass(this, OrderActivity.class);
        Utils.start_Activity(this, intent);
    }

    @Event(R.id.ll_sports_detail_share)
    private void share(View v) {
        WXWebpageObject webpage = new WXWebpageObject();
        webpage.webpageUrl = getShareH5Url();
        WXMediaMessage msg = new WXMediaMessage(webpage);
        msg.title = mDetailResult.getTitle();
        msg.description = DateUtils.getFormatTime(mDetailResult.getStart_time(), "yyyy-MM-dd hh:mm")
                + " " + mDetailResult.getLocation();
        if (mTitleImg.getDrawable() != null) {
            Bitmap thumb = Utils.drawableToBitmap(mTitleImg.getDrawable());
            Bitmap thumbBitmap = Bitmap.createScaledBitmap(thumb, 50, 50, true);
            msg.thumbData = Utils.bmpToByteArray(thumbBitmap, true);
        }
        final SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = Utils.buildTransaction("webpage");
        req.message = msg;
        new BottomSheet.Builder(this,R.style.BottomSheet_StyleDialog).title("分享运动页到")
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
                            case R.id.sportspage:
                                Intent intent = new Intent();
                                intent.putExtra("imageUrl", mDetailResult.getPortrait());
                                intent.putExtra("content", mDetailResult.getStart_time()
                                        + "\n" + mDetailResult.getLocation());
                                intent.putExtra("eventId", mDetailResult.getEvent_id());
                                intent.putExtra("shareTitle", mDetailResult.getTitle());
                                intent.setClass(SportsDetailActivity.this, ShareActivity.class);
                                Utils.start_Activity(SportsDetailActivity.this, intent);
                                break;
                            case R.id.qq:
                                shareToQQ();
                                break;
                            case R.id.qzone:
                                shareToQzone();
                                break;
                        }
                    }
                }).grid().show();
    }

    public void shareToQQ()
    {
        final Bundle params = new Bundle();
        params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_DEFAULT);
        params.putString(QQShare.SHARE_TO_QQ_TITLE, mDetailResult.getTitle());
        params.putString(QQShare.SHARE_TO_QQ_SUMMARY,  mDetailResult.getStart_time()
                + "\n" + mDetailResult.getLocation());
        params.putString(QQShare.SHARE_TO_QQ_TARGET_URL,  getShareH5Url());
        params.putString(QQShare.SHARE_TO_QQ_IMAGE_URL,mDetailResult.getPortrait());
        params.putString(QQShare.SHARE_TO_QQ_APP_NAME,  "运动页");
        params.putInt(QQShare.SHARE_TO_QQ_EXT_INT,  11);
        mTencent.shareToQQ(this, params, mUiListener);
    }


    private void shareToQzone () {
        Bundle params = new Bundle();
        ArrayList<String> imageList= new ArrayList<>();
        imageList.add(mDetailResult.getPortrait());
        params.putInt(QzoneShare.SHARE_TO_QZONE_KEY_TYPE,QzoneShare.SHARE_TO_QZONE_TYPE_IMAGE_TEXT );
        params.putString(QzoneShare.SHARE_TO_QQ_TITLE, mDetailResult.getTitle());//必填
        params.putString(QzoneShare.SHARE_TO_QQ_SUMMARY,  mDetailResult.getStart_time()
                + "\n" + mDetailResult.getLocation());//选填
        params.putString(QzoneShare.SHARE_TO_QQ_TARGET_URL, getShareH5Url());//必填
        params.putStringArrayList(QzoneShare.SHARE_TO_QQ_IMAGE_URL, imageList);
        mTencent.shareToQzone(this, params, mUiListener);
    }

    @Event(R.id.ll_sports_detail_message)
    private void message(View v) {
        mMessageLayout.setVisibility(View.VISIBLE);
        mMessage.requestFocus();
        InputMethodManager inputManager = (InputMethodManager) mMessage.getContext()
                .getSystemService(Context.INPUT_METHOD_SERVICE);
        inputManager.showSoftInput(mMessage, 0);

    }

    @Event(R.id.btn_message)
    private void goMessage(View v) {
        if (mMessage.getText().toString().isEmpty()){
            Utils.showShortToast(x.app(),"请输入留言");
            return;
        }
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("eventId", mDetailResult.getEvent_id());
        map.put("content", mMessage.getText().toString());
        Xutils.getInstance(this).post(API.POST_MESSAGE, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(), "留言成功");
                MessageResult messageResult = new MessageResult();
                messageResult.setNick(Utils.getValue(x.app(), "nick"));
                messageResult.setPortrait(Utils.getValue(x.app(), "portrait"));
                messageResult.setContent(mMessage.getText().toString());
                mMessageFragment.addData(messageResult);
                mMessageLayout.setVisibility(View.GONE);
                Utils.hideKeyBoard();
            }

            @Override
            public void onFinished() {

            }
        });

    }

    private String getShareH5Url() {
        return "http://www.sportspage.cn/index.php/Share/eventDetail?type=1" +
                "&eventId=" + mDetailResult.getEvent_id();
    }

    @Event(R.id.btn_sports_detail_focus)
    private void goFocus(View v) {
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        if (mType == Constants.SPORT_TYPE) {
            map.put("sportId", mSportResult.getId());
        } else {
            map.put("sportId", mDetailResult.getId());
        }
        map.put("userId", userId);
        Xutils.getInstance(this).post(API.FOLLOW, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(), "关注成功");
                mFocus.setText("已关注");
                mFocus.setBackgroundColor(getResources().getColor(R.color.gray));
                mFocus.setEnabled(false);
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(R.id.ll_sports_detail_active)
    private void goActive(View v) {
        Intent intent = new Intent();
        intent.putExtra("path", mSportResult.getPortrait());
        intent.putExtra("sportName", mSportName.getText().toString());
        intent.putExtra("location", mSportResult.getLocation());
        intent.putExtra("address", mSportResult.getPlace());
        intent.putExtra("sportType", mItemName.getText().toString());
        intent.putExtra("sportId", mSportResult.getId());
        intent.putExtra("describe", mSportResult.getSummary());
        intent.setClass(this, CreatNextActivity.class);
        Utils.start_Activity(this, intent);
    }

    @Event(R.id.iv_sports_detail_back)
    private void goBack(View v) {
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

    @Event(R.id.iv_sports_detail_more)
    private void setting(View v) {
        BottomSheet bottomSheet = new BottomSheet.Builder(this).title("操作")
                .sheet(R.menu.detail_set_list).listener(new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        switch (which) {
                            case R.id.outevent:
                                outEvent();
                                break;
                            case R.id.dismiss:
                                dismissEvent();
                                break;
                            case R.id.setting:
                                sportspageSetting();
                            case R.id.cancel:
                                break;
                        }
                    }
                }).build();
        String userId = Utils.getValue(this, "userId");
        if (mType == Constants.EVENT_TYPE) {
            if (userId.equals(mDetailResult.getUser().getId())) {
                bottomSheet.getMenu().removeItem(R.id.outevent);
            } else {
                bottomSheet.getMenu().removeItem(R.id.dismiss);
            }
            bottomSheet.getMenu().removeItem(R.id.setting);
            bottomSheet.show();
            bottomSheet.invalidate();
        }
//        else {
//            bottomSheet.getMenu().removeItem(R.id.outevent);
//            bottomSheet.getMenu().removeItem(R.id.dismiss);
//            bottomSheet.show();
//            bottomSheet.invalidate();
//        }
    }

    private void sportspageSetting() {
        Intent intent = new Intent();
        intent.putExtra("id",mSportResult.getId());
        intent.putExtra("imageUrl",mSportResult.getPortrait());
        intent.putExtra("name",mSportResult.getTitle());
        intent.putExtra("desc",mSportResult.getSummary());
        intent.setClass(this,ChangeSportsPageActivity.class);
        Utils.start_Activity(this,intent);
    }

    private void dismissEvent() {
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("eventId", mDetailResult.getEvent_id());
        Xutils.getInstance(this).post(API.DISMISS_EVENT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showLongToast(x.app(), "解散成功");
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    private void outEvent() {
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("eventId", mDetailResult.getEvent_id());
        Xutils.getInstance(this).post(API.EXIT_EVENT, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showLongToast(x.app(), "退出成功");
                finish();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == com.tencent.connect.common.Constants.REQUEST_QQ_SHARE ||
                requestCode == com.tencent.connect.common.Constants.REQUEST_QZONE_SHARE) {
            Tencent.onActivityResultData(requestCode, resultCode, data, mUiListener);
        } else {
            if (resultCode == RESULT_OK) {
                switch (requestCode) {
                    case REQUEST_CODE_PHONE:
                        oreder();
                        break;
                    case REQUEST_APPRAISE_OK:
                        mOrderText.setText("已评价");
                        mOrderLayout.setBackgroundColor(getResources().getColor(R.color.gray));
                        mOrderLayout.setEnabled(false);
                        break;
                    case REQUEST_SETTLE_OK:
                        mOrderText.setText("已结算");
                        mOrderLayout.setBackgroundColor(getResources().getColor(R.color.gray));
                        mOrderLayout.setEnabled(false);
                        break;
                }
            }
        }
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

    @Event(R.id.rl_sportsdetail_title)
    private void clickTitle(View view) {
        mScrollView.smoothScrollTo(0,0);
    }

}
