package com.sportspage.receiver;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.text.Spannable;
import android.util.Log;
import android.view.View;

import com.orhanobut.logger.Logger;
import com.sportspage.activity.ApplyListActivity;
import com.sportspage.activity.InviteListActivity;
import com.sportspage.common.API;
import com.sportspage.message.ClubApplyMessage;
import com.sportspage.message.ClubInviteMessage;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;

import java.util.HashMap;
import java.util.Map;

import io.rong.imkit.RongIM;
import io.rong.imkit.model.UIConversation;
import io.rong.imlib.RongIMClient;
import io.rong.imlib.model.Conversation;
import io.rong.imlib.model.MessageContent;
import io.rong.message.ContactNotificationMessage;

/**
 * Created by Tenma on 2017/1/8.
 */

public class MyConversationListBehaviorListener implements RongIM.ConversationListBehaviorListener {

    private boolean mIsAgree = true;

    @Override
    public boolean onConversationPortraitClick(Context context, Conversation.ConversationType conversationType, String s) {
        Logger.d(s);
        if (conversationType == Conversation.ConversationType.PRIVATE) {
            if ("10000".equals(s)) {
                Intent intent = new Intent();
                intent.setClass(context, InviteListActivity.class);
                context.startActivity(intent);
                return true;
            } else if("10001".equals(s)) {
                Intent intent = new Intent();
                intent.setClass(context, InviteListActivity.class);
                context.startActivity(intent);
            }
        }
        return false;
    }

    @Override
    public boolean onConversationPortraitLongClick(Context context, Conversation.ConversationType conversationType, String s) {
        return false;
    }

    @Override
    public boolean onConversationLongClick(Context context, View view, UIConversation uiConversation) {
        return false;
    }

    @Override
    public boolean onConversationClick(final Context context, View view, final UIConversation uiConversation) {
        if (uiConversation.getMessageContent() instanceof ContactNotificationMessage) {
            contactMessage(context, uiConversation);
            return true;
        } else if (uiConversation.getMessageContent() instanceof ClubInviteMessage){
            Intent intent = new Intent();
            intent.setClass(context, InviteListActivity.class);
            context.startActivity(intent);
            setMessageRead(uiConversation);
            return true;
        } else if (uiConversation.getMessageContent() instanceof ClubApplyMessage) {
            Intent intent = new Intent();
            intent.setClass(context, ApplyListActivity.class);
            context.startActivity(intent);
            setMessageRead(uiConversation);
            return true;
        }
        return false;
    }

    private void setMessageRead(UIConversation uiConversation) {
        RongIM.getInstance().clearMessagesUnreadStatus(
                uiConversation.getConversationType(), uiConversation.getConversationTargetId(),
                new RongIMClient.ResultCallback<Boolean>() {
                    @Override
                    public void onSuccess(Boolean aBoolean) {
                        Logger.d(aBoolean+"");
                    }

                    @Override
                    public void onError(RongIMClient.ErrorCode errorCode) {
                        Logger.d(errorCode.getMessage());
                    }
                });
    }

    private void contactMessage(final Context context, final UIConversation uiConversation) {
        final ContactNotificationMessage message = (ContactNotificationMessage) uiConversation.getMessageContent();
        if (message.getOperation().equals(ContactNotificationMessage.CONTACT_OPERATION_REQUEST)) {
            AlertDialog mDialog = new AlertDialog.Builder(context)
                    .setNegativeButton("拒绝", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                        }
                    })
                    .setPositiveButton("同意", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            mIsAgree = true;
                            String userId = Utils.getValue(context, "userId");
                            Map<String, String> map = new HashMap<>();
                            map.put("userId", userId);
                            map.put("friendId", message.getSourceUserId());
                            map.put("isAccess", mIsAgree + "");
                            Xutils.getInstance(context).post(API.PROCESS_REQUEST_FRIEND, map,
                                    new Xutils.XCallBack() {
                                @Override
                                public void onResponse(String result) {
                                    RongIM.getInstance().removeConversation(
                                            uiConversation.getConversationType(),
                                            uiConversation.getConversationTargetId()
                                            , new RongIMClient.ResultCallback<Boolean>() {
                                                @Override
                                                public void onSuccess(Boolean aBoolean) {

                                                }

                                                @Override
                                                public void onError(
                                                        RongIMClient.ErrorCode errorCode) {

                                                }
                                            });
                                }

                                @Override
                                public void onFinished() {
                                }
                            });

                        }
                    })
                    .setTitle("好友处理").setMessage(message.getMessage()).show();
        }
    }
}
