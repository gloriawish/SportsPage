package com.sportspage.activity;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.flyco.tablayout.SlidingTabLayout;
import com.sportspage.R;
import com.sportspage.adapter.FragmentPagerAdapter;
import com.sportspage.adapter.RecordAdapter;
import com.sportspage.common.BaseFragment;
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


@ContentView(R.layout.activity_sports_record)
public class SportsRecordActivity extends SwipeBackActivity {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;

    @ViewInject(R.id.iv_back)
    private ImageView mBackView;

    @ViewInject(R.id.tablayout)
    SlidingTabLayout tablayout;
    @ViewInject(R.id.view_pager)
    ViewPager viewPager;

    private ArrayList<BaseFragment> mFagments = new ArrayList<>();
    private String[] mTitles = {"全部", "进行中", "待结算", "待评价"};

    private FragmentPagerAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        initView();
    }

    private void initView() {
        mBackView.setVisibility(View.VISIBLE);
        mTitle.setText(R.string.sports_record);
        mFagments.add(new AllRecordFragment());
        mFagments.add(new OrderingRecordFragment());
        mFagments.add(new SettlementRecordFragment());
        mFagments.add(new AppraiseRecordFragment());
        adapter = new FragmentPagerAdapter(getSupportFragmentManager(),mFagments,mTitles);
        viewPager.setAdapter(adapter);
        tablayout.setViewPager(viewPager, mTitles);
        int select = getIntent().getIntExtra("index",0);
        viewPager.setCurrentItem(select);
    }

    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

}
