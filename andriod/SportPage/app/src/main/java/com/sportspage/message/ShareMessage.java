package com.sportspage.message;

import android.os.Parcel;
import android.text.TextUtils;

import com.orhanobut.logger.Logger;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;

import io.rong.common.ParcelUtils;
import io.rong.imlib.MessageTag;
import io.rong.imlib.model.MessageContent;

/**
 * Created by sportspage on 2017/1/10.
 */

@MessageTag(value = "SP:EventShare", flag = MessageTag.ISCOUNTED | MessageTag.ISPERSISTED)
public class ShareMessage extends MessageContent {

    private String eventId;
    private String imageUrl;
    private String shareTitle;
    private String content;

    public ShareMessage() {

    }

    public ShareMessage(byte[] data) {
        String jsonStr = null;

        try {
            jsonStr = new String(data, "UTF-8");
        } catch (UnsupportedEncodingException e1) {
            Logger.d("exception");
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

    //给消息赋值。
    public ShareMessage(Parcel in) {
        setEventId(ParcelUtils.readFromParcel(in));
        setImageUrl(ParcelUtils.readFromParcel(in));
        setShareTitle(ParcelUtils.readFromParcel(in));
        setContent(ParcelUtils.readFromParcel(in));
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

    /**
     * 读取接口，目的是要从Parcel中构造一个实现了Parcelable的类的实例处理。
     */
    public static final Creator<ShareMessage> CREATOR = new Creator<ShareMessage>() {

        @Override
        public ShareMessage createFromParcel(Parcel source) {
            return new ShareMessage(source);
        }

        @Override
        public ShareMessage[] newArray(int size) {
            return new ShareMessage[size];
        }
    };


    @Override
    public void writeToParcel(Parcel dest, int flags) {
        ParcelUtils.writeToParcel(dest, eventId);//该类为工具类，对消息中属性进行序列化
        ParcelUtils.writeToParcel(dest, imageUrl);//该类为工具类，对消息中属性进行序列化
        ParcelUtils.writeToParcel(dest, shareTitle);//该类为工具类，对消息中属性进行序列化
        ParcelUtils.writeToParcel(dest, content);//该类为工具类，对消息中属性进行序列化
    }

    public static ShareMessage obtain(String eventId, String url, String title, String content) {
        ShareMessage model = new ShareMessage();
        model.setContent(content);
        model.setShareTitle(title);
        model.setImageUrl(url);
        model.setEventId(eventId);
        return model;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getShareTitle() {
        return shareTitle;
    }

    public void setShareTitle(String shareTitle) {
        this.shareTitle = shareTitle;
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    @Override
    public String toString() {
        return "ShareMessage{" +
                "imageUrl='" + imageUrl + '\'' +
                ", content='" + content + '\'' +
                ", shareTitle='" + shareTitle + '\'' +
                ", eventId='" + eventId + '\'' +
                '}';
    }
}

