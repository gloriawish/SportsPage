package com.sportspage.fragment.share;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.activity.UserDetailActivity;
import com.sportspage.adapter.ContactAdapter;
import com.sportspage.common.API;
import com.sportspage.common.BaseFragment;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.message.CustomizeMessage;
import com.sportspage.message.ShareClubMessage;
import com.sportspage.message.ShareMessage;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;
import com.sportspage.view.SideBar;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
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


//通讯录
@ContentView(R.layout.fragment_contacts)
public class ShareContactsFragment extends BaseFragment {
    private Activity mContent;
    @ViewInject(R.id.lv_contact)
    private ListView mContactList;
    @ViewInject(R.id.sideBar)
    private SideBar indexBar;
    @ViewInject(R.id.ll_contacts_group)
    private LinearLayout mGroupLayout;
    @ViewInject(R.id.layout_title)
    private RelativeLayout mTitleLayout;
    private TextView mDialogText;
    private ContactAdapter mAdapter;
    private WindowManager mWindowManager;
    private List<UserInfoResult.ResultBean> mDatas;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = x.view().inject(this, inflater, container);
        mContent = this.getActivity();
        mWindowManager = (WindowManager) mContent
                .getSystemService(Context.WINDOW_SERVICE);
        mDatas = new ArrayList<>();
        initViews();
        initData();
        return view;
    }

    private void initViews() {
        mTitleLayout.setVisibility(View.GONE);
        mGroupLayout.setVisibility(View.GONE);
        mAdapter = new ContactAdapter(mContent, mDatas);
        mDialogText = (TextView) LayoutInflater.from(getActivity()).inflate(
                R.layout.list_position, null);
        mDialogText.setVisibility(View.INVISIBLE);
        mContactList.setAdapter(mAdapter);
        indexBar.setTextView(mDialogText);
        indexBar.setListView(mContactList);
        WindowManager.LayoutParams lp = new WindowManager.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION,
                WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
                        | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT);
        mWindowManager.addView(mDialogText, lp);
    }

    private void initData() {
        getFriendData();
    }

    private void refresh() {
        mDatas.clear();
        initData();
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }


    public void getFriendData() {
        String userId = Utils.getValue(mContent, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        Xutils.getInstance(mContent).get(API.GET_FRIENDS, map, new Xutils.XCallBack() {
            @Override
            public void onResponse(String result) {
                try {
                    JSONObject resultObject = new JSONObject(result);
                    JSONObject data = resultObject.getJSONObject("data");
                    JSONArray value = data.getJSONArray("value");
                    mDatas.clear();
                    for (int i = 0; i < value.length(); i++) {
                        JSONArray array = value.getJSONArray(i);
                        for (int j = 0; j < array.length(); j++) {
                            JSONObject object = (JSONObject) array.get(j);
                            UserInfoResult.ResultBean bean = Utils.parseJsonWithGson(
                                    object.toString(), UserInfoResult.ResultBean.class);
                            mDatas.add(bean);
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                mAdapter.notifyDataSetChanged();
            }

            @Override
            public void onFinished() {

            }
        });
    }

    @Event(value = R.id.lv_contact, type = AdapterView.OnItemClickListener.class)
    private void itemClick(AdapterView<?> parent, View view, final int position, long id) {
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
        message.setConversationType(Conversation.ConversationType.PRIVATE);
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
                    RongIM.getInstance().startPrivateChat(mContent,message.getTargetId(),mDatas.get(position).getNick());
                }

                @Override
                public void onError(Message message, RongIMClient.ErrorCode errorCode) {
                    Utils.showShortToast(x.app(),"出错了");
                }
            });
        }
    }


}
