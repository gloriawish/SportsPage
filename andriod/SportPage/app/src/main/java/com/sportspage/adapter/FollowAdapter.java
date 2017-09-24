package com.sportspage.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.makeramen.roundedimageview.RoundedImageView;
import com.sportspage.R;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.EventResult;
import com.sportspage.utils.DateUtils;
import com.sportspage.utils.LogicUtils;

import java.util.List;

/**
 * Created by Tenma on 2016/12/13.
 */

public class FollowAdapter extends RecyclerView.Adapter<FollowAdapter.SportsHolder> {

    private  List<EventResult.DataBean> mDatas;
    private Context mContext;
    private RecyclerClickListener mListener;

    public FollowAdapter(Context context ,  List<EventResult.DataBean> datas ) {
        this.mDatas = datas;
        this.mContext = context;
    }

    @Override
    public SportsHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_follow,parent,false);
        SportsHolder sportsHolder = new SportsHolder(rootView);
        return sportsHolder;
    }

    @Override
    public void onBindViewHolder(final SportsHolder holder, final int position) {
        holder.mRootView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mListener.onRecycleItemClick(position);
            }
        });
        LogicUtils.loadImageFromUrl(holder.mSportsImg,mDatas.get(position).getPortrait());
        holder.mTitle.setText(mDatas.get(position).getTitle());
        holder.mLocation.setText(mDatas.get(position).getLocation());
        if (mDatas.get(position).getStart_time() == null || mDatas.get(position).getStart_time().isEmpty()){
            holder.mTime.setText("时间待定");
        } else{
            holder.mTime.setText(DateUtils.getFormatTime(mDatas.get(position).getStart_time()
                    , "MM-dd HH:mm"));
        }
        holder.mNick.setText(mDatas.get(position).getUser_id().getNick());
        if (mDatas.get(position).getPrice() == null || mDatas.get(position).getPrice().isEmpty()){
            holder.mPrice.setText("金额待定");
        } else{
            holder.mPrice.setText(mDatas.get(position).getPrice()+"元/人");
        }
        int enrollNum = mDatas.get(position).get_enroll_user().size();
        switch (enrollNum){
            case 0:
                holder.mEnrollorLayout.setVisibility(View.GONE);
                holder.mNoEnrollor.setVisibility(View.VISIBLE);
                break;
            case 1:
                LogicUtils.loadImageFromUrl(holder.mEnrollor1,
                        mDatas.get(position).get_enroll_user().get(0).getPortrait());
                holder.mEnrollor2.setVisibility(View.GONE);
                holder.mEnrollor3.setVisibility(View.GONE);
                holder.mEnrollor4.setVisibility(View.GONE);
                break;
            case 2:
                LogicUtils.loadImageFromUrl(holder.mEnrollor1,
                        mDatas.get(position).get_enroll_user().get(0).getPortrait());
                LogicUtils.loadImageFromUrl(holder.mEnrollor2,
                        mDatas.get(position).get_enroll_user().get(1).getPortrait());
                holder.mEnrollor3.setVisibility(View.GONE);
                holder.mEnrollor4.setVisibility(View.GONE);
                break;
            case 3:
                LogicUtils.loadImageFromUrl(holder.mEnrollor1,
                        mDatas.get(position).get_enroll_user().get(0).getPortrait());
                LogicUtils.loadImageFromUrl(holder.mEnrollor2,
                        mDatas.get(position).get_enroll_user().get(1).getPortrait());
                LogicUtils.loadImageFromUrl(holder.mEnrollor3,
                        mDatas.get(position).get_enroll_user().get(2).getPortrait());
                holder.mEnrollor4.setVisibility(View.GONE);
                break;
            case 4:
                LogicUtils.loadImageFromUrl(holder.mEnrollor1,
                        mDatas.get(position).get_enroll_user().get(0).getPortrait());
                LogicUtils.loadImageFromUrl(holder.mEnrollor2,
                        mDatas.get(position).get_enroll_user().get(1).getPortrait());
                LogicUtils.loadImageFromUrl(holder.mEnrollor3,
                        mDatas.get(position).get_enroll_user().get(2).getPortrait());
                LogicUtils.loadImageFromUrl(holder.mEnrollor4,
                        mDatas.get(position).get_enroll_user().get(3).getPortrait());
                break;
            default:
                LogicUtils.loadImageFromUrl(holder.mEnrollor1,
                        mDatas.get(position).get_enroll_user().get(0).getPortrait());
                LogicUtils.loadImageFromUrl(holder.mEnrollor2,
                        mDatas.get(position).get_enroll_user().get(1).getPortrait());
                LogicUtils.loadImageFromUrl(holder.mEnrollor3,
                        mDatas.get(position).get_enroll_user().get(2).getPortrait());
                LogicUtils.loadImageFromUrl(holder.mEnrollor4,
                        mDatas.get(position).get_enroll_user().get(3).getPortrait());
        }
        holder.mNum.setText(mDatas.get(position).get_enroll_user().size() + "/"
                + mDatas.get(position).getMax_number());
        holder.mStar.setImageResource(LogicUtils.getStarId(mDatas.get(position).getGrade()));
    }


    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    public void setmListener(RecyclerClickListener mListener) {
        this.mListener = mListener;
    }

    class SportsHolder extends RecyclerView.ViewHolder {

        TextView mTitle;
        TextView mLocation;
        TextView mTime;
        TextView mNick;
        TextView mPrice;
        TextView mNum;
        TextView mNoEnrollor;
        ImageView mStar;
        LinearLayout mEnrollorLayout;
        RoundedImageView mEnrollor1;
        RoundedImageView mEnrollor2;
        RoundedImageView mEnrollor3;
        RoundedImageView mEnrollor4;
        ImageView mSportsImg;
        LinearLayout mRootView;


        public SportsHolder(View rootView) {
            super(rootView);
            mRootView = (LinearLayout) rootView.findViewById(R.id.ll_follow_layout);
            mTitle = (TextView) rootView.findViewById(R.id.tv_follow_title);
            mLocation = (TextView) rootView.findViewById(R.id.tv_follow_location);
            mTime = (TextView) rootView.findViewById(R.id.tv_follow_time);
            mNick = (TextView) rootView.findViewById(R.id.tv_follow_initiate);
            mPrice = (TextView) rootView.findViewById(R.id.tv_follow_price);
            mNum = (TextView) rootView.findViewById(R.id.tv_follow_num);
            mNoEnrollor = (TextView) rootView.findViewById(R.id.tv_focus_enroller);
            mStar = (ImageView) rootView.findViewById(R.id.iv_follow_star);
            mSportsImg = (ImageView) rootView.findViewById(R.id.iv_follow_img);
            mEnrollor1 = (RoundedImageView) rootView.findViewById(R.id.rv_follow_enrollor1);
            mEnrollor2 = (RoundedImageView) rootView.findViewById(R.id.rv_follow_enrollor2);
            mEnrollor3 = (RoundedImageView) rootView.findViewById(R.id.rv_follow_enrollor3);
            mEnrollor4 = (RoundedImageView) rootView.findViewById(R.id.rv_follow_enrollor4);
            mEnrollorLayout = (LinearLayout) rootView.findViewById(R.id.ll_sports_detail_img);

        }
    }

}



