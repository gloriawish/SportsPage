package com.sportspage.entity;

import java.util.List;

/**
 * Created by Tenma on 2017/1/5.
 */

public class FriendsResult {

    /**
     * size : 1
     * data : [{"id":"10012","uname":"Fyd3OV","mobile":"15801927704","nick":"Absolute","sex":"男","email":"532634393@qq.com","idcard":"","area":"","city":"上海 杨浦区","portrait":"http://image.sportspage.cn/upload/portrait/20161220001653658.jpg","wx_openid":"oHx7GwDs5d0OFXnyUY84wFF2V710","wxpub_openid":"o73ymwI3unlueOrAjIVYJNJrUpIw","unionid":"oVhw5vx6HxqsgcLtsmEUGU87Y8IE","channel":"官方","login_time":"","reg_time":"2016-12-19 15:27:19","status":"0","portrait_status":"","valid":"1"}]
     */

    private int size;
    private List<User> data;

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public List<User> getData() {
        return data;
    }

    public void setData(List<User> data) {
        this.data = data;
    }

    public static class User {
        /**
         * id : 10012
         * uname : Fyd3OV
         * mobile : 15801927704
         * nick : Absolute
         * sex : 男
         * email : 532634393@qq.com
         * idcard :
         * area :
         * city : 上海 杨浦区
         * portrait : http://image.sportspage.cn/upload/portrait/20161220001653658.jpg
         * wx_openid : oHx7GwDs5d0OFXnyUY84wFF2V710
         * wxpub_openid : o73ymwI3unlueOrAjIVYJNJrUpIw
         * unionid : oVhw5vx6HxqsgcLtsmEUGU87Y8IE
         * channel : 官方
         * login_time :
         * reg_time : 2016-12-19 15:27:19
         * status : 0
         * portrait_status :
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
}
