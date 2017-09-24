package com.sportspage.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.sportspage.R;

import java.util.List;
import java.util.Map;

/**
 * Created by Tenma on 2016/12/16.
 */

public class CashbookAdapter extends RecyclerView.Adapter<CashbookAdapter.CashbookHodler> {
    private List<Map<String,String>> mDatas;
    private Context mContext;

    public CashbookAdapter(Context context ,List<Map<String,String>> datas ) {
        this.mDatas = datas;
        this.mContext = context;
    }


    @Override
    public CashbookHodler onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.item_cashbook,parent,false);
        CashbookAdapter.CashbookHodler cashbookHodler = new CashbookAdapter.CashbookHodler(rootView);
        return cashbookHodler;
    }

    @Override
    public void onBindViewHolder(CashbookHodler holder, int position) {
        holder.mType.setText(mDatas.get(position).get("remark"));
        holder.mTime.setText(mDatas.get(position).get("time"));
        holder.mBalance.setText(mDatas.get(position).get("balance"));
        holder.mMoney.setText(mDatas.get(position).get("amount"));
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    class CashbookHodler extends RecyclerView.ViewHolder {

        TextView mType;
        TextView mTime;
        TextView mBalance;
        TextView mMoney;


        public CashbookHodler(View rootView) {
            super(rootView);
            mType= (TextView) rootView.findViewById(R.id.tv_cashbook_type);
            mTime = (TextView) rootView.findViewById(R.id.tv_cashbook_time);
            mBalance = (TextView) rootView.findViewById(R.id.tv_cashbook_balance);
            mMoney = (TextView) rootView.findViewById(R.id.tv_cashbook_money);
        }
    }
}
