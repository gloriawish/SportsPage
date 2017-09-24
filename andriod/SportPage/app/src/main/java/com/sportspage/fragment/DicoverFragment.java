package com.sportspage.fragment;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.activity.CreateActivity;
import com.sportspage.activity.MainNoticeActivity;
import com.sportspage.activity.SportPageRecordActivity;
import com.sportspage.adapter.DicoverAdapter;
import com.sportspage.utils.Utils;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import info.hoang8f.android.segmented.SegmentedGroup;
import me.yokeyword.fragmentation.SupportFragment;

//发现
@ContentView(R.layout.fragment_dicover)
public class DicoverFragment extends SupportFragment implements RadioGroup.OnCheckedChangeListener {

    private Activity mContext;

    @ViewInject(R.id.iv_dicover_left)
    private ImageView mLeftView;
    @ViewInject(R.id.iv_dicover_right)
    private ImageView mRightView;
    @ViewInject(R.id.sd_dicover_segmented)
    private SegmentedGroup mSegmentedGroup;
    @ViewInject(R.id.vp_dicover_child)
    private ViewPager mViewPager;

    private DicoverAdapter mAdapter;
    private PopupWindow mPopupWindow;

    public DicoverFragment() {

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = x.view().inject(this, inflater, container);
        mContext = this.getActivity();
        init();
        return view;
    }

    @Event(R.id.iv_dicover_right)
    private void create(View v){
        View popupView = mContext.getLayoutInflater().inflate(R.layout.popupwindow_sportspage, null);
        TextView addFriend = (TextView) popupView.findViewById(R.id.tv_create_sportspage);
        addFriend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPopupWindow.dismiss();
                Utils.start_Activity(mContext, CreateActivity.class);
            }
        });
        TextView createGroup = (TextView) popupView.findViewById(R.id.tv_active_sportspage);
        createGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPopupWindow.dismiss();
                Utils.start_Activity(mContext, SportPageRecordActivity.class);
            }
        });
        mPopupWindow = new PopupWindow(popupView, WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT, true);
        mPopupWindow.showAsDropDown(v,-mPopupWindow.getWidth()+v.getWidth(),14);
        mPopupWindow.setOutsideTouchable(true);
    }

    @Event(R.id.iv_dicover_left)
    private void notice(View v){
        Utils.start_Activity(mContext, MainNoticeActivity.class);
    }


    private void init() {
        mSegmentedGroup.check(R.id.btn_dicover_hot);
        mSegmentedGroup.setOnCheckedChangeListener(this);
        mAdapter = new DicoverAdapter(getChildFragmentManager());
        mViewPager.setAdapter(mAdapter);
        mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i1) {
            }
            @Override
            public void onPageSelected(int i) {
                switch (i){
                    case 0:
                        mSegmentedGroup.check(R.id.btn_dicover_hot);
                        break;
                    case 1:
                        mSegmentedGroup.check(R.id.btn_dicover_focus);
                        break;
                }
            }
            @Override
            public void onPageScrollStateChanged(int i) {
            }
        });
    }

    @Override
    public void onCheckedChanged(RadioGroup group, int checkedId) {
        switch (checkedId){
            case R.id.btn_dicover_hot:
                mViewPager.setCurrentItem(0);
                break;
            case R.id.btn_dicover_focus:
                mViewPager.setCurrentItem(1);
                break;
        }
    }
}
