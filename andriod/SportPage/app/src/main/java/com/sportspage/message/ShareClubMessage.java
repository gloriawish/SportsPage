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
 * Created by sportspage on 2017/1/10.
 */

@MessageTag(value = "SP:ClubShare", flag = MessageTag.ISCOUNTED | MessageTag.ISPERSISTED)
public class ShareClubMessage extends MessageContent {

    private String clubId;
    private String imageUrl;
    private String shareTitle;
    private String content;

    public ShareClubMessage() {

    }

    public ShareClubMessage(byte[] data) {
        String jsonStr = null;

        try {
            jsonStr = new String(data, "UTF-8");
        } catch (UnsupportedEncodingException e1) {
            Logger.d("exception");
        }
        try {
            JSONObject jsonObj = new JSONObject(jsonStr);

            if (jsonObj.has("clubId"))
                clubId = jsonObj.optString("clubId");
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
    public ShareClubMessage(Parcel in) {
        setclubId(ParcelUtils.readFromParcel(in));
        setImageUrl(ParcelUtils.readFromParcel(in));
        setShareTitle(ParcelUtils.readFromParcel(in));
        setContent(ParcelUtils.readFromParcel(in));
    }

    @Override
    public byte[] encode() {
        JSONObject jsonObj = new JSONObject();
        try {
            jsonObj.put("clubId", getclubId());
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
    public static final Creator<ShareClubMessage> CREATOR = new Creator<ShareClubMessage>() {

        @Override
        public ShareClubMessage createFromParcel(Parcel source) {
            return new ShareClubMessage(source);
        }

        @Override
        public ShareClubMessage[] newArray(int size) {
            return new ShareClubMessage[size];
        }
    };


    @Override
    public void writeToParcel(Parcel dest, int flags) {
        ParcelUtils.writeToParcel(dest, clubId);//该类为工具类，对消息中属性进行序列化
        ParcelUtils.writeToParcel(dest, imageUrl);//该类为工具类，对消息中属性进行序列化
        ParcelUtils.writeToParcel(dest, shareTitle);//该类为工具类，对消息中属性进行序列化
        ParcelUtils.writeToParcel(dest, content);//该类为工具类，对消息中属性进行序列化
    }

    public static ShareClubMessage obtain(String clubId, String url, String title, String content) {
        ShareClubMessage model = new ShareClubMessage();
        model.setContent(content);
        model.setShareTitle(title);
        model.setImageUrl(url);
        model.setclubId(clubId);
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

    public String getclubId() {
        return clubId;
    }

    public void setclubId(String clubId) {
        this.clubId = clubId;
    }

    @Override
    public String toString() {
        return "ShareMessage{" +
                "imageUrl='" + imageUrl + '\'' +
                ", content='" + content + '\'' +
                ", shareTitle='" + shareTitle + '\'' +
                ", clubId='" + clubId + '\'' +
                '}';
    }
}

