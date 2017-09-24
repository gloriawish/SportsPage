package com.sportspage.entity;

/**
 * Created by Tenma on 2016/12/6.
 */

public class UserInfoResult {


    /**
     * code : 200
     * result : {"id":"16","uname":"mZhrCK","mobile":null,"nick":"天马","sex":"男","email":null,"idcard":null,"area":null,"city":null,"portrait":"http://wx.qlogo.cn/mmopen/bBCXfVgPcicHZuXqMM0HNpYbjQnAibt3UPJibR7jeTWSSyT9iaKicMFueIRjWtvdJlAEDkwLCddZlYY3ck1CG8xckhtEKYjBv6iaOX/0","wx_openid":"o2q3hwsHeOL9eSKZMTWJTWxD3jyE","wxpub_openid":null,"unionid":"oVhw5vx--cuPUFMvv5n2rWLX5ldU","token":"0eHHh+pqqAwoWU4LN5MYRW83TCgZ08EqPcx0VME7r/+k/TYIy3f3P9Q5CZMKUyQ5LFM3aKsRvwXIIoVRR34d5Q==","channel":"微信","login_time":null,"reg_time":"2016-12-06 22:42:28","status":null,"portrait_status":null,"valid":"1"}
     */

    private int code;
    private ResultBean result;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public ResultBean getResult() {
        return result;
    }

    public void setResult(ResultBean result) {
        this.result = result;
    }

    public static class ResultBean {
        /**
         * id : 16
         * uname : mZhrCK
         * mobile : null
         * nick : 天马
         * sex : 男
         * email : null
         * idcard : null
         * area : null
         * city : null
         * portrait : http://wx.qlogo.cn/mmopen/bBCXfVgPcicHZuXqMM0HNpYbjQnAibt3UPJibR7jeTWSSyT9iaKicMFueIRjWtvdJlAEDkwLCddZlYY3ck1CG8xckhtEKYjBv6iaOX/0
         * wx_openid : o2q3hwsHeOL9eSKZMTWJTWxD3jyE
         * wxpub_openid : null
         * unionid : oVhw5vx--cuPUFMvv5n2rWLX5ldU
         * token : 0eHHh+pqqAwoWU4LN5MYRW83TCgZ08EqPcx0VME7r/+k/TYIy3f3P9Q5CZMKUyQ5LFM3aKsRvwXIIoVRR34d5Q==
         * channel : 微信
         * login_time : null
         * reg_time : 2016-12-06 22:42:28
         * status : null
         * portrait_status : null
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
        private String token;
        private String channel;
        private String login_time;
        private String reg_time;
        private String status;
        private String portrait_status;
        private String valid;
        private boolean checked;

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

        public boolean isChecked() {
            return checked;
        }

        public void setChecked(boolean checked) {
            this.checked = checked;
        }
    }
}
