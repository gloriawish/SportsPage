package com.sportspage.activity;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.cocosw.bottomsheet.BottomSheet;
import com.google.gson.Gson;
import com.orhanobut.logger.Logger;
import com.sportspage.App;
import com.sportspage.R;
import com.sportspage.adapter.ClubMemberAdapter;
import com.sportspage.adapter.ClubTrendAdapter;
import com.sportspage.adapter.BindedSportsPageAdapter;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.entity.ClubDetailResult;
import com.sportspage.event.ClubBindSportsPageEvent;
import com.sportspage.event.ClubJoinWayEvent;
import com.sportspage.event.PublishNoticeEvent;
import com.sportspage.event.UpdateBadgeEvent;
import com.sportspage.event.UpdateClubNameEvent;
import com.sportspage.event.UpdateClubSportItemEvent;
import com.sportspage.event.UpdateCoverEvent;
import com.sportspage.utils.DateUtils;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;
import com.sportspage.view.BindSportsPageView;
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
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.rong.imkit.RongIM;
import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_club)
public class ClubActivity extends SwipeBackActivity implements
        BindedSportsPageAdapter.OnBindSportsPageClickListener {

    @ViewInject(R.id.rv_club_member)
    private RecyclerView mMemberView;
    @ViewInject(R.id.welfare_view1)
    private BindSportsPageView mBindSportsPageView;
    @ViewInject(R.id.rv_club_trend)
    private RecyclerView mTrendView;
    @ViewInject(R.id.iv_club_more)
    private ImageView mSettingView;
    @ViewInject(R.id.iv_club_cover)
    private ImageView mClubCover;
    @ViewInject(R.id.iv_club_badge)
    private ImageView mClubBadge;
    @ViewInject(R.id.tv_club_name)
    private TextView mClubName;
    @ViewInject(R.id.tv_club_level)
    private TextView mClubLevel;
    @ViewInject(R.id.tv_club_notice)
    private TextView mClubNotice;
    @ViewInject(R.id.tv_club_vitality)
    private TextView mVitality;
    @ViewInject(R.id.pb_club_vitality)
    private ProgressBar mVitalityBar;
    @ViewInject(R.id.iv_club_fight_club_a)
    private ImageView mClubABadge;
    @ViewInject(R.id.iv_club_fight_club_b)
    private ImageView mClubBBadge;
    @ViewInject(R.id.tv_club_fight_club_a)
    private TextView mClubAName;
    @ViewInject(R.id.tv_club_fight_club_b)
    private TextView mClubBName;
    @ViewInject(R.id.tv_club_fight_time)
    private TextView mFightTime;
    @ViewInject(R.id.tv_link_text)
    private TextView mLinkText;
    @ViewInject(R.id.iv_link_more)
    private ImageView mLinkMore;
    @ViewInject(R.id.ll_club_sp_layout)
    private LinearLayout mSportspageLayout;
    @ViewInject(R.id.btn_club_join)
    private Button mJoinBtn;
    @ViewInject(R.id.scrollView)
    private XScrollView mScrollView;
    @ViewInject(R.id.rl_club_title)
    private AutoRelativeLayout mTitleLayout;

    private ClubDetailResult mClubDetailResult;

    private String mClubId;
    private Tencent mTencent;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
        initData();
    }

    private void init() {
        scrollChangeTitle();
        mTencent = Tencent.createInstance(Constants.QQ_APP_ID, this);
        EventBus.getDefault().register(this);
        LinearLayoutManager memBerLinearManager = new LinearLayoutManager(this);
        memBerLinearManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        mMemberView.setLayoutManager(memBerLinearManager);
        LinearLayoutManager trendLinearManager = new LinearLayoutManager(this);
        trendLinearManager.setOrientation(LinearLayoutManager.VERTICAL);
        mTrendView.setLayoutManager(trendLinearManager);
    }

    private void initData() {
        mClubId = getIntent().getStringExtra("clubId");
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("clubId", mClubId);
        Xutils.getInstance(this).get(API.GET_CLUB_DETAIL, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                setData(result);
            }

            @Override
            public void onFinished() {

            }
        });
    }


    private void scrollChangeTitle() {
        mScrollView.setScrollViewListener(new XScrollView.ScrollViewListener() {
            @Override
            public void onScrollChanged(XScrollView scrollView, int x, int y, int oldx, int oldy) {
            if (y > 88) {
                mTitleLayout.setBackgroundColor(getResources().getColor(R.color.bar_color));
            } else {
                Utils.setBackground(ClubActivity.this, mTitleLayout, R.drawable.nav_shadow);
            }
            }
        });
    }

    private void setData(String result) {
        mClubDetailResult = Utils.parseJsonWithGson(result, ClubDetailResult.class);
        Glide.with(ClubActivity.this).load(mClubDetailResult.getPortrait()).into(mClubCover);
        Glide.with(ClubActivity.this).load(mClubDetailResult.getIcon()).into(mClubBadge);
        mClubName.setText(mClubDetailResult.getName());
        if (mClubDetailResult.getLevel() == null || mClubDetailResult.getLevel().isEmpty()) {
            mClubLevel.setText("等级: Lv1");
        } else {
            mClubLevel.setText("等级: Lv" + mClubDetailResult.getLevel());
        }
        if (mClubDetailResult.getAnn() == null || mClubDetailResult.getAnn().getContent() == null) {
            mClubNotice.setText("暂无公告");
        } else {
            mClubNotice.setText(mClubDetailResult.getAnn().getContent());
        }
        mMemberView.setAdapter(new ClubMemberAdapter(this, mClubDetailResult.getTop_member()));
        if (mClubDetailResult.getSports().size() == 0) {
            mBindSportsPageView.setVisibility(View.GONE);
            mLinkText.setVisibility(View.VISIBLE);
            if (mClubDetailResult.getOp_permission() == 3) {
                mLinkMore.setVisibility(View.VISIBLE);
            } else {
                mLinkMore.setVisibility(View.INVISIBLE);
                mSportspageLayout.setEnabled(false);
            }
        } else {
            mBindSportsPageView.setSportsPageClickListener(this);
            mBindSportsPageView.setWelfareData(mClubDetailResult.getSports());
        }

        mTrendView.setAdapter(new ClubTrendAdapter(this, mClubDetailResult.getActives(),
                mClubDetailResult.getIcon()));
        Glide.with(this).load(mClubDetailResult.getIcon()).into(mClubABadge);
        mClubAName.setText(mClubDetailResult.getName());
        //// TODO: 3/16/17 B队伍赋值
        if (mClubDetailResult.getOp_permission() == 0 || mClubDetailResult.getOp_permission() == 1) {
            mSettingView.setVisibility(View.INVISIBLE);
        }
        if (mClubDetailResult.getOp_permission() != 0) {
            mJoinBtn.setText("打开聊天");
        }
        if (mClubDetailResult.getMax_vitality()!=null &&
                !mClubDetailResult.getMax_vitality().equals("")) {
            mVitality.setText(mClubDetailResult.getVitality()
                    + "/" + mClubDetailResult.getMax_vitality());
        }
        mVitalityBar.setProgress(Integer.parseInt(mClubDetailResult.getVitality()));
        mFightTime.setText(DateUtils.getFormatTime(new Date()));
    }

    @Event(R.id.iv_club_more)
    private void more(View v) {
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        Gson gson = new Gson();
        String members = gson.toJson(mClubDetailResult.getTop_member());
        bundle.putString("members", members);
        bundle.putString("membersCount", (Integer.parseInt(mClubDetailResult.getMember_count()) + 1) + "");
        bundle.putString("badge", mClubDetailResult.getIcon());
        bundle.putString("cover", mClubDetailResult.getPortrait());
        bundle.putString("name", mClubDetailResult.getName());
        bundle.putString("type", mClubDetailResult.getSport_item());
        bundle.putString("extend", mClubDetailResult.getSport_item_extend());
        bundle.putString("notice", mClubDetailResult.getAnn().getContent());
        bundle.putInt("permission", mClubDetailResult.getOp_permission());
        bundle.putString("clubId", mClubId);
        bundle.putString("joinType", mClubDetailResult.getJoin_type());
        intent.putExtra("data", bundle);
        intent.setClass(this, ClubSettingActivity.class);
        Utils.start_Activity(this, intent);
    }

    @Event(R.id.ll_share_club)
    private void goShare(View v) {
        WXWebpageObject webpage = new WXWebpageObject();
        webpage.webpageUrl = getShareH5Url();
        WXMediaMessage msg = new WXMediaMessage(webpage);
        msg.title = mClubDetailResult.getName();
        msg.description = "赶快来加入" + mClubDetailResult.getName() + "一起运动吧！";
        if (mClubBadge.getDrawable() != null) {
            Bitmap thumb = Utils.drawableToBitmap(mClubBadge.getDrawable());
            Bitmap thumbBitmap = Bitmap.createScaledBitmap(thumb, 50, 50, true);
            msg.thumbData = Utils.bmpToByteArray(thumbBitmap, true);
        }
        final SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = Utils.buildTransaction("webpage");
        req.message = msg;
        BottomSheet bottomSheet = new BottomSheet.Builder(this, R.style.BottomSheet_StyleDialog).title("分享到")
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
                                intent.putExtra("imageUrl", mClubDetailResult.getIcon());
                                intent.putExtra("content", "赶快来加入" + mClubDetailResult.getName() + "一起运动吧！");
                                intent.putExtra("clubId", mClubDetailResult.getId());
                                intent.putExtra("shareTitle", mClubDetailResult.getName());
                                intent.putExtra("type","club");
                                intent.setClass(ClubActivity.this, ShareActivity.class);
                                Utils.start_Activity(ClubActivity.this, intent);
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
        bottomSheet.getMenu().removeItem(R.id.friend);
        bottomSheet.getMenu().removeItem(R.id.dicover);
        bottomSheet.getMenu().removeItem(R.id.qq);
        bottomSheet.getMenu().removeItem(R.id.qzone);
        bottomSheet.show();
        bottomSheet.invalidate();
    }

    public void shareToQQ() {
        final Bundle params = new Bundle();
        params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_DEFAULT);
        params.putString(QQShare.SHARE_TO_QQ_TITLE, mClubDetailResult.getName());
        params.putString(QQShare.SHARE_TO_QQ_SUMMARY, "赶快来加入" + mClubDetailResult.getName() + "一起运动吧！");
        params.putString(QQShare.SHARE_TO_QQ_TARGET_URL, getShareH5Url());
        params.putString(QQShare.SHARE_TO_QQ_IMAGE_URL, mClubDetailResult.getIcon());
        params.putString(QQShare.SHARE_TO_QQ_APP_NAME, "运动页");
        params.putInt(QQShare.SHARE_TO_QQ_EXT_INT, 11);
        mTencent.shareToQQ(this, params, mUiListener);
    }


    private void shareToQzone() {
        Bundle params = new Bundle();
        ArrayList<String> imageList = new ArrayList<>();
        imageList.add(mClubDetailResult.getIcon());
        params.putInt(QzoneShare.SHARE_TO_QZONE_KEY_TYPE, QzoneShare.SHARE_TO_QZONE_TYPE_IMAGE_TEXT);
        params.putString(QzoneShare.SHARE_TO_QQ_TITLE, mClubDetailResult.getName());//必填
        params.putString(QzoneShare.SHARE_TO_QQ_SUMMARY, "赶快来加入" + mClubDetailResult.getName() + "一起运动吧！");//选填
        params.putString(QzoneShare.SHARE_TO_QQ_TARGET_URL, getShareH5Url());//必填
        params.putStringArrayList(QzoneShare.SHARE_TO_QQ_IMAGE_URL, imageList);
        mTencent.shareToQzone(this, params, mUiListener);
    }

    private String getShareH5Url() {
//        return "http://www.sportspage.cn/index.php/Share/eventDetail?type=1" +
//                "&eventId=" + mDetailResult.getEvent_id();
        return "http://www.zk1201.com";
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


    @Event(R.id.iv_club_back)
    private void goBack(View v) {
        finish();
    }

    @Override
    public void finish() {
        super.finish();
        overridePendingTransition(R.anim.push_right_in, R.anim.push_right_out);
    }

    @Event(R.id.ll_club_member_layout)
    private void goViewMember(View v) {
        Intent intent = new Intent();
        intent.putExtra("clubId", mClubDetailResult.getId());
        intent.setClass(this, ClubMemberActivity.class);
        Utils.start_Activity(this, intent);
    }

    @Event(R.id.rl_club_bind_sp_layout)
    private void goBindSportspage(View v) {
        Intent intent = new Intent();
        intent.putExtra("permission",mClubDetailResult.getOp_permission());
        intent.putExtra("clubId", mClubDetailResult.getId());
        intent.setClass(this, ClubSportspageActivity.class);
        Utils.start_Activity(this, intent);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }

    @Subscribe
    public void onEventMainThread(UpdateCoverEvent event) {
        mClubCover.setImageBitmap(Utils.getBitmapFromPath(event.getPath()));
    }

    @Subscribe
    public void onEventMainThread(UpdateBadgeEvent event) {
        mClubBadge.setImageBitmap(Utils.getBitmapFromPath(event.getPath()));
        mClubABadge.setImageBitmap(Utils.getBitmapFromPath(event.getPath()));
    }

    @Subscribe
    public void onEventMainThread(UpdateClubNameEvent event) {
        mClubName.setText(event.getName());
    }


    @Override
    public void onBindSportsPageClick(int position) {
        List<ClubDetailResult.SportsBean> list = mClubDetailResult.getSports();
        Intent intent = new Intent();
        intent.putExtra("sportId",list.get(position).getId());
        intent.putExtra("eventId",list.get(position).getEvent_id());
        if(list.get(position).getStatus().equals("0")) {
            intent.putExtra("type", Constants.SPORT_TYPE);
        }
        intent.putExtra("describe",list.get(position).getSummary());
        intent.setClass(this, SportsDetailActivity.class);
        Utils.start_Activity(this, intent);
    }

    @Event(R.id.btn_club_join)
    private void joinClub(View view) {
        if (mClubDetailResult.getOp_permission() != 0) {
            RongIM.getInstance().startGroupChat(this,mClubDetailResult.group_id
                    ,mClubDetailResult.getName());
            return;
        }
        Map<String, String> map = new HashMap<>();
        map.put("userId", Utils.getValue(this, "userId"));
        map.put("clubId", mClubId);
        map.put("extend", "申请加入");
        Xutils.getInstance(this).post(API.APPLY_JOIN_CLUB, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                if (mClubDetailResult.getJoin_type().equals(Constants.JOIN_TYPE_NEED_CHECK)) {
                    Utils.showShortToast(x.app(), "请求已发送,等待管理员审核");
                } else {
                    Utils.showShortToast(x.app(), "加入成功");
                }
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(R.id.rl_club_title)
    private void clickTitle(View view) {
        mScrollView.smoothScrollTo(0, 0);
    }

    @Subscribe
    public void onEventMainThread(UpdateClubSportItemEvent event) {
        event.getItem();
    }

    @Subscribe
    public void onEventMainThread(PublishNoticeEvent event) {
        mClubNotice.setText("\u3000\u3000"+event.getContent());
    }

    @Subscribe
    public void onEventMainThread(ClubJoinWayEvent event) {
        mClubDetailResult.setJoin_type(event.getmWay());
    }

    @Subscribe
    public void onEventMainThread(ClubBindSportsPageEvent event) {
        initData();
    }
}
