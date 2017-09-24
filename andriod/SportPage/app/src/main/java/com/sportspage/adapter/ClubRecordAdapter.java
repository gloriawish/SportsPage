package com.sportspage.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.sportspage.R;
import com.sportspage.entity.ClubDetailResult;
import com.sportspage.utils.GlideCircleTransform;

import java.util.List;

/**
 * Created by Tenma on 2016/12/16.
 */

public class ClubRecordAdapter extends RecyclerView.Adapter<ClubRecordAdapter.ClubRecordHodler> {
    private Context mContext;
    private List<ClubDetailResult.SportsBean> mDatas;

    public ClubRecordAdapter(Context context, List<ClubDetailResult.SportsBean> datas) {
        this.mContext = context;
        this.mDatas = datas;
    }


    @Override
    public ClubRecordHodler onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_club_record,parent,false);
        ClubRecordAdapter.ClubRecordHodler cashbookHodler = new ClubRecordAdapter.ClubRecordHodler(rootView);
        return cashbookHodler;
    }

    @Override
    public void onBindViewHolder(ClubRecordHodler holder, int position) {
        Glide.with(mContext).load(mDatas.get(position).getPortrait()).into(holder.headView);
        holder.name.setText(mDatas.get(position).getTitle());
        holder.location.setText(mDatas.get(position).getLocation());

    }

    @Override
    public int getItemCount() {
        return mDatas.size() > 5 ? 5 : mDatas.size();
    }

    class ClubRecordHodler extends RecyclerView.ViewHolder {

        ImageView headView;
        TextView name;
        TextView location;

        public ClubRecordHodler(View rootView) {
            super(rootView);
            headView = (ImageView) rootView.findViewById(R.id.iv_club_record_img);
            name = (TextView) rootView.findViewById(R.id.tv_club_record_name);
            location = (TextView) rootView.findViewById(R.id.tv_club_record_location);
        }
    }
}
