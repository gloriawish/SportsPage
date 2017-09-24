package com.sportspage.activity;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.flyco.tablayout.SlidingTabLayout;
import com.sportspage.R;
import com.sportspage.adapter.FragmentPagerAdapter;
import com.sportspage.common.BaseFragment;
import com.sportspage.fragment.sportspage.FocusRecordFragment;
import com.sportspage.fragment.sportspage.SportsPageFragment;
import com.sportspage.utils.Utils;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;

import me.yokeyword.swipebackfragment.SwipeBackActivity;


@ContentView(R.layout.activity_my_sports_page)
public class MySportsPageActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;

    @ViewInject(R.id.iv_back)
    private ImageView mBackView;

    @ViewInject(R.id.stl_sports_page_layout)
    SlidingTabLayout tablayout;
    @ViewInject(R.id.vp_sports_page)
    ViewPager viewPager;

    private ArrayList<BaseFragment> mFagments = new ArrayList<>();
    private String[] mTitles = {"运动页记录","关注记录"};

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
        mTitle.setText("我的运动页");
        mFagments.add(new SportsPageFragment());
        mFagments.add(new FocusRecordFragment());
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
