package com.sportspage.entity;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by Tenma on 2016/12/29.
 */

public class SportDetailResult {

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
     * status : 3
     * deleted : 0
     * extend :
     * valid : 0
     * event_id : 11
     * charge_type : 2
     * privacy : 1
     * level : 2
     * min_number : 5
     * max_number : 10
     * price : 33.00
     * start_time : 2016-12-22 18:00:00
     * duration : 2.00
     * end_time : 2016-12-22 20:00:00
     * _portrait : ["http://image.sportspage.cn/upload/sport/20161221143058104.jpg"]
     * _enroll_user : [{"id":"10017","uname":"9ghfY8","mobile":"15618133438","nick":"超纯的小白兔🐰","sex":"男","email":"zhujunxxxxx@163.com","idcard":"","area":"","city":"Shanghai Po","portrait":"http://image.sportspage.cn/upload/portrait/20161222100756389.jpg","wx_openid":"","wxpub_openid":"o73ymwLYiBCX-r6iQzicdLYo4hvQ","unionid":"oVhw5vzFo13JYOInDrvgfvf-jZf0","token":"7ImUD6BwL5NiVXNcqjrUaf5Oxu9c7crDyX0l+0ax5VpYvWhDtNvcL3N2/+fYtTlpYD5rZumnbnCmtQdhm8XBRg==","channel":"公众号","login_time":"","reg_time":"2016-12-19 22:05:27","relation":0}]
     * _message : []
     * user_status : 进行中
     * attetion : false
     * relation : 0
     */

    private String id;
    @SerializedName("user_id")
    private UserBean user;
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
    private String deleted;
    private String extend;
    private String valid;
    private String event_id;
    private String charge_type;
    private String privacy;
    private String level;
    private String min_number;
    private String max_number;
    private String price;
    private String start_time;
    private String duration;
    private String end_time;
    private String user_status;
    private boolean attetion;
    private int relation;
    private List<String> _portrait;
    private List<EnrollUserBean> _enroll_user;
    private List<MessageResult> _message;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public UserBean getUser() {
        return user;
    }

