package com.sportspage.receiver;

import android.content.Context;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.method.LinkMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.message.ClubApplyMessage;
import com.sportspage.message.ClubApplyMessage;

import io.rong.imkit.RongIM;
import io.rong.imkit.model.ProviderTag;
import io.rong.imkit.model.UIMessage;
import io.rong.imkit.utilities.OptionsPopupDialog;
import io.rong.imkit.widget.provider.IContainerItemProvider;

/**
 * Created by Bob on 2015/4/17.
 * 如何自定义消息模板
 */
@ProviderTag(messageContent = ClubApplyMessage.class, showPortrait = false,
        centerInHorizontal = true, showProgress = false, showSummaryWithName = false)
public class ClubApplyMessageProvider extends
        IContainerItemProvider.MessageProvider<ClubApplyMessage> {

    @Override
    public void bindView(View v, int position, ClubApplyMessage content, UIMessage message) {
        ViewHolder viewHolder = (ViewHolder) v.getTag();
        if (content != null) {
           viewHolder.contentTextView.setText("加入俱乐部的申请");
        }
    }


    @Override
    public Spannable getContentSummary(ClubApplyMessage content) {
        if (content != null) {
            return new SpannableString("加入俱乐部的申请");
        }
        return null;
    }

    @Override
    public void onItemClick(View view, int position, ClubApplyMessage
            content, UIMessage message) {
    }

    @Override
    public void onItemLongClick(View view, int position, ClubApplyMessage content, final UIMessage message) {
        String[] items;
        items = new String[]{view.getContext().getResources().getString(R.string.de_dialog_item_message_delete)};
        OptionsPopupDialog.newInstance(view.getContext(), items).setOptionsPopupDialogListener(new OptionsPopupDialog.OnOptionsItemClickedListener() {
            @Override
            public void onOptionsItemClicked(int which) {
                if (which == 0)
                    RongIM.getInstance().deleteMessages(new int[]{message.getMessageId()}, null);
            }
        }).show();
    }

    @Override
    public View newView(Context context, ViewGroup group) {
        View view = LayoutInflater.from(context).inflate(R.layout.rc_item_group_information_notification_message, null);
        ViewHolder viewHolder = new ViewHolder();
        viewHolder.contentTextView = (TextView) view.findViewById(R.id.rc_msg);
        viewHolder.contentTextView.setMovementMethod(LinkMovementMethod.getInstance());
        view.setTag(viewHolder);
        return view;
    }


    private static class ViewHolder {
        TextView contentTextView;
    }
}
