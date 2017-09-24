package com.sportspage.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.ActiveResult;
import com.sportspage.entity.RecordResult;
import com.sportspage.utils.LogicUtils;
import com.sportspage.utils.Xutils;

import org.xutils.x;

import java.util.List;

/**
 * Created by Tenma on 2016/12/25.
 */

public class SportPageRecordAdapter extends  RecyclerView.Adapter<SportPageRecordAdapter.RecordHolder> {

    private List<ActiveResult> mDatas;
    private Context mContext;
    private RecyclerClickListener mListener;

    public SportPageRecordAdapter(Context context , List<ActiveResult> datas ) {
        this.mDatas = datas;
        this.mContext = context;
    }


    public void setmListener(RecyclerClickListener listener) {
        mListener = listener;
    }

    @Override
    public RecordHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_sport_record,parent,false);
        RecordHolder recordHolder = new RecordHolder(rootView);
        return recordHolder;
    }

    @Override
    public void onBindViewHolder(RecordHolder holder, final int position) {
        holder.mRootView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            if (mListener != null) {
                mListener.onRecycleItemClick(position);
            }
            }
        });
        holder.mTitle.setText(mDatas.get(position).getTitle());
        holder.mLocation.setText(mDatas.get(position).getLocation());
        if (mDatas.get(position).getActive_times().equals("0")){
            holder.mCount.setText("从未激活");
        } else {
            holder.mCount.setText("已激活"+mDatas.get(position).getActive_times()+"次");
        }
        holder.mType.setText(LogicUtils.getType(mDatas.get(position).getSport_item()));
        LogicUtils.loadImageFromUrl(holder.mSportsImg,mDatas.get(position).getPortrait());
        if (mDatas.get(position).getStatus().equals("0")){
            holder.mStatus.setImageResource(R.drawable.mine_sportspage_unactive);
        } else {
            holder.mStatus.setImageResource(R.drawable.mine_sportspage_active);
        }
        holder.mStar.setImageResource(LogicUtils.getStarId(mDatas.get(position).getGrade()));
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    class RecordHolder extends RecyclerView.ViewHolder {

        TextView mTitle;
        TextView mLocation;
        TextView mCount;
        TextView mType;
        ImageView mSportsImg;
        ImageView mStatus;
        ImageView mStar;
        LinearLayout mRootView;

        public RecordHolder(View rootView) {
            super(rootView);
            mRootView = (LinearLayout) rootView.findViewById(R.id.ll_sport_record_layout);
            mTitle = (TextView) rootView.findViewById(R.id.tv_record_name);
            mLocation = (TextView) rootView.findViewById(R.id.tv_sportpage_location);
            mType = (TextView) rootView.findViewById(R.id.tv_sportpage_type);
            mCount = (TextView) rootView.findViewById(R.id.tv_sportpage_count);
            mStatus = (ImageView) rootView.findViewById(R.id.iv_sportpage_status);
            mSportsImg = (ImageView) rootView.findViewById(R.id.iv_record_sports);
            mStar = (ImageView) rootView.findViewById(R.id.iv_sportpage_star);

        }
    }
}
