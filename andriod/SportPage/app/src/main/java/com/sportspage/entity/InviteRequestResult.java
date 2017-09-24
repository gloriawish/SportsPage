package com.sportspage.entity;

/**
 * Created by tenma on 4/5/17.
 */

public class InviteRequestResult {

    /**
     * id : 17
     * type : 2
     * club_id : 1
     * from_id : 10000
     * to_id : 10011
     * extend : 一起来俱乐部玩耍吧！
     * time : 2017-04-05 15:05:21
     * status : null
     * process_id : null
     * process_time : null
     */

    private String id;
    private String type;
    private String club_id;
    private String from_id;
    private String to_id;
    private String extend;
    private String time;
    private String club_name;
    private String icon;
    private String nick;
    private String portrait;
    private int status;
    private Object process_id;
    private Object process_time;


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getClub_id() {
        return club_id;
    }

    public void setClub_id(String club_id) {
        this.club_id = club_id;
    }

    public String getFrom_id() {
        return from_id;
    }

    public void setFrom_id(String from_id) {
        this.from_id = from_id;
    }

    public String getTo_id() {
        return to_id;
    }

    public void setTo_id(String to_id) {
        this.to_id = to_id;
    }

    public String getExtend() {
        return extend;
    }

    public void setExtend(String extend) {
        this.extend = extend;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Object getProcess_id() {
        return process_id;
    }

    public void setProcess_id(Object process_id) {
        this.process_id = process_id;
    }

    public Object getProcess_time() {
        return process_time;
    }

    public void setProcess_time(Object process_time) {
        this.process_time = process_time;
    }

    public String getClub_name() {
        return club_name;
    }

    public void setClub_name(String club_name) {
        this.club_name = club_name;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
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
