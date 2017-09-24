package com.sportspage.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.activity.UserDetailActivity;
import com.sportspage.common.API;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.MessageResult;
import com.sportspage.entity.SportDetailResult;
import com.sportspage.utils.LogicUtils;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.xutils.x;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Tenma on 2016/12/25.
 */

public class EnrollUserAdapter extends RecyclerView.Adapter<EnrollUserAdapter.RecordHolder> {

    private List<SportDetailResult.EnrollUserBean> mDatas;
    private Activity mContext;
    private RecyclerClickListener mListener;

    public EnrollUserAdapter(Activity context, List<SportDetailResult.EnrollUserBean> datas) {
        this.mDatas = datas;
        this.mContext = context;
    }


    public void setmListener(RecyclerClickListener listener) {
        mListener = listener;
    }

    @Override
    public RecordHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_enroll_user,
                parent, false);
        RecordHolder recordHolder = new RecordHolder(rootView);
        return recordHolder;
    }

    @Override
    public void onBindViewHolder(final RecordHolder holder, final int position) {
//        holder.mRootView.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                mListener.onRecycleItemClick(position);
//            }
//        });
        LogicUtils.loadImageFromUrl(holder.mPortrait,mDatas.get(position).getPortrait());
        holder.mName.setText(mDatas.get(position).getNick());
        final int relative = mDatas.get(position).getRelation();
        switch (relative){
            case -1:
                holder.mViewInfo.setVisibility(View.GONE);
                break;
            case 0:
                holder.mViewInfo.setText(R.string.add_friend);
                holder.mViewInfo.setBackgroundResource(R.drawable.btn_bg_blue);
                break;
            case 1:
                holder.mViewInfo.setText(R.string.view_info);
                break;
        }
        holder.mViewInfo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                switch (relative){
                    case 0:
                        addFriend(position, holder);
                        break;
                    case 1:
                        viewInfo(position);
                        break;
                }
            }
        });
    }

    private void addFriend(int position, final RecordHolder holder) {
        String userId = Utils.getValue(mContext, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("friendId", mDatas.get(position).getId());
        Xutils.getInstance(mContext).post(API.ADD_FRIEND, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(),"等待对方同意");
                holder.mViewInfo.setBackgroundResource(R.drawable.btn_bg_gray);
                holder.mViewInfo.setEnabled(false);
            }

            @Override
            public void onFinished() {

            }
        });
    }

    private void viewInfo(int position) {
        Intent intent = new Intent();
        intent.putExtra("userId",mDatas.get(position).getId());
        intent.putExtra("nick",mDatas.get(position).getNick());
        intent.putExtra("email",mDatas.get(position).getEmail());
        intent.putExtra("city",mDatas.get(position).getCity());
        intent.putExtra("portrait",mDatas.get(position).getPortrait());
        intent.setClass(mContext,UserDetailActivity.class);
        Utils.start_Activity(mContext,intent);
    }


    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    class RecordHolder extends RecyclerView.ViewHolder {
        ImageView mPortrait;
        TextView mName;
        Button mViewInfo;
        View mRootView;
        public RecordHolder(View rootView) {
            super(rootView);
            mRootView = rootView;
            mPortrait = (ImageView) rootView.findViewById(R.id.riv_enroll_user_img);
            mName = (TextView) rootView.findViewById(R.id.tv_enroll_user_name);
            mViewInfo = (Button) rootView.findViewById(R.id.btn_view_info);
        }
    }
}
