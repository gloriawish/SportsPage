package com.sportspage.receiver;

import android.content.Context;
import android.text.Spannable;
import android.text.SpannableString;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.message.CustomizeMessage;
import com.sportspage.utils.LogicUtils;

import io.rong.imkit.model.ProviderTag;
import io.rong.imkit.model.UIMessage;
import io.rong.imkit.widget.provider.IContainerItemProvider;
import io.rong.imlib.model.Message;

/**
 * Created by sportspage on 2017/1/11.
 */

@ProviderTag(messageContent = CustomizeMessage.class)
public class CustomizeMessageItemProvider extends IContainerItemProvider.MessageProvider<CustomizeMessage> {

    class ViewHolder {
        LinearLayout layout;
        TextView title;
        TextView content;
        ImageView img;
    }

    @Override
    public View newView(Context context, ViewGroup group) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_share, null);
        ViewHolder holder = new ViewHolder();
        holder.layout = (LinearLayout) view.findViewById(R.id.ll_item_share);
        holder.title = (TextView) view.findViewById(R.id.tv_share_title);
        holder.content = (TextView) view.findViewById(R.id.tv_share_content);
        holder.img = (ImageView) view.findViewById(R.id.iv_share_img);
        view.setTag(holder);
        return view;
    }


    @Override
    public void bindView(View view, int i, CustomizeMessage customizeMessage, UIMessage uiMessage) {
        ViewHolder holder = (ViewHolder) view.getTag();

        if (uiMessage.getMessageDirection() == Message.MessageDirection.SEND) {//消息方向，自己发送的
            holder.layout.setBackgroundResource(io.rong.imkit.R.drawable.rc_ic_bubble_right);
        } else {
            holder.layout.setBackgroundResource(io.rong.imkit.R.drawable.rc_ic_bubble_left);
        }
        LogicUtils.loadImageFromUrl(holder.img,customizeMessage.getImageUrl());
        holder.title.setText(customizeMessage.getShareTitle());
        holder.content.setText(customizeMessage.getContent());
    }

    @Override
    public Spannable getContentSummary(CustomizeMessage data) {
        return new SpannableString("这是一条自定义消息CustomizeMessage");
    }

    @Override
    public void onItemClick(View view, int i, CustomizeMessage customizeMessage, UIMessage uiMessage) {

    }

    @Override
    public void onItemLongClick(View view, int i, CustomizeMessage customizeMessage, UIMessage uiMessage) {

    }


}
