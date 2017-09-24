package com.sportspage.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.sportspage.R;
import com.sportspage.entity.ClubDetailResult;
import com.sportspage.utils.LogicUtils;

import java.util.List;

/**
 * Created by Tenma on 2016/12/16.
 */

public class ClubListAdapter extends SectionedRecyclerViewAdapter<ClubListAdapter.HeaderHolder,ClubListAdapter.ClubListHodler,RecyclerView.ViewHolder> {
    private Context mContext;
    private List<ClubDetailResult> mDatas;
    //记录title出现的位置
    private int mCreate,mAdmin,mJoin;

    private ClubListListener mListener;

    public ClubListAdapter(Context context, List<ClubDetailResult> datas) {
        this.mContext = context;
        this.mDatas = datas;
    }

    public void setListCount(int createCount,int adminCount,int joinCount) {
        mCreate = createCount;
        mAdmin = adminCount;
        mJoin = joinCount;
    }

    public void setmListener(ClubListListener listener) {
        mListener = listener;
    }

//    @Override
//    public ClubListHodler onCreateViewHolder(ViewGroup parent, int viewType) {
//        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_club,parent,false);
//        ClubListAdapter.ClubListHodler cashbookHodler = new ClubListAdapter.ClubListHodler(rootView);
//        return cashbookHodler;
//    }

    @Override
    protected int getSectionCount() {
        return 3;
    }

    @Override
    protected int getItemCountForSection(int section) {
        if (section == 0) {
            return mCreate;
        } else if (section == 1) {
            return mAdmin;
        } else if (section == 2) {
            return mJoin;
        }
        return 0;
    }

    @Override
    protected boolean hasFooterInSection(int section) {
        return false;
    }

    @Override
    protected HeaderHolder onCreateSectionHeaderViewHolder(ViewGroup parent, int viewType) {
        return new HeaderHolder(LayoutInflater.from(mContext).inflate(R.layout.item_club_title,parent,false));
    }

    @Override
    protected RecyclerView.ViewHolder onCreateSectionFooterViewHolder(ViewGroup parent, int viewType) {
        return null;
    }

    @Override
    protected ClubListHodler onCreateItemViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_club,parent,false);
        ClubListAdapter.ClubListHodler clubListHodler = new ClubListAdapter.ClubListHodler(rootView);
        return clubListHodler;
    }

    @Override
    protected void onBindSectionHeaderViewHolder(HeaderHolder holder, int section) {
        if (section == 0) {
            if (mCreate > 0) {
                holder.title.setText("我创建的");
                holder.title.setVisibility(View.VISIBLE);
            } else {
                holder.title.setVisibility(View.GONE);
            }
        } else if (section == 1) {
            if (mAdmin > 0) {
                holder.title.setText("我管理的");
                holder.title.setVisibility(View.VISIBLE);
            } else {
                holder.title.setVisibility(View.GONE);
            }
        } else if (section == 2) {
            if (mJoin > 0) {
                holder.title.setText("我加入的");
                holder.title.setVisibility(View.VISIBLE);
            } else {
                holder.title.setVisibility(View.GONE);
            }
        } else {
            holder.title.setVisibility(View.GONE);
        }
    }

    @Override
    protected void onBindSectionFooterViewHolder(RecyclerView.ViewHolder holder, int section) {

    }

    @Override
    protected void onBindItemViewHolder(ClubListHodler holder, int section, int position) {
        int realPosition = position;
        if (section == 1) {
            realPosition = position + mCreate;
        } else if (section == 2) {
            realPosition = position + mCreate + mAdmin;
        }
        Glide.with(mContext).load(mDatas.get(realPosition).getIcon()).into(holder.headView);
        Glide.with(mContext).load(LogicUtils.getTypeId(mDatas.get(realPosition)
                .getSport_item())).into(holder.type);
        holder.name.setText(mDatas.get(realPosition).getName());
        holder.pogressBar.setProgress(Integer.parseInt(mDatas.get(realPosition).getVitality()));
        if (mDatas.get(realPosition).getMax_vitality() !=null
                && !mDatas.get(realPosition).getMax_vitality().equals("")){
            holder.vitality.setText(mDatas.get(realPosition).getVitality()+"/"
                    +mDatas.get(realPosition).getMax_vitality());
        }
        holder.memberCount.setText(mDatas.get(realPosition).getMember_count());
        holder.sportspageCount.setText(mDatas.get(realPosition).getSport_count());
        final int finalRealPosition = realPosition;
        holder.rootView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mListener.itemClick(finalRealPosition);
            }
        });
    }

    class ClubListHodler extends RecyclerView.ViewHolder {

        ImageView headView;
        TextView name;
        ImageView type;
        ProgressBar pogressBar;
        TextView vitality;
        TextView memberCount;
        TextView sportspageCount;
        LinearLayout rootView;
        LinearLayout memberLayout;
        LinearLayout sportspageLayout;
        LinearLayout shareLayout;
        public ClubListHodler(View rootView) {
            super(rootView);
            this.rootView = (LinearLayout) rootView.findViewById(R.id.ll_club_list_item);
            headView = (ImageView) rootView.findViewById(R.id.iv_club_list_cover);
            name = (TextView) rootView.findViewById(R.id.tv_club_list_name);
            type = (ImageView) rootView.findViewById(R.id.iv_club_list_type);
            pogressBar = (ProgressBar) rootView.findViewById(R.id.pb_club_list_vitality);
            vitality = (TextView) rootView.findViewById(R.id.tv_club_list_vitality);
            memberCount = (TextView) rootView.findViewById(R.id.tv_club_list_member_count);
            sportspageCount = (TextView) rootView.findViewById(R.id.tv_club_list_sportspage_count);
            memberLayout = (LinearLayout) rootView.findViewById(R.id.ll_club_list_member);
            sportspageLayout = (LinearLayout) rootView.findViewById(R.id.ll_club_list_sportspage);
        }
    }

    class HeaderHolder extends RecyclerView.ViewHolder {
        TextView title;
        public HeaderHolder(View itemView) {
            super(itemView);
            title = (TextView) itemView.findViewById(R.id.tv_club_list_title);
        }
    }

    public interface ClubListListener {
        void itemClick(int position);
    }

}