    public void setUser(UserBean user) {
        this.user = user;
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

    public String getEnd_time() {
        return end_time;
    }

    public void setEnd_time(String end_time) {
        this.end_time = end_time;
    }

    public String getUser_status() {
        return user_status;
    }

    public void setUser_status(String user_status) {
        this.user_status = user_status;
    }

    public boolean isAttetion() {
        return attetion;
    }

    public void setAttetion(boolean attetion) {
        this.attetion = attetion;
    }

    public int getRelation() {
        return relation;
    }

    public void setRelation(int relation) {
        this.relation = relation;
    }

    public List<String> get_portrait() {
        return _portrait;
    }

    public void set_portrait(List<String> _portrait) {
        this._portrait = _portrait;
    }

    public List<EnrollUserBean> get_enroll_user() {
        return _enroll_user;
    }

    public void set_enroll_user(List<EnrollUserBean> _enroll_user) {
        this._enroll_user = _enroll_user;
    }

    public List<MessageResult> get_message() {
        return _message;
    }

    public void set_message(List<MessageResult> _message) {
        this._message = _message;
    }

    public static class UserBean {
        /**
         * id : 10014
         * uname : aPIYDu
         * mobile : 15216612540
         * nick : Cynthia✨
         * sex : 女
         * email :
         * idcard :
         * area :
         * city : 上海 浦东新区
         * portrait : http://image.sportspage.cn/upload/portrait/6166520161220.jpg
         * wx_openid :
         * wxpub_openid : o73ymwFPy5a0OfGENMTdcyX8byWk
         * unionid : oVhw5vzg0LI8xGZmkH1Gk0qMnbFo
         * channel : 公众号
         * login_time :
         * reg_time : 2016-12-19 20:14:17
         * status : 0
         * portrait_status : 1
         * valid : 1
         */

        private String id;
        private String uname;
        private String mobile;
        private String nick;
        private String sex;
        private String email;
        private String idcard;
        private String area;
        private String city;
        private String portrait;
        private String wx_openid;
        private String wxpub_openid;
        private String unionid;
        private String channel;
        private String login_time;
        private String reg_time;
        private String status;
        private String portrait_status;
        private String valid;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getUname() {
            return uname;
        }

        public void setUname(String uname) {
            this.uname = uname;
        }

        public String getMobile() {
            return mobile;
        }

        public void setMobile(String mobile) {
            this.mobile = mobile;
        }

        public String getNick() {
            return nick;
        }

        public void setNick(String nick) {
            this.nick = nick;
        }

        public String getSex() {
            return sex;
        }

        public void setSex(String sex) {
            this.sex = sex;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getIdcard() {
            return idcard;
        }

        public void setIdcard(String idcard) {
            this.idcard = idcard;
        }

        public String getArea() {
            return area;
        }

        public void setArea(String area) {
            this.area = area;
        }

        public String getCity() {
            return city;
        }

        public void setCity(String city) {
            this.city = city;
        }

        public String getPortrait() {
            return portrait;
        }

        public void setPortrait(String portrait) {
            this.portrait = portrait;
        }

        public String getWx_openid() {
            return wx_openid;
        }

        public void setWx_openid(String wx_openid) {
            this.wx_openid = wx_openid;
        }

        public String getWxpub_openid() {
            return wxpub_openid;
        }

        public void setWxpub_openid(String wxpub_openid) {
            this.wxpub_openid = wxpub_openid;
        }

        public String getUnionid() {
            return unionid;
        }

        public void setUnionid(String unionid) {
            this.unionid = unionid;
        }

        public String getChannel() {
            return channel;
        }

        public void setChannel(String channel) {
            this.channel = channel;
        }

        public String getLogin_time() {
            return login_time;
        }

        public void setLogin_time(String login_time) {
            this.login_time = login_time;
        }

        public String getReg_time() {
            return reg_time;
        }

        public void setReg_time(String reg_time) {
            this.reg_time = reg_time;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getPortrait_status() {
            return portrait_status;
        }

        public void setPortrait_status(String portrait_status) {
            this.portrait_status = portrait_status;
        }

        public String getValid() {
            return valid;
        }

        public void setValid(String valid) {
            this.valid = valid;
        }
    }

    public static class EnrollUserBean {
        /**
         * id : 10017
         * uname : 9ghfY8
         * mobile : 15618133438
         * nick : 超纯的小白兔🐰
         * sex : 男
         * email : zhujunxxxxx@163.com
         * idcard :
         * area :
         * city : Shanghai Po
         * portrait : http://image.sportspage.cn/upload/portrait/20161222100756389.jpg
         * wx_openid :
         * wxpub_openid : o73ymwLYiBCX-r6iQzicdLYo4hvQ
         * unionid : oVhw5vzFo13JYOInDrvgfvf-jZf0
         * token : 7ImUD6BwL5NiVXNcqjrUaf5Oxu9c7crDyX0l+0ax5VpYvWhDtNvcL3N2/+fYtTlpYD5rZumnbnCmtQdhm8XBRg==
         * channel : 公众号
         * login_time :
         * reg_time : 2016-12-19 22:05:27
         * relation : 0
         */

        private String id;
        private String uname;
        private String mobile;
        private String nick;
        private String sex;
        private String email;
        private String idcard;
        private String area;
        private String city;
        private String portrait;
        private String wx_openid;
        private String wxpub_openid;
        private String unionid;
        private String token;
        private String channel;
        private String login_time;
        private String reg_time;
        private int relation;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getUname() {
            return uname;
        }

        public void setUname(String uname) {
            this.uname = uname;
        }

        public String getMobile() {
            return mobile;
        }

        public void setMobile(String mobile) {
            this.mobile = mobile;
        }

        public String getNick() {
            return nick;
        }

        public void setNick(String nick) {
            this.nick = nick;
        }

        public String getSex() {
            return sex;
        }

        public void setSex(String sex) {
            this.sex = sex;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getIdcard() {
            return idcard;
        }

        public void setIdcard(String idcard) {
            this.idcard = idcard;
        }

        public String getArea() {
            return area;
        }

        public void setArea(String area) {
            this.area = area;
        }

        public String getCity() {
            return city;
        }

        public void setCity(String city) {
            this.city = city;
        }

        public String getPortrait() {
            return portrait;
        }

        public void setPortrait(String portrait) {
            this.portrait = portrait;
        }

        public String getWx_openid() {
            return wx_openid;
        }

        public void setWx_openid(String wx_openid) {
            this.wx_openid = wx_openid;
        }

        public String getWxpub_openid() {
            return wxpub_openid;
        }

        public void setWxpub_openid(String wxpub_openid) {
            this.wxpub_openid = wxpub_openid;
        }

        public String getUnionid() {
            return unionid;
        }

        public void setUnionid(String unionid) {
            this.unionid = unionid;
        }

        public String getToken() {
            return token;
        }

        public void setToken(String token) {
            this.token = token;
        }

        public String getChannel() {
            return channel;
        }

        public void setChannel(String channel) {
            this.channel = channel;
        }

        public String getLogin_time() {
            return login_time;
        }

        public void setLogin_time(String login_time) {
            this.login_time = login_time;
        }

        public String getReg_time() {
            return reg_time;
        }

        public void setReg_time(String reg_time) {
            this.reg_time = reg_time;
        }

        public int getRelation() {
            return relation;
        }

        public void setRelation(int relation) {
            this.relation = relation;
        }
    }
}
