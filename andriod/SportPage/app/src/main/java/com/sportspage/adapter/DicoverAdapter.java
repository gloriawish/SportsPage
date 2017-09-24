package com.sportspage.adapter;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.sportspage.fragment.discover.FocusFragment;
import com.sportspage.fragment.discover.HotFragment;

import java.util.ArrayList;
import java.util.List;

import me.yokeyword.fragmentation.SupportFragment;

/**
 * Created by Tenma on 2016/12/21.
 */

public class DicoverAdapter extends FragmentPagerAdapter {

    private List<SupportFragment> mFragments = new ArrayList<>(2);

    public DicoverAdapter(FragmentManager fm) {
        super(fm);
        mFragments.add(new HotFragment());
        mFragments.add(new FocusFragment());
    }

    @Override
    public Fragment getItem(int position) {
        return mFragments.get(position);
    }

    @Override
    public int getCount() {
        return mFragments.size();
    }
}
