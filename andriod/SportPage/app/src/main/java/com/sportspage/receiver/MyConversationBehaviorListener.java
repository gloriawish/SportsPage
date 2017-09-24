package com.sportspage.receiver;

import android.content.Context;
import android.content.Intent;
import android.view.View;

import com.sportspage.R;
import com.sportspage.activity.ClubActivity;
import com.sportspage.activity.SportsDetailActivity;
import com.sportspage.activity.UserDetailActivity;
import com.sportspage.message.ShareClubMessage;
import com.sportspage.message.ShareMessage;
import com.sportspage.utils.Utils;

import io.rong.imkit.RongIM;
import io.rong.imkit.utilities.OptionsPopupDialog;
import io.rong.imlib.model.Conversation;
import io.rong.imlib.model.Message;
import io.rong.imlib.model.UserInfo;

/**
 * Created by Tenma on 2017/1/8.
 */

public class MyConversationBehaviorListener implements RongIM.ConversationBehaviorListener {
    @Override
    public boolean onUserPortraitClick(Context context, Conversation.ConversationType conversationType, UserInfo userInfo) {
        Intent intent = new Intent();
        intent.putExtra("userId",userInfo.getUserId());
        intent.putExtra("nick", userInfo.getName());
        intent.putExtra("email", "");
        intent.putExtra("city", "上海 上海");
        intent.putExtra("portrait", userInfo.getPortraitUri());
        intent.setClass(context, UserDetailActivity.class);
        context.startActivity(intent);
        return true;
    }

    @Override
    public boolean onUserPortraitLongClick(Context context, Conversation.ConversationType conversationType, UserInfo userInfo) {
        return false;
    }

    @Override
    public boolean onMessageClick(Context context, View view, Message message) {
        if (message.getContent() instanceof ShareMessage){
            ShareMessage shareMessage = (ShareMessage) message.getContent();
            Intent intent = new Intent();
            intent.putExtra("eventId",shareMessage.getEventId());
            intent.setClass(context, SportsDetailActivity.class);
            context.startActivity(intent);
            return true;
        } else if (message.getContent() instanceof ShareClubMessage) {
            ShareClubMessage shareClubMessage = (ShareClubMessage) message.getContent();
            Intent intent = new Intent();
            intent.putExtra("clubId",shareClubMessage.getclubId());
            intent.setClass(context, ClubActivity.class);
            context.startActivity(intent);
            return true;
        }
        return false;
    }

    @Override
    public boolean onMessageLinkClick(Context context, String s) {
        return false;
    }

    @Override
    public boolean onMessageLongClick(Context context, View view, final Message message) {
        String[] items;
        items = new String[]{view.getContext().getResources().getString(R.string.de_dialog_item_message_delete)};
        OptionsPopupDialog.newInstance(view.getContext(), items).setOptionsPopupDialogListener(new OptionsPopupDialog.OnOptionsItemClickedListener() {
            @Override
            public void onOptionsItemClicked(int which) {
                if (which == 0)
                    RongIM.getInstance().deleteMessages(new int[]{message.getMessageId()}, null);
            }
        }).show();
        return false;
    }
}
