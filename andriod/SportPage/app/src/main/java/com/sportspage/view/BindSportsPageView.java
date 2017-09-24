package com.sportspage.view;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.widget.LinearLayout;

import com.sportspage.R;
import com.sportspage.adapter.LoopViewPager;
import com.sportspage.adapter.BindedSportsPageAdapter;
import com.sportspage.entity.ClubDetailResult;
import com.sportspage.utils.ScalePagerTransformer;
import com.sportspage.utils.Utils;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.List;


/**
 * 精品福利
 */
public class BindSportsPageView extends SimpleLinearLayout {
    @ViewInject(R.id.viewPager)
    LoopViewPager viewPager;
    @ViewInject(R.id.welfare_view)
    LinearLayout welfareView;

    private BindedSportsPageAdapter adapter = null;
    private int lastItemIndex = 0;

    public BindSportsPageView(Context context) {
        super(context);
        adapter = new BindedSportsPageAdapter(context);
    }

    public BindSportsPageView(Context context, AttributeSet attrs) {
        super(context, attrs);
        adapter = new BindedSportsPageAdapter(context);
    }

    @Override
    protected void initViews() {
        contentView = inflate(mContext, R.layout.layout_welfare, this);
        x.view().inject(contentView);
        init();
    }

    private void init() {
        initViewPager();
        initTouch();
        initListener();
    }

    private void initListener() {
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
            }

            @Override
            public void onPageSelected(int position) {
                applyTransform(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
    }

    private void initTouch() {
        setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                return viewPager.dispatchTouchEvent(event);
            }
        });
    }

    private void initViewPager() {
        viewPager.setPageTransformer(true, new ScalePagerTransformer());
        //设置Pager之间的间距
        viewPager.setPageMargin(Utils.dipToPixel(mContext, 10));
    }

    public void setWelfareData(List<ClubDetailResult.SportsBean> datas) {
        welfareView.setVisibility(datas.size()>0?VISIBLE:GONE);
        adapter.setDatas(datas);
        viewPager.setAdapter(adapter);
        viewPager.setOffscreenPageLimit(getCount());
        viewPager.setCurrentItem(adapter.getCount() > 2 ? 1 : 0, true);
    }

    public void setSportsPageClickListener(BindedSportsPageAdapter.OnBindSportsPageClickListener listener) {
        adapter.setmSportspageClick(listener);
    }

    private int getCount() {
        return adapter!=null?adapter.getCount():0;
    }

    public int getCurrentDisplayItem() {
        return viewPager!=null?viewPager.getCurrentItem():0;
    }

    private void applyTransform(int currentPosition) {
        if (currentPosition>getCount()){
            currentPosition=getCount();
        }
        if (lastItemIndex == currentPosition) {
            if (viewPager != null && viewPager.beginFakeDrag()) {
                viewPager.fakeDragBy(0f);
                viewPager.endFakeDrag();
            }
        }
        lastItemIndex = currentPosition;
    }

}
