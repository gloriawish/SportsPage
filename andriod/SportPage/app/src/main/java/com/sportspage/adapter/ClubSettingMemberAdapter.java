package com.sportspage.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.sportspage.R;
import com.sportspage.utils.GlideCircleTransform;

import java.util.ArrayList;

/**
 * Created by tenma on 3/2/17.
 */

public class ClubSettingMemberAdapter extends
        RecyclerView.Adapter<ClubSettingMemberAdapter.SettingMemberHolder> {

    private Context mContext;
    private ArrayList<String> mDatas;

    public ClubSettingMemberAdapter(Context context, ArrayList<String> data) {
        mContext = context;
        mDatas = data;
    }

    @Override
    public SettingMemberHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_club_setting_member, parent, false);
        SettingMemberHolder holder = new SettingMemberHolder(rootView);
        return holder;
    }

    @Override
    public void onBindViewHolder(SettingMemberHolder holder, int position) {
        Glide.with(mContext).load(mDatas.get(position))
                .transform(new GlideCircleTransform(mContext)).into(holder.mHeadView);
    }

    @Override
    public int getItemCount() {
        return mDatas.size() > 4 ? 4 : mDatas.size();
    }

    public class SettingMemberHolder extends RecyclerView.ViewHolder {

        private ImageView mHeadView;

        public SettingMemberHolder(View itemView) {
            super(itemView);
            mHeadView = (ImageView) itemView.findViewById(R.id.iv_club_member_head);
        }
    }
}
