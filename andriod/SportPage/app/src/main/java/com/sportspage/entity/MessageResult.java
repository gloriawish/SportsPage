package com.sportspage.entity;

/**
 * Created by Tenma on 2017/1/4.
 */

public class MessageResult {


    /**
     * id : 1
     * event_id : 1
     * user_id : 10000
     * reply_id : 0
     * content : 123
     * status : 1
     * time : 2017-01-10 10:41:09
     * nick : 天马
     * portrait : http://wx.qlogo.cn/mmopen/8btV9ttrLedo7z1V6OJTicM8zxiak4ibrNmQpJBFGTK2r5dFxgSEHGoCAiaYcr6jbAtzgNDwmLNLGY9pvTcP8mUZzR8hZVziaA12U/0
     */

    private String id;
    private String event_id;
    private String user_id;
    private String reply_id;
    private String content;
    private String status;
    private String time;
    private String nick;
    private String portrait;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getEvent_id() {
        return event_id;
    }

    public void setEvent_id(String event_id) {
        this.event_id = event_id;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getReply_id() {
        return reply_id;
    }

    public void setReply_id(String reply_id) {
        this.reply_id = reply_id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getNick() {
        return nick;
    }

    public void setNick(String nick) {
        this.nick = nick;
    }

    public String getPortrait() {
        return portrait;
    }

    public void setPortrait(String portrait) {
        this.portrait = portrait;
    }
}
