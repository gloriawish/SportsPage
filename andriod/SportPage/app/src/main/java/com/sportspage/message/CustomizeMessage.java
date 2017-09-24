package com.sportspage.message;

import android.os.Parcel;

import com.orhanobut.logger.Logger;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;

import io.rong.common.ParcelUtils;
import io.rong.imlib.MessageTag;
import io.rong.imlib.model.MessageContent;

/**
 * Created by sportspage on 2017/1/11.
 */

@MessageTag(value = "app:custom", flag = MessageTag.ISCOUNTED | MessageTag.ISPERSISTED)
public class CustomizeMessage extends MessageContent {
    private String eventId;
    private String imageUrl;
    private String shareTitle;
    private String content;

    public CustomizeMessage(byte[] data) {
        String jsonStr = null;

        try {
            jsonStr = new String(data, "UTF-8");
        } catch (UnsupportedEncodingException e1) {

        }

        try {
            JSONObject jsonObj = new JSONObject(jsonStr);

            if (jsonObj.has("eventId"))
                eventId = jsonObj.optString("eventId");
            if (jsonObj.has("content"))
                content = jsonObj.optString("content");
            if (jsonObj.has("imageUrl"))
                imageUrl = jsonObj.optString("imageUrl");
            if (jsonObj.has("shareTitle"))
                shareTitle = jsonObj.optString("shareTitle");

        } catch (JSONException e) {
            Logger.d(e.getMessage());
        }

    }

    @Override
    public byte[] encode() {
        JSONObject jsonObj = new JSONObject();

        try {
            jsonObj.put("eventId", getEventId());
            jsonObj.put("imageUrl", getImageUrl());
            jsonObj.put("shareTitle", getShareTitle());
            jsonObj.put("content", getContent());
        } catch (JSONException e) {
            Logger.d(e.getMessage());
        }

        try {
            return jsonObj.toString().getBytes("UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        return null;
    }


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        ParcelUtils.writeToParcel(dest, eventId);//该类为工具类，对消息中属性进行序列化
        ParcelUtils.writeToParcel(dest, imageUrl);//该类为工具类，对消息中属性进行序列化
        ParcelUtils.writeToParcel(dest, getShareTitle());//该类为工具类，对消息中属性进行序列化
        ParcelUtils.writeToParcel(dest, content);//该类为工具类，对消息中属性进行序列化
    }

    public CustomizeMessage() {
    }

    protected CustomizeMessage(Parcel in) {
        eventId=ParcelUtils.readFromParcel(in);//该类为工具类，消息属性
        imageUrl=ParcelUtils.readFromParcel(in);//该类为工具类，消息属性
        setShareTitle(ParcelUtils.readFromParcel(in));//该类为工具类，消息属性
        content=ParcelUtils.readFromParcel(in);//该类为工具类，消息属性
    }

    public static final Creator<CustomizeMessage> CREATOR = new Creator<CustomizeMessage>() {
        @Override
        public CustomizeMessage createFromParcel(Parcel source) {
            return new CustomizeMessage(source);
        }

        @Override
        public CustomizeMessage[] newArray(int size) {
            return new CustomizeMessage[size];
        }
    };

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getShareTitle() {
        return shareTitle;
    }

    public void setShareTitle(String shareTitle) {
        this.shareTitle = shareTitle;
    }
}
