package com.sportspage.entity;

/**
 * Created by tenma on 3/29/17.
 */

public class ClubActive {


    /**
     * id : 3
     * club_id : 13
     * type : 10
     * extend : 10000
     * extend_1 : 谷歌
     * extend_2 : null
     * extend_3 : null
     * desc : 创建俱乐部
     * time : 2017-03-29 14:12:56
     */

    private String id;
    private String club_id;
    private String type;
    private String extend;
    private String extend_1;
    private Object extend_2;
    private Object extend_3;
    private String desc;
    private String time;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getClub_id() {
        return club_id;
    }

    public void setClub_id(String club_id) {
        this.club_id = club_id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getExtend() {
        return extend;
    }

    public void setExtend(String extend) {
        this.extend = extend;
    }

    public String getExtend_1() {
        return extend_1;
    }

    public void setExtend_1(String extend_1) {
        this.extend_1 = extend_1;
    }

    public Object getExtend_2() {
        return extend_2;
    }

    public void setExtend_2(Object extend_2) {
        this.extend_2 = extend_2;
    }

    public Object getExtend_3() {
        return extend_3;
    }

    public void setExtend_3(Object extend_3) {
        this.extend_3 = extend_3;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }
}
