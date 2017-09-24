package com.sportspage.entity;

/**
 * Created by Tenma on 2017/1/6.
 */

public class SportsPageResult {

    /**
     * id : 10011
     * user_id : {"id":"10014","uname":"aPIYDu","mobile":"15216612540","nick":"Cynthia✨","sex":"女","email":"","idcard":"","area":"","city":"上海 浦东新区","portrait":"http://image.sportspage.cn/upload/portrait/6166520161220.jpg","wx_openid":"","wxpub_openid":"o73ymwFPy5a0OfGENMTdcyX8byWk","unionid":"oVhw5vzg0LI8xGZmkH1Gk0qMnbFo","channel":"公众号","login_time":"","reg_time":"2016-12-19 20:14:17","status":"0","portrait_status":"1","valid":"1"}
     * title : 出来踢球
     * portrait : http://image.sportspage.cn/upload/sport/20161221143058104.jpg
     * summary : 出来踢球
     * sport_type : 1
     * sport_item : 2
     * location : 浦东新区耀龙路121号
     * location_detail :
     * place : 美斯途后滩足球公园
     * latitude : 31.180056700921526
     * longitude : 121.47724177320906
     * geohash : wtw3kk1hbzueh6e6m66e0epb
     * active_times : 1
     * grade : 3
     * status : 1
     * time : 2016-12-21 14:30:58
     * deleted : 0
     * extend :
     * valid : 0
     * attetion : false
     */

    private String id;
    private String user_id;
    private String title;
    private String portrait;
    private String summary;
    private String sport_type;
    private String sport_item;
    private String location;
    private String location_detail;
    private String place;
    private String latitude;
    private String longitude;
    private String geohash;
    private String active_times;
    private String grade;
    private String status;
    private String time;
    private String deleted;
    private String extend;
    private String valid;
    private boolean attetion;
    private String last_active_time;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getPortrait() {
        return portrait;
    }

    public void setPortrait(String portrait) {
        this.portrait = portrait;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getSport_type() {
        return sport_type;
    }

    public void setSport_type(String sport_type) {
        this.sport_type = sport_type;
    }

    public String getSport_item() {
        return sport_item;
    }

    public void setSport_item(String sport_item) {
        this.sport_item = sport_item;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getLocation_detail() {
        return location_detail;
    }

    public void setLocation_detail(String location_detail) {
        this.location_detail = location_detail;
    }

    public String getPlace() {
        return place;
    }

    public void setPlace(String place) {
        this.place = place;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public String getGeohash() {
        return geohash;
    }

    public void setGeohash(String geohash) {
        this.geohash = geohash;
    }

    public String getActive_times() {
        return active_times;
    }

    public void setActive_times(String active_times) {
        this.active_times = active_times;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
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

    public String getDeleted() {
        return deleted;
    }

    public void setDeleted(String deleted) {
        this.deleted = deleted;
    }

    public String getExtend() {
        return extend;
    }

    public void setExtend(String extend) {
        this.extend = extend;
    }

    public String getValid() {
        return valid;
    }

    public void setValid(String valid) {
        this.valid = valid;
    }

    public boolean isAttetion() {
        return attetion;
    }

    public void setAttetion(boolean attetion) {
        this.attetion = attetion;
    }


    public String getLast_active_time() {
        return last_active_time;
    }

    public void setLast_active_time(String last_active_time) {
        this.last_active_time = last_active_time;
    }

}
