package com.sportspage.receiver;

import android.content.Context;
import android.text.Spannable;
import android.text.SpannableString;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.message.ShareClubMessage;
import com.sportspage.message.ShareMessage;
import com.sportspage.utils.LogicUtils;
import com.sportspage.utils.Utils;
import com.zhy.autolayout.utils.ScreenUtils;

import io.rong.imkit.model.ProviderTag;
import io.rong.imkit.model.UIMessage;
import io.rong.imkit.widget.provider.IContainerItemProvider;
import io.rong.imlib.model.Message;

/**
 * Created by Bob on 2015/4/17.
 * 自定义消息模板
 */
@ProviderTag(messageContent = ShareClubMessage.class)
public class ShareClubMessageProvider extends IContainerItemProvider.MessageProvider<ShareClubMessage> {

    @Override
    public View newView(Context context, ViewGroup group) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_share, null);
        ViewHolder viewHolder = new ViewHolder();
        viewHolder.layout = (LinearLayout) view.findViewById(R.id.ll_item_share);
        viewHolder.portrait = (ImageView) view.findViewById(R.id.iv_share_img);
        viewHolder.title = (TextView) view.findViewById(R.id.tv_share_title);
        viewHolder.content = (TextView) view.findViewById(R.id.tv_share_content);
        view.setTag(viewHolder);
        return view;
    }

    @Override
    public void bindView(View view, int i, ShareClubMessage shareMessage, UIMessage uiMessage) {
        Logger.d("Message====="+shareMessage.toString());
        ViewHolder holder = (ViewHolder) view.getTag();
        FrameLayout.LayoutParams params = (FrameLayout.LayoutParams) holder.layout.getLayoutParams();
        if (uiMessage.getMessageDirection() == Message.MessageDirection.SEND) {
            //消息方向，自己发送的
            params.setMargins(150,0,0,0);
            holder.layout.setBackgroundResource(io.rong.imkit.R.drawable.rc_ic_bubble_right);
        } else {
            params.setMargins(0,0,150,0);
            holder.layout.setBackgroundResource(io.rong.imkit.R.drawable.rc_ic_bubble_left);
        }
        holder.layout.setLayoutParams(params);
        LogicUtils.loadImageFromUrl(holder.portrait,shareMessage.getImageUrl());
        holder.content.setText(shareMessage.getContent());
        holder.title.setText(shareMessage.getShareTitle());
    }

    @Override
    public Spannable getContentSummary(ShareClubMessage shareMessage) {
        return new SpannableString("一条俱乐部的分享");
    }

    @Override
    public void onItemClick(View view, int i, ShareClubMessage shareMessage, UIMessage uiMessage) {
    }

    @Override
    public void onItemLongClick(View view, int i, ShareClubMessage shareMessage, final UIMessage uiMessage) {
    }

    private static class ViewHolder {
        LinearLayout layout;
        ImageView portrait;
        TextView content;
        TextView title;
    }
}
