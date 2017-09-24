package com.sportspage.adapter;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.sportspage.R;
import com.sportspage.entity.ClubDetailResult;

import java.util.ArrayList;
import java.util.List;

public class BindedSportsPageAdapter extends PagerAdapter {

    private Context mContext;
    private List<ClubDetailResult.SportsBean> dataList = new ArrayList<>();
    private OnBindSportsPageClickListener mSportspageClick;

    public BindedSportsPageAdapter(Context mContext) {
        this.mContext = mContext;
    }

    public void setmSportspageClick(OnBindSportsPageClickListener mSportspageClick) {
        this.mSportspageClick = mSportspageClick;
    }

    public void setDatas(List<ClubDetailResult.SportsBean> list) {
        if (list.size() <= 0) {
            dataList.clear();
            notifyDataSetChanged();
            return;
        }
        dataList.clear();
        dataList.addAll(list);
        notifyDataSetChanged();
    }

    @Override
    public int getCount() {
        return dataList.size();
    }

    @Override
    public int getItemPosition(Object object) {
        return POSITION_NONE;
    }

    @Override
    public void destroyItem(View container, int position, Object object) {
    }

    @Override
    public Object instantiateItem(ViewGroup container, final int position) {

        if (dataList.size() <= 0) {
            return null;
        }
        ClubDetailResult.SportsBean data = dataList.get(position);

        BindedSportsPageAdapter.ClubRecordHodler viewHolder = null;
        View view = LayoutInflater.from(mContext).inflate(
                R.layout.item_club_record, null);
        if (viewHolder == null) {
            viewHolder = new BindedSportsPageAdapter.ClubRecordHodler(view);
        }
        Glide.with(mContext).load(data.getPortrait()).into(viewHolder.headView);
        viewHolder.name.setText(data.getTitle());
        viewHolder.location.setText(data.getLocation());
        viewHolder.mRootView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (mSportspageClick != null) {
                    mSportspageClick.onBindSportsPageClick(position);
                }
            }
        });
        container.addView(view, ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);

        return view;
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == object;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((View) object);
    }

    class ClubRecordHodler extends RecyclerView.ViewHolder {

        ImageView headView;
        TextView name;
        TextView location;
        View mRootView;

        public ClubRecordHodler(View rootView) {
            super(rootView);
            mRootView = rootView;
            headView = (ImageView) rootView.findViewById(R.id.iv_club_record_img);
            name = (TextView) rootView.findViewById(R.id.tv_club_record_name);
            location = (TextView) rootView.findViewById(R.id.tv_club_record_location);
        }
    }

    public interface OnBindSportsPageClickListener{
        void onBindSportsPageClick(int position);
    }

}
