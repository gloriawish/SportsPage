package com.sportspage.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.MessageResult;
import com.sportspage.utils.LogicUtils;

import java.util.List;

/**
 * Created by Tenma on 2016/12/25.
 */

public class MessageAdapter extends RecyclerView.Adapter<MessageAdapter.MessageHolder> {

    private List<MessageResult> mDatas;
    private Context mContext;
    private RecyclerClickListener mListener;

    public MessageAdapter(Context context, List<MessageResult> datas) {
        this.mDatas = datas;
        this.mContext = context;
    }


    public void setmListener(RecyclerClickListener listener) {
        mListener = listener;
    }

    @Override
    public MessageHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_message, parent, false);
        MessageHolder messageHolder = new MessageHolder(rootView);
        return messageHolder;
    }

    @Override
    public void onBindViewHolder(final MessageHolder holder, final int position) {
        holder.mRootView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mListener.onRecycleItemClick(position);
            }
        });
        if (mDatas.size() > 0 && position < 3) {
            if (null != mDatas.get(position)) {
                holder.mName.setText(mDatas.get(position).getNick());
                holder.mMessage.setText(mDatas.get(position).getContent());
                LogicUtils.loadImageFromUrl(holder.mImg, mDatas.get(position).getPortrait());
            }
        }
    }

    @Override
    public int getItemCount() {
        return mDatas.size() < 3 ? mDatas.size() : 3;
    }

    class MessageHolder extends RecyclerView.ViewHolder {

        TextView mName;
        TextView mMessage;
        ImageView mImg;
        View mRootView;

        public MessageHolder(View rootView) {
            super(rootView);
            mRootView = rootView;
            mName = (TextView) rootView.findViewById(R.id.tv_message_name);
            mMessage = (TextView) rootView.findViewById(R.id.tv_message);
            mImg = (ImageView) rootView.findViewById(R.id.riv_message_img);
        }
    }
}
