package com.sportspage.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.InviteRequestResult;
import com.sportspage.utils.Xutils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Tenma on 2016/12/16.
 */

public class ApplyListAdapter extends RecyclerView.Adapter<ApplyListAdapter.InviteHodler> {
    private List<InviteRequestResult> mDatas;
    private RecyclerClickListener mListener;
    private Context mContext;

    public ApplyListAdapter(Context context , List<InviteRequestResult> datas ) {
        this.mDatas = datas;
        this.mContext = context;
    }

    public void setmListener(RecyclerClickListener mListener) {
        this.mListener = mListener;
    }

    @Override
    public InviteHodler onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_invite,parent,false);
        ApplyListAdapter.InviteHodler inviteHodler = new ApplyListAdapter.InviteHodler(rootView);
        return inviteHodler;
    }

    @Override
    public void onBindViewHolder(final InviteHodler holder, final int position) {
        holder.rootView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (mListener != null) {
                    mListener.onRecycleItemClick(position);
                }
            }
        });
        holder.name.setText(mDatas.get(position).getNick());
        Glide.with(mContext).load(mDatas.get(position).getPortrait()).into(holder.icon);
        if (mDatas.get(position).getStatus() == 1) {
            holder.button.setVisibility(View.GONE);
            holder.agree.setVisibility(View.VISIBLE);
            holder.agree.setText("已加入");
        }
        holder.desc.setText("申请加入"+mDatas.get(position).getClub_name()+"俱乐部");
        holder.button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                agree(holder,position);
            }
        });
    }

    private void agree(final InviteHodler holder,int position) {
        Map<String,String> map = new HashMap<>();
        map.put("userId",mDatas.get(position).getTo_id());
        map.put("requestId",mDatas.get(position).getId());
        Xutils.getInstance(mContext).post(API.AGREE_JOIN_CLUB, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                holder.button.setVisibility(View.GONE);
                holder.agree.setText("已加入");
                holder.agree.setVisibility(View.VISIBLE);
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    class InviteHodler extends RecyclerView.ViewHolder {

        ImageView icon;
        TextView agree;
        TextView name;
        TextView desc;
        Button button;
        View rootView;

        public InviteHodler(View rootView) {
            super(rootView);
            this.rootView = rootView;
            icon= (ImageView) rootView.findViewById(R.id.iv_invite_icon);
            name = (TextView) rootView.findViewById(R.id.tv_invite_clubname);
            button = (Button) rootView.findViewById(R.id.btn_invite_agree);
            agree = (TextView) rootView.findViewById(R.id.tv_invite_agreed);
            desc = (TextView) rootView.findViewById(R.id.tv_invite_desc);
        }
    }
}
