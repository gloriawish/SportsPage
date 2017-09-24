package com.sportspage.fragment.detail;

import android.app.Activity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.adapter.FocusRecordAdapter;
import com.sportspage.adapter.MessageAdapter;
import com.sportspage.common.BaseFragment;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.FocusResult;
import com.sportspage.entity.MessageResult;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.List;

@ContentView(R.layout.fragment_message)
public class MessageFragment extends BaseFragment implements RecyclerClickListener {

    @ViewInject(R.id.rv_message_list)
    private RecyclerView mRecyclerView;
    @ViewInject(R.id.tv_message)
    private TextView mNoMessage;

    private Activity mContext;
    private List<MessageResult> mDatas;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = x.view().inject(this, inflater, container);
        mContext = getActivity();
        init();
        return view;
    }

    private void init() {
        mDatas = new ArrayList<>();
        mRecyclerView.setLayoutManager(new LinearLayoutManager(mContext));
        MessageAdapter adapter = new MessageAdapter(mContext,mDatas);
        mRecyclerView.setAdapter(adapter);
        adapter.setmListener(this);
    }

    public void setmDatas(List<MessageResult> datas) {
        if (datas == null) {
            return;
        }
        this.mDatas.addAll(datas);
        if (mDatas.size() != 0 && mDatas.size() < 3) {
            mNoMessage.setVisibility(View.GONE);
            mRecyclerView.setVisibility(View.VISIBLE);
        } else if(mDatas.size()>=3){
            mRecyclerView.setVisibility(View.VISIBLE);
            mNoMessage.setText("查看更多");
        }
        mRecyclerView.getAdapter().notifyDataSetChanged();
    }

    public void addData(MessageResult messageResult) {
        mDatas.add(0,messageResult);
        if(mDatas.size()>=3){
            mNoMessage.setVisibility(View.VISIBLE);
            mNoMessage.setText("查看更多");
        } else {
            mNoMessage.setVisibility(View.GONE);
            mRecyclerView.setVisibility(View.VISIBLE);
        }
        mRecyclerView.getAdapter().notifyDataSetChanged();
    }

    @Override
    public void onRecycleItemClick(int position) {

    }
}
