package com.sportspage.adapter;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.EventResult;
import com.sportspage.utils.DateUtils;
import com.sportspage.utils.LogicUtils;
import com.sportspage.utils.Xutils;

import org.xutils.common.Callback;
import org.xutils.image.ImageOptions;
import org.xutils.x;

import java.util.List;
import java.util.Map;

/**
 * Created by Tenma on 2016/12/13.
 */

public class HotListAdapter extends RecyclerView.Adapter<HotListAdapter.SportsHolder> {

    private List<EventResult.DataBean> mDatas;
    private Context mContext;
    private RecyclerClickListener mListener;

    public HotListAdapter(Context context, List<EventResult.DataBean> datas) {
        this.mDatas = datas;
        this.mContext = context;
    }

    @Override
    public SportsHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_sports, parent, false);
        SportsHolder sportsHolder = new SportsHolder(rootView);
        return sportsHolder;
    }

    @Override
    public void onBindViewHolder(final SportsHolder holder, final int position) {
        holder.mRootView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mListener.onRecycleItemClick(position);
            }
        });
        LogicUtils.loadImageFromUrl(holder.mSportsImg,mDatas.get(position).getPortrait());
        holder.mTitle.setText(mDatas.get(position).getTitle());
        holder.mLocation.setText(mDatas.get(position).getLocation());
        holder.mTime.setText(DateUtils.getFormatTime(mDatas.get(position).getStart_time()
                , "MM-dd HH:mm"));
        holder.mNick.setText(mDatas.get(position).getUser_id().getNick());
        holder.mUserCount.setText(mDatas.get(position).get_enroll_user().size() + "/"
                + mDatas.get(position).getMax_number());
        holder.mStar.setImageResource(LogicUtils.getStarId(mDatas.get(position).getGrade()));
    }


    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    public void setmListener(RecyclerClickListener mListener) {
        this.mListener = mListener;
    }

    class SportsHolder extends RecyclerView.ViewHolder {

        TextView mTitle;
        TextView mLocation;
        TextView mTime;
        TextView mNick;
        TextView mUserCount;
        ImageView mStar;
        ImageView mSportsImg;
        View mRootView;


        public SportsHolder(View rootView) {
            super(rootView);
            mRootView = rootView;
            mTitle = (TextView) rootView.findViewById(R.id.tv_sports_name);
            mLocation = (TextView) rootView.findViewById(R.id.tv_sports_address);
            mTime = (TextView) rootView.findViewById(R.id.tv_sports_time);
            mNick = (TextView) rootView.findViewById(R.id.tv_sports_user_name);
            mUserCount = (TextView) rootView.findViewById(R.id.tv_sports_num);
            mStar = (ImageView) rootView.findViewById(R.id.iv_sports_star);
            mSportsImg = (ImageView) rootView.findViewById(R.id.iv_sports);

        }
    }

}



