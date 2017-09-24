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
import com.sportspage.entity.RecordResult;
import com.sportspage.utils.LogicUtils;

import java.util.List;

/**
 * Created by Tenma on 2016/12/25.
 */

public class RecordAdapter extends  RecyclerView.Adapter<RecordAdapter.RecordHolder> {

    private List<RecordResult> mDatas;
    private Context mContext;
    private RecyclerClickListener mListener;

    public RecordAdapter(Context context ,List<RecordResult> datas ) {
        this.mDatas = datas;
        this.mContext = context;
    }


    public void setmListener(RecyclerClickListener listener) {
        mListener = listener;
    }

    @Override
    public RecordHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_record,parent,false);
        RecordHolder recordHolder = new RecordHolder(rootView);
        return recordHolder;
    }

    @Override
    public void onBindViewHolder(RecordHolder holder, final int position) {
        holder.mRootView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mListener.onRecycleItemClick(position);
            }
        });
        holder.mTitle.setText(mDatas.get(position).getTitle());
        holder.mLocation.setText(mDatas.get(position).getLocation());
        holder.mTime.setText(mDatas.get(position).getTitle());
        holder.mNick.setText(mDatas.get(position).getCreator());
        holder.mType.setText(LogicUtils.getType(mDatas.get(position).getSport_item()));
        if (mDatas.get(position).getCharge_type().equals("1")){
            holder.mCharType.setText(R.string.online);
        } else {
            holder.mCharType.setText(R.string.offline);
        }
        holder.mStatus.setText(mDatas.get(position).getStatus());
        holder.mPrice.setText(mDatas.get(position).getPrice());
        LogicUtils.loadImageFromUrl(holder.mSportsImg,mDatas.get(position).getPortrait());
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    class RecordHolder extends RecyclerView.ViewHolder {

        TextView mTitle;
        TextView mLocation;
        TextView mTime;
        TextView mNick;
        TextView mType;
        TextView mCharType;
        TextView mPrice;
        TextView mStatus;
        ImageView mSportsImg;
        LinearLayout mRootView;

        public RecordHolder(View rootView) {
            super(rootView);
            mRootView = (LinearLayout) rootView.findViewById(R.id.ll_record_layout);
            mTitle = (TextView) rootView.findViewById(R.id.tv_record_name);
            mLocation = (TextView) rootView.findViewById(R.id.tv_record_location);
            mTime = (TextView) rootView.findViewById(R.id.tv_record_time);
            mNick = (TextView) rootView.findViewById(R.id.tv_record_initiate);
            mType = (TextView) rootView.findViewById(R.id.tv_record_type);
            mCharType = (TextView) rootView.findViewById(R.id.tv_record_chargeType);
            mPrice = (TextView) rootView.findViewById(R.id.tv_record_price);
            mStatus = (TextView) rootView.findViewById(R.id.tv_record_status);
            mSportsImg = (ImageView) rootView.findViewById(R.id.iv_record_sports);

        }
    }
}
