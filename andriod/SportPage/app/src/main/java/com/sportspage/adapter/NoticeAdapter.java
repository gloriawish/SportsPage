package com.sportspage.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.MainNoticeResult;
import com.sportspage.utils.DateUtils;

import java.util.List;

/**
 * Created by sportspage on 2017/1/9.
 */

public class NoticeAdapter extends RecyclerView.Adapter<NoticeAdapter.NoticeHolder>{

    private Context mContext;
    private RecyclerClickListener mListener;
    private List<MainNoticeResult.DataBean> mDatas;

    public void setmListener(RecyclerClickListener listener) {
        mListener = listener;
    }

    public NoticeAdapter(Context context ,List<MainNoticeResult.DataBean> datas){
        mContext =context;
        mDatas = datas;
    }

    @Override
    public NoticeHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_mainnotice,parent,false);
        NoticeAdapter.NoticeHolder noticeHolder = new NoticeAdapter.NoticeHolder(rootView);
        return noticeHolder;
    }

    @Override
    public void onBindViewHolder(NoticeHolder holder, int position) {
        setTitleImg(holder, position);
        holder.mTime.setText(DateUtils.getFormatTime(mDatas.get(position).getTime(),"yyyy-MM-dd"));
        holder.mDescribe.setText(mDatas.get(position).getContent());
    }

    private void setTitleImg(NoticeHolder holder, final int position) {
        View.OnClickListener listener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mListener != null){
                    mListener.onRecycleItemClick(position);
                }
            }
        };
        switch (mDatas.get(position).getType()){
            case "1001":
                holder.mTitle.setText("系统消息");
                holder.mImg.setImageResource(R.drawable.sports_notification_system);
                holder.mView.setVisibility(View.GONE);
                break;
            case "1002":
                holder.mTitle.setText("充值消息");
                holder.mImg.setImageResource(R.drawable.sports_notification_charge);
                holder.mView.setVisibility(View.GONE);
                break;
            case "1003":
                holder.mTitle.setText("提现消息");
                holder.mImg.setImageResource(R.drawable.sports_notification_drawsith);
                holder.mView.setVisibility(View.GONE);
                break;
            case "1004":
                holder.mTitle.setText("结算消息");
                holder.mImg.setImageResource(R.drawable.sports_notification_settle);
                holder.mView.setVisibility(View.GONE);
                break;
            case "2003":
                holder.mTitle.setText("运动解散");
                holder.mImg.setImageResource(R.drawable.sports_notification_eventdismiss);
                holder.mView.setVisibility(View.GONE);
                break;
            case "2005":
                holder.mTitle.setText("取消报名成功");
                holder.mImg.setImageResource(R.drawable.sports_notification_dismiss);
                holder.mView.setVisibility(View.GONE);
                break;
            case "2006":
                holder.mTitle.setText("运动群即将解散");
                holder.mImg.setImageResource(R.drawable.sports_notification_groupdismiss);
                holder.mView.setVisibility(View.GONE);
                break;
            case "2001":
                holder.mTitle.setText("已关注运动页激活");
                holder.mImg.setImageResource(R.drawable.sports_notification_active);
                holder.mRootView.setOnClickListener(listener);
                break;
            case "2002":
                holder.mTitle.setText("运动即将开始");
                holder.mImg.setImageResource(R.drawable.sports_notification_eventbegin);
                holder.mRootView.setOnClickListener(listener);
                break;
            case "2004":
                holder.mTitle.setText("报名成功");
                holder.mImg.setImageResource(R.drawable.sports_notification_signup);
                holder.mRootView.setOnClickListener(listener);
                break;
            default:
                holder.mTitle.setText("系统消息");
                holder.mImg.setImageResource(R.drawable.sports_notification_system);
                holder.mRootView.setOnClickListener(listener);
                break;
        }
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    class NoticeHolder extends RecyclerView.ViewHolder {

        TextView mTitle;
        TextView mTime;
        ImageView mImg;
        TextView mDescribe;
        LinearLayout mView;
        View mRootView;
        public NoticeHolder(View rootView) {
            super(rootView);
            mRootView = rootView;
            mTitle = (TextView) rootView.findViewById(R.id.tv_notice_title);
            mTime = (TextView) rootView.findViewById(R.id.tv_notice_time);
            mDescribe = (TextView) rootView.findViewById(R.id.tv_notice_describe);
            mImg = (ImageView) rootView.findViewById(R.id.iv_notice_img);
            mView = (LinearLayout) rootView.findViewById(R.id.ll_notice_view);
        }
    }
}
