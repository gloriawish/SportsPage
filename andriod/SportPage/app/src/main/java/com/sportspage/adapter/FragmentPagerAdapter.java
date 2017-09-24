package com.sportspage.adapter;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;

import com.sportspage.common.BaseFragment;

import java.util.List;

/**
 * Created by Tenma on 2017/1/3.
 */

public class FragmentPagerAdapter extends android.support.v4.app.FragmentPagerAdapter {
    private List<BaseFragment> mFragments;
    private String[] mTitles;

    public FragmentPagerAdapter(FragmentManager fm, List<BaseFragment> fragments, String[] titles) {
        super(fm);
        mFragments = fragments;
        mTitles = titles;
    }

    @Override
    public int getCount() {
        return mFragments.size();
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return mTitles[position];
    }

    @Override
    public Fragment getItem(int position) {
        return mFragments.get(position);
    }
}
