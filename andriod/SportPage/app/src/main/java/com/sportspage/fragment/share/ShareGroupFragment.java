package com.sportspage.fragment.share;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.adapter.GroupAdapter;
import com.sportspage.common.API;
import com.sportspage.common.BaseFragment;
import com.sportspage.common.RecyclerClickListener;
import com.sportspage.entity.GroupResult;
import com.sportspage.message.ShareClubMessage;
import com.sportspage.message.ShareMessage;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.rong.imkit.RongIM;
import io.rong.imlib.IRongCallback;
import io.rong.imlib.RongIMClient;
import io.rong.imlib.model.Conversation;
import io.rong.imlib.model.Message;
import io.rong.imlib.model.MessageContent;

@ContentView(R.layout.activity_group_list)
public class ShareGroupFragment extends BaseFragment implements RecyclerClickListener{
    private Activity mContent;
    @ViewInject(R.id.layout_title)
    private RelativeLayout mTitleLayout;
    @ViewInject(R.id.rlv_group_list)
    private RecyclerView mRecyclerView;
    private List<GroupResult.Group> mDatas;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = x.view().inject(this, inflater, container);
        mContent = this.getActivity();
        init();
        getDatas();
        return view;
    }


    private void init() {
        mTitleLayout.setVisibility(View.GONE);
        mDatas = new ArrayList<>();
        mRecyclerView.setLayoutManager(new LinearLayoutManager(mContent));
        GroupAdapter adapter = new GroupAdapter(mContent, mDatas);
        mRecyclerView.setAdapter(adapter);
        adapter.setmListener(this);
    }


    private void getDatas() {
        String userId = Utils.getValue(mContent,"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        Xutils.getInstance(mContent).get(API.GET_MY_GROUPS, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                GroupResult groupResult = Utils.parseJsonWithGson(result,GroupResult.class);
                mDatas.addAll(groupResult.getData());
                mRecyclerView.getAdapter().notifyDataSetChanged();
            }

            @Override
            public void onFinished() {

            }
        });

    }


    @Override
    public void onRecycleItemClick(final int position) {
        MessageContent shareMessage;
        String imageUrl = mContent.getIntent().getStringExtra("imageUrl");
        String shareTitle = mContent.getIntent().getStringExtra("shareTitle");
        String content = mContent.getIntent().getStringExtra("content");
        if ("club".equals(mContent.getIntent().getStringExtra("type"))){
            String clubId = mContent.getIntent().getStringExtra("clubId");
            shareMessage = ShareClubMessage.obtain(clubId,imageUrl,shareTitle,content);
        } else {
            String eventId = mContent.getIntent().getStringExtra("eventId");
            shareMessage = ShareMessage.obtain(eventId,imageUrl,shareTitle,content);
        }
        Message message = new Message();
        message.setContent(shareMessage);
        message.setTargetId(mDatas.get(position).getId());
        message.setConversationType(Conversation.ConversationType.GROUP);
        if (mContent.getIntent() != null) {
            RongIM.getInstance().sendMessage(message, content, "", new IRongCallback.ISendMediaMessageCallback() {
                @Override
                public void onProgress(Message message, int i) {

                }

                @Override
                public void onCanceled(Message message) {
                    Logger.d("取消");
                }

                @Override
                public void onAttached(Message message) {

                }

                @Override
                public void onSuccess(Message message) {
                    RongIM.getInstance().startGroupChat(mContent,message.getTargetId(),mDatas.get(position).getName());
                }

                @Override
                public void onError(Message message, RongIMClient.ErrorCode errorCode) {
                    Utils.showShortToast(x.app(),"出错了");
                }
            });
        }
    }
}
