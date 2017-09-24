package com.sportspage.fragment;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.activity.CreateGroupActivity;
import com.sportspage.activity.SearchActivity;
import com.sportspage.utils.Utils;

import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import io.rong.imlib.model.Conversation;
import me.yokeyword.fragmentation.SupportFragment;


//消息
@ContentView(R.layout.fragment_msg)
public class MsgFragment extends SupportFragment {
    private Activity mContext;
    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.img_right)
    private ImageView mRightView;

    private String mTargetId;//对话对象id
    private ImageView conversation_back;
    private TextView conversation_name;
    private PopupWindow mPopupWindow;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = x.view().inject(this,inflater,container);
        init();
        mContext = getActivity();
        return view;
    }

    private void init() {
        mRightView.setVisibility(View.VISIBLE);
        mTitle.setText(R.string.chat);
        mRightView.setImageResource(R.drawable.icon_add);
        io.rong.imkit.fragment.ConversationListFragment fragment = (io.rong.imkit.fragment.ConversationListFragment) getChildFragmentManager().findFragmentById(R.id.conversationlist);

        Uri uri = Uri.parse("rong://" + getActivity().getApplicationInfo().packageName).buildUpon()
                .appendPath("conversationlist")
                .appendQueryParameter(Conversation.ConversationType.PRIVATE.getName(), "false") //设置私聊会话非聚合显示
                .appendQueryParameter(Conversation.ConversationType.GROUP.getName(), "false")//设置群组会话聚合显示
                .appendQueryParameter(Conversation.ConversationType.DISCUSSION.getName(), "false")//设置讨论组会话非聚合显示
                .appendQueryParameter(Conversation.ConversationType.SYSTEM.getName(), "false")//设置系统会话非聚合显示
                .build();

        fragment.setUri(uri);
    }

    @Event(R.id.img_right)
    private void showSelect(View v){
        View popupView = mContext.getLayoutInflater().inflate(R.layout.popupwindow_add, null);
        TextView addFriend = (TextView) popupView.findViewById(R.id.tv_add_friend);
        addFriend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPopupWindow.dismiss();
                Utils.start_Activity(mContext, SearchActivity.class);
            }
        });
        TextView createGroup = (TextView) popupView.findViewById(R.id.tv_add_group);
        createGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPopupWindow.dismiss();
                Utils.start_Activity(mContext, CreateGroupActivity.class);
            }
        });
        mPopupWindow = new PopupWindow(popupView, WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT, true);
        mPopupWindow.showAsDropDown(v,-mPopupWindow.getWidth()-v.getWidth(),9);
        mPopupWindow.setOutsideTouchable(true);

    }

}
