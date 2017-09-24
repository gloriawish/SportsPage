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
 * Created by sportspage on 2017/4/5.
 */

@MessageTag(value = "SP:ClubApply", flag = MessageTag.ISCOUNTED | MessageTag.ISPERSISTED)
public class ClubApplyMessage extends MessageContent {
    private String clubId;
    private String imageUrl;
    private String title;
    private String content;

    public ClubApplyMessage(byte[] data) {
        String jsonStr = null;

        try {
            jsonStr = new String(data, "UTF-8");
        } catch (UnsupportedEncodingException e1) {

        }

        try {
            JSONObject jsonObj = new JSONObject(jsonStr);

            if (jsonObj.has("clubId"))
                clubId = jsonObj.optString("clubId");
            if (jsonObj.has("content"))
                content = jsonObj.optString("content");
            if (jsonObj.has("imageUrl"))
                imageUrl = jsonObj.optString("imageUrl");
            if (jsonObj.has("title"))
                title = jsonObj.optString("title");

        } catch (JSONException e) {
            Logger.d(e.getMessage());
        }

    }

    @Override
    public byte[] encode() {
        JSONObject jsonObj = new JSONObject();

        try {
            jsonObj.put("clubId", getClubId());
            jsonObj.put("imageUrl", getImageUrl());
            jsonObj.put("title", getTitle());
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
        ParcelUtils.writeToParcel(dest, clubId);//该类为工具类，对消息中属性进行序列化
        ParcelUtils.writeToParcel(dest, imageUrl);//该类为工具类，对消息中属性进行序列化
        ParcelUtils.writeToParcel(dest, title);//该类为工具类，对消息中属性进行序列化
        ParcelUtils.writeToParcel(dest, content);//该类为工具类，对消息中属性进行序列化
    }

    public ClubApplyMessage() {
    }

    protected ClubApplyMessage(Parcel in) {
        clubId=ParcelUtils.readFromParcel(in);//该类为工具类，消息属性
        imageUrl=ParcelUtils.readFromParcel(in);//该类为工具类，消息属性
        title=ParcelUtils.readFromParcel(in);//该类为工具类，消息属性
        content=ParcelUtils.readFromParcel(in);//该类为工具类，消息属性
    }

    public static final Creator<ClubApplyMessage> CREATOR = new Creator<ClubApplyMessage>() {
        @Override
        public ClubApplyMessage createFromParcel(Parcel source) {
            return new ClubApplyMessage(source);
        }

        @Override
        public ClubApplyMessage[] newArray(int size) {
            return new ClubApplyMessage[size];
        }
    };

    public String getClubId() {
        return clubId;
    }

    public void setClubId(String clubId) {
        this.clubId = clubId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
