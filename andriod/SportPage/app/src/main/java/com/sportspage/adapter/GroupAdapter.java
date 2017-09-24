package com.sportspage.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.activity.GroupListActivity;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.GroupResult;
import com.sportspage.entity.RecordResult;
import com.sportspage.utils.LogicUtils;

import java.util.List;

/**
 * Created by Tenma on 2016/12/25.
 */

public class GroupAdapter extends  RecyclerView.Adapter<GroupAdapter.GroupHolder> {

    private List<GroupResult.Group> mDatas;
    private Context mContext;
    private RecyclerClickListener mListener;

    public GroupAdapter(Context context , List<GroupResult.Group> datas ) {
        this.mDatas = datas;
        this.mContext = context;
    }


    public void setmListener(RecyclerClickListener listener) {
        mListener = listener;
    }

    @Override
    public GroupHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_group,parent,false);
        GroupHolder recordHolder = new GroupHolder(rootView);
        return recordHolder;
    }

    @Override
    public void onBindViewHolder(GroupHolder holder, final int position) {
        holder.mRootView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mListener.onRecycleItemClick(position);
            }
        });
        holder.mNick.setText(mDatas.get(position).getName());
        LogicUtils.loadImageFromUrl(holder.mGroupImg,mDatas.get(position).getPortrait());
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    class GroupHolder extends RecyclerView.ViewHolder {

        TextView mNick;
        ImageView mGroupImg;
        View mRootView;

        public GroupHolder(View rootView) {
            super(rootView);
            mRootView = rootView;
            mNick = (TextView) rootView.findViewById(R.id.tv_group_nick);
            mGroupImg = (ImageView) rootView.findViewById(R.id.iv_group_img);

        }
    }
}
