package com.sportspage.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;

import com.sportspage.R;
import com.sportspage.common.BaseActivity;
import com.sportspage.fragment.SplashItemFragment;
import com.sportspage.utils.Utils;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;

@ContentView(R.layout.activity_splash)
public class SplashActivity extends FragmentActivity {

    @ViewInject(R.id.vp_splash_view)
    private ViewPager viewPager;
    private ArrayList<Fragment> fragments;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        init();
    }

    private void init() {
        fragments = new ArrayList<>();
        fragments.add(SplashItemFragment.newInstance(R.layout.splash_item,R.drawable.boot_imageview_1));
        fragments.add(SplashItemFragment.newInstance(R.layout.splash_item,R.drawable.boot_imageview_2));
        fragments.add(SplashItemFragment.newInstance(R.layout.splash_item_in,R.drawable.boot_imageview_3));
        viewPager.setAdapter(new SplashPagerAdapter(getSupportFragmentManager()));
    }

    @Event(R.id.btn_splash_start)
    public void startMain(View view) {
        finish();
        startActivity(new Intent(SplashActivity.this, LoginActivity.class));
    }

    class SplashPagerAdapter extends FragmentPagerAdapter {

        public SplashPagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            return fragments.get(position);
        }

        @Override
        public int getCount() {
            return fragments == null ? 0 : fragments.size();
        }
    }

}

