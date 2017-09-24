package com.sportspage.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.FriendsResult;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.utils.LogicUtils;

import java.util.List;

/**
 * Created by Tenma on 2017/1/5.
 */

public class FriendAdapter extends RecyclerView.Adapter<FriendAdapter.FriendHolder> {
    private Context mContext;
    private List<FriendsResult.User> mDatas;// 好友信息
    private RecyclerClickListener mListener;

    public FriendAdapter(Context context,List<FriendsResult.User> datas){
        mContext = context;
        mDatas = datas;
    }

    @Override
    public FriendHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_search,parent,false);
        FriendAdapter.FriendHolder friendHolder = new  FriendAdapter.FriendHolder(rootView);
        return friendHolder;
    }

    @Override
    public void onBindViewHolder(FriendHolder holder, final int position) {
        holder.mRootView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mListener.onRecycleItemClick(position);
            }
        });
        LogicUtils.loadImageFromUrl(holder.mPortrait,mDatas.get(position).getPortrait());
        holder.mNick.setText(mDatas.get(position).getNick());
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    public void setmListener(RecyclerClickListener mListener) {
        this.mListener = mListener;
    }


    class FriendHolder extends RecyclerView.ViewHolder {

        TextView mNick;
        ImageView mPortrait;
        View mRootView;

        public FriendHolder(View rootView) {
            super(rootView);
            mRootView = rootView;
            mNick = (TextView) rootView.findViewById(R.id.tv_search_name);
            mPortrait = (ImageView) rootView.findViewById(R.id.iv_search_portrait);
        }
    }
}
