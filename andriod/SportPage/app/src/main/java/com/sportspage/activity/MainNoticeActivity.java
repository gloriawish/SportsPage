package com.sportspage.activity;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.flyco.tablayout.SlidingTabLayout;
import com.sportspage.R;
import com.sportspage.adapter.FragmentPagerAdapter;
import com.sportspage.common.BaseFragment;
import com.sportspage.fragment.notice.SPNoticeFragment;
import com.sportspage.fragment.notice.SysNoticeFragment;
import com.sportspage.fragment.record.AllRecordFragment;
import com.sportspage.fragment.record.AppraiseRecordFragment;
import com.sportspage.fragment.record.OrderingRecordFragment;
import com.sportspage.fragment.record.SettlementRecordFragment;
import com.sportspage.utils.Utils;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

@ContentView(R.layout.activity_main_notice)
public class MainNoticeActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;

    @ViewInject(R.id.iv_back)
    private ImageView mBackView;

    @ViewInject(R.id.stl_notice_layout)
    SlidingTabLayout tablayout;
    @ViewInject(R.id.view_pager)
    ViewPager viewPager;

    private ArrayList<BaseFragment> mFagments = new ArrayList<>();
    private String[] mTitles = {"系统消息","运动消息"};

    private FragmentPagerAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        mBackView.setVisibility(View.VISIBLE);
        mTitle.setText("消息通知");
        mFagments.add(new SysNoticeFragment());
        mFagments.add(new SPNoticeFragment());
        adapter = new FragmentPagerAdapter(getSupportFragmentManager(),mFagments,mTitles);
        viewPager.setAdapter(adapter);
        tablayout.setViewPager(viewPager, mTitles);
    }

    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }
}
