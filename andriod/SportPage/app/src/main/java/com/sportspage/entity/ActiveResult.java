package com.sportspage.entity;

/**
 * Created by Tenma on 2017/1/3.
 */

public class ActiveResult {

    /**
     * id : 10026
     * user_id : 10016
     * title : 2222
     * portrait : http://image.sportspage.cn/upload/sport/20161230120948518.jpg
     * summary : xxxx
     * sport_type : 1
     * sport_item : 5
     * location : 长宁区绥宁路(近天山西路)628号-36南空汽车修理厂内
     * location_detail : null
     * place : U.Time运动馆
     * latitude : 31.22243593086499
     * longitude : 121.3519827176795
     * geohash : wtw397vgf5utnc5fy5zwmz
     * active_times : 1
     * grade : 3
     * status : 1
     * time : 2016-12-30 12:09:48
     * deleted : 0
     * extend : null
     * valid : 0
     * event_id : 52
     */

    private String id;
    private String user_id;
    private String title;
    private String portrait;
    private String summary;
    private String sport_type;
    private String sport_item;
    private String location;
    private Object location_detail;
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
    private String event_id;
    private boolean checked;

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

    public Object getLocation_detail() {
        return location_detail;
    }

    public void setLocation_detail(Object location_detail) {
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

    public String getEvent_id() {
        return event_id;
    }

    public void setEvent_id(String event_id) {
        this.event_id = event_id;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }
}
