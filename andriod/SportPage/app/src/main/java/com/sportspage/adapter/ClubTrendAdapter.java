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
import com.sportspage.entity.ClubActive;
import com.sportspage.utils.DateUtils;
import com.sportspage.utils.GlideCircleTransform;

import java.util.List;

/**
 * Created by Tenma on 2016/12/16.
 */

public class ClubTrendAdapter extends RecyclerView.Adapter<ClubTrendAdapter.ClubTrendHodler> {
    private Context mContext;
    private List<ClubActive> mDatas;
    private String mIconUrl;

    public ClubTrendAdapter(Context context, List<ClubActive> actives,String iconUrl) {
        this.mContext = context;
        mDatas = actives;
        mIconUrl = iconUrl;
    }


    @Override
    public ClubTrendHodler onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_club_trend, parent, false);
        ClubTrendAdapter.ClubTrendHodler cashbookHodler = new ClubTrendAdapter.ClubTrendHodler(rootView);
        return cashbookHodler;
    }

    @Override
    public void onBindViewHolder(ClubTrendHodler holder, int position) {
        if (mDatas.size() == 0) {
            holder.content.setText("暂无动态");
            Glide.with(mContext).load(R.drawable.bg_test)
                    .transform(new GlideCircleTransform(mContext))
                    .into(holder.headView);
            holder.line.setVisibility(View.GONE);
        } else {
            Glide.with(mContext).load(mIconUrl)
                    .transform(new GlideCircleTransform(mContext))
                    .into(holder.headView);
            holder.content.setText(mDatas.get(position).getDesc());
            holder.date.setText(DateUtils.getFormatTime(mDatas.get(position).getTime(),"MM/dd"));
            holder.time.setText(DateUtils.getFormatTime(mDatas.get(position).getTime(),"HH:mm"));
            if (position == mDatas.size()-1){
                holder.line.setVisibility(View.GONE);
            }
        }
    }

    @Override
    public int getItemCount() {
        return mDatas.size()==0 ? 1 : mDatas.size() ;
    }

    class ClubTrendHodler extends RecyclerView.ViewHolder {

        ImageView headView;
        TextView content;
        TextView date;
        TextView time;
        View line;

        public ClubTrendHodler(View rootView) {
            super(rootView);
            headView = (ImageView) rootView.findViewById(R.id.iv_club_trend_img);
            line = rootView.findViewById(R.id.v_club_trend_line);
            content = (TextView) rootView.findViewById(R.id.tv_club_trend_txt);
            date = (TextView) rootView.findViewById(R.id.tv_club_trend_date);
            time = (TextView) rootView.findViewById(R.id.tv_club_trend_date);
        }
    }
}
