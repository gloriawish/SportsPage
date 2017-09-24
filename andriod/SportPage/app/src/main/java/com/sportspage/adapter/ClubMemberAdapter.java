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
import java.util.Map;

/**
 * Created by Tenma on 2016/12/16.
 */

public class ClubMemberAdapter extends RecyclerView.Adapter<ClubMemberAdapter.ClubMemberHodler> {
    private Context mContext;
    private List<ClubDetailResult.TopMemberBean> mDatas;

    public ClubMemberAdapter(Context context, List<ClubDetailResult.TopMemberBean> datas) {
        this.mContext = context;
        this.mDatas = datas;
    }


    @Override
    public ClubMemberHodler onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_club_member,parent,false);
        ClubMemberAdapter.ClubMemberHodler cashbookHodler = new ClubMemberAdapter.ClubMemberHodler(rootView);
        return cashbookHodler;
    }

    @Override
    public void onBindViewHolder(ClubMemberHodler holder, int position) {
        Glide.with(mContext).load(mDatas.get(position).getPortrait()).transform(new GlideCircleTransform(mContext))
                .into(holder.headView);
    }

    @Override
    public int getItemCount() {
        return mDatas.size() > 5 ? 5 : mDatas.size();
    }

    class ClubMemberHodler extends RecyclerView.ViewHolder {

        ImageView headView;

        public ClubMemberHodler(View rootView) {
            super(rootView);
            headView = (ImageView) rootView.findViewById(R.id.riv_head);
        }
    }
}
