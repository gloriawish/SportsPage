package com.sportspage.adapter;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.API;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.FocusResult;
import com.sportspage.utils.LogicUtils;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.rong.imkit.RongIM;
import io.rong.imlib.RongIMClient;

/**
 * Created by Tenma on 2016/12/25.
 */

public class FocusRecordAdapter extends RecyclerView.Adapter<FocusRecordAdapter.RecordHolder> {

    private List<FocusResult> mDatas;
    private Context mContext;
    private RecyclerClickListener mListener;
    private boolean isFocus = true;

    public FocusRecordAdapter(Context context, List<FocusResult> datas) {
        this.mDatas = datas;
        this.mContext = context;
    }


    public void setmListener(RecyclerClickListener listener) {
        mListener = listener;
    }

    @Override
    public RecordHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_focus, parent, false);
        RecordHolder recordHolder = new RecordHolder(rootView);
        return recordHolder;
    }

    @Override
    public void onBindViewHolder(final RecordHolder holder, final int position) {
        holder.mRootView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mListener.onRecycleItemClick(position);
            }
        });
        holder.mTitle.setText(mDatas.get(position).getTitle());
        holder.mLocation.setText(mDatas.get(position).getLocation());
        holder.mCreater.setText("发起人:"+mDatas.get(position).getCreator());
        LogicUtils.loadImageFromUrl(holder.mSportsImg, mDatas.get(position).getPortrait());
        holder.mType.setImageResource(LogicUtils.getTypeId(mDatas.get(position).getSport_item()));
        holder.mStatus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isFocus) {
                    cancelFocus(position,holder.mStatus);
                } else {
                    focus(position,holder.mStatus);
                }
            }
        });
    }

    private void focus(int position, final ImageView status) {
        String userId = Utils.getValue(mContext, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("sportId", mDatas.get(position).getSport_id());
        Xutils.getInstance(mContext).post(API.FOLLOW, map,
                new Xutils.XCallBack() {
                    @Override
                    public void onResponse(String result) {
                        status.setImageResource(R.drawable.mine_focus_record_focus);
                        isFocus = !isFocus;
                    }

                    @Override
                    public void onFinished() {
                    }
                });
    }

    private void cancelFocus(final int position, final ImageView status) {
        AlertDialog mDialog = new AlertDialog.Builder(mContext)
                .setNegativeButton("否", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                    }
                })
                .setPositiveButton("是", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        String userId = Utils.getValue(mContext, "userId");
                        Map<String, String> map = new HashMap<>();
                        map.put("userId", userId);
                        map.put("sportId", mDatas.get(position).getSport_id());
                        Xutils.getInstance(mContext).post(API.CANCEL_FOLLOW, map,
                                new Xutils.XCallBack() {
                                    @Override
                                    public void onResponse(String result) {
                                        status.setImageResource(R.drawable.mine_focus_record_unfocus);
                                        isFocus = !isFocus;
                                    }

                                    @Override
                                    public void onFinished() {
                                    }
                                });

                    }
                }).setMessage("取消关注？").show();
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    class RecordHolder extends RecyclerView.ViewHolder {

        TextView mTitle;
        TextView mLocation;
        TextView mCreater;
        ImageView mSportsImg;
        ImageView mType;
        ImageView mStatus;
        View mRootView;

        public RecordHolder(View rootView) {
            super(rootView);
            mRootView = rootView;
            mTitle = (TextView) rootView.findViewById(R.id.tv_focus_sportName);
            mLocation = (TextView) rootView.findViewById(R.id.tv_focus_location);
            mCreater = (TextView) rootView.findViewById(R.id.tv_focus_creater);
            mType = (ImageView) rootView.findViewById(R.id.iv_focus_type);
            mSportsImg = (ImageView) rootView.findViewById(R.id.riv_focus_img);
            mStatus = (ImageView) rootView.findViewById(R.id.iv_focus_status);
        }
    }
}
