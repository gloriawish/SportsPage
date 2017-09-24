package com.sportspage.activity;

import android.net.Uri;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.igexin.sdk.PushManager;
import com.orhanobut.logger.Logger;
import com.sportspage.App;
import com.sportspage.R;
import com.sportspage.event.CloseConversationEvent;
import com.sportspage.event.ClubBindSportsPageEvent;
import com.sportspage.fragment.ContactsFragment;
import com.sportspage.fragment.DicoverFragment;
import com.sportspage.fragment.MsgFragment;
import com.sportspage.fragment.ProfileFragment;
import com.sportspage.service.SPPushIntentService;
import com.sportspage.service.SPPushService;
import com.sportspage.utils.Utils;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.Timer;
import java.util.TimerTask;

import io.rong.imkit.RongIM;
import io.rong.imkit.manager.IUnReadMessageObserver;
import io.rong.imlib.model.Conversation;
import io.rong.imlib.model.UserInfo;
import me.yokeyword.fragmentation.SupportActivity;
import me.yokeyword.fragmentation.SupportFragment;

/**
 * 主页面
 */
@ContentView(R.layout.activity_main)
public class MainActivity extends SupportActivity implements IUnReadMessageObserver {
    @ViewInject(R.id.unread_msg_number)
    private TextView mUnReadMsg;
    @ViewInject(R.id.unread_address_number)
    private TextView mUnReadAddress;
    @ViewInject(R.id.unread_find_number)
    private TextView mUnReadFind;
    /**
     * fragment数组
     */
    private SupportFragment[] fragments;
    /**
     * 消息页面
     */
    private MsgFragment mMsgFragment;
    /**
     * 群组页面
     */
    private ContactsFragment mContactsFragment;
    /**
     * 发现页面
     */
    private DicoverFragment mDicoverFragment;
    /**
     * 设置页面
     */
    private ProfileFragment mProfileFragment;
    /**
     * 底部菜单图标
     */
    private ImageView[] mImageBtns;
    /**
     * 底部菜单文字
     */
    private TextView[] mTextviews;
    /**
     * 当前fragment的index
     */
    private int index;
    /**
     * 当前fragment的index
     */
    private int currentTabIndex;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        x.view().inject(this);
        EventBus.getDefault().register(this);
        mMsgFragment = new MsgFragment();
        mContactsFragment = new ContactsFragment();
        mDicoverFragment = new DicoverFragment();
        mProfileFragment = new ProfileFragment();
        fragments = new SupportFragment[]{mDicoverFragment, mMsgFragment,
                mContactsFragment, mProfileFragment};
        loadMultipleRootFragment(R.id.fragment_container, 0,
                fragments[0], fragments[1], fragments[2], fragments[3]);
        initTabView();
        App.getInstance().addActivity(this);
        PushManager.getInstance().initialize(this.getApplicationContext()
                , SPPushService.class);
        PushManager.getInstance().registerPushIntentService(this.getApplicationContext(),
                SPPushIntentService.class);

        RongIM.getInstance().addUnReadMessageCountChangedObserver(this
                , Conversation.ConversationType.SYSTEM
                , Conversation.ConversationType.PRIVATE
                , Conversation.ConversationType.GROUP);
    }

    private void initTabView() {
        mImageBtns = new ImageView[4];
        mImageBtns[0] = (ImageView) findViewById(R.id.ib_find);
        mImageBtns[1] = (ImageView) findViewById(R.id.ib_weixin);
        mImageBtns[2] = (ImageView) findViewById(R.id.ib_contact_list);
        mImageBtns[3] = (ImageView) findViewById(R.id.ib_profile);

        mImageBtns[0].setSelected(true);
        mTextviews = new TextView[4];
        mTextviews[0] = (TextView) findViewById(R.id.tv_find);
        mTextviews[1] = (TextView) findViewById(R.id.tv_weixin);
        mTextviews[2] = (TextView) findViewById(R.id.tv_contact_list);
        mTextviews[3] = (TextView) findViewById(R.id.tv_profile);
        mTextviews[0].setTextColor(0xff00aaff);

        String userId = Utils.getValue(this, "userId");
        String nick = Utils.getValue(this, "nick");
        String portrait = Utils.getValue(this, "portrait");
        UserInfo userInfo = new UserInfo(userId, nick, Uri.parse(portrait));
        RongIM.getInstance().setCurrentUserInfo(userInfo);
    }

    public void onTabClicked(View view) {
        switch (view.getId()) {
            case R.id.re_find:
                index = 0;
                break;
            case R.id.re_weixin:
                index = 1;
                break;
            case R.id.re_contact_list:
                index = 2;
                break;
            case R.id.re_profile:
                index = 3;
                break;
        }
        if (currentTabIndex != index) {
            showHideFragment(fragments[index], fragments[currentTabIndex]);
        }
        mImageBtns[currentTabIndex].setSelected(false);
        // 把当前tab设为选中状态
        mImageBtns[index].setSelected(true);
        mTextviews[currentTabIndex].setTextColor(0xFF999999);
        mTextviews[index].setTextColor(0xff00aaff);
        currentTabIndex = index;
    }


    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
        RongIM.getInstance().removeUnReadMessageCountChangedObserver(this);
    }

    private int keyBackClickCount = 0;

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            switch (keyBackClickCount++) {
                case 0:
                    Toast.makeText(this, "再次按返回键退出", Toast.LENGTH_SHORT).show();
                    Timer timer = new Timer();
                    timer.schedule(new TimerTask() {
                        @Override
                        public void run() {
                            keyBackClickCount = 0;
                        }
                    }, 3000);
                    break;
                case 1:
                    finish();
                    overridePendingTransition(R.anim.push_up_in, R.anim.push_up_out);
                    break;
            }
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    private void initVersion() {
        // TODO 检查版本更新
    }

    @Override
    public void onCountChanged(int i) {
        if (i != 0) {
            mUnReadMsg.setVisibility(View.VISIBLE);
            mUnReadMsg.setText(i + "");
        } else {
            mUnReadMsg.setVisibility(View.GONE);
        }
    }

    @Subscribe
    public void onEventMainThread(CloseConversationEvent event) {
        index = 1;
        if (currentTabIndex != index) {
            showHideFragment(fragments[index], fragments[currentTabIndex]);
        }
        mImageBtns[currentTabIndex].setSelected(false);
        // 把当前tab设为选中状态
        mImageBtns[index].setSelected(true);
        mTextviews[currentTabIndex].setTextColor(0xFF999999);
        mTextviews[index].setTextColor(0xff00aaff);
        currentTabIndex = index;
    }
}