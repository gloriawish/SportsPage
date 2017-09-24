package com.sportspage.entity;

/**
 * Created by sportspage on 2017/1/9.
 */

public class LastEventResult {

    /**
     * id : 1
     * sport_id : 10000
     * user_id : 10000
     * team_type : 1
     * charge_type : 2
     * privacy : 1
     * level : 1
     * min_number : 5
     * max_number : null
     * price : 66.00
     * start_time : 2017-01-10 08:30:00
     * duration : 2.00
     * operate_time : null
     * status : 4
     * time : 2017-01-09 13:57:29
     */

    private String id;
    private String sport_id;
    private String user_id;
    private String team_type;
    private String charge_type;
    private String privacy;
    private String level;
    private String min_number;
    private String max_number;
    private String price;
    private String start_time;
    private String duration;
    private Object operate_time;
    private String status;
    private String time;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSport_id() {
        return sport_id;
    }

    public void setSport_id(String sport_id) {
        this.sport_id = sport_id;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getTeam_type() {
        return team_type;
    }

    public void setTeam_type(String team_type) {
        this.team_type = team_type;
    }

    public String getCharge_type() {
        return charge_type;
    }

    public void setCharge_type(String charge_type) {
        this.charge_type = charge_type;
    }

    public String getPrivacy() {
        return privacy;
    }

    public void setPrivacy(String privacy) {
        this.privacy = privacy;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getMin_number() {
        return min_number;
    }

    public void setMin_number(String min_number) {
        this.min_number = min_number;
    }

    public String getMax_number() {
        return max_number;
    }

    public void setMax_number(String max_number) {
        this.max_number = max_number;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getStart_time() {
        return start_time;
    }

    public void setStart_time(String start_time) {
        this.start_time = start_time;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public Object getOperate_time() {
        return operate_time;
    }

    public void setOperate_time(Object operate_time) {
        this.operate_time = operate_time;
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
}
