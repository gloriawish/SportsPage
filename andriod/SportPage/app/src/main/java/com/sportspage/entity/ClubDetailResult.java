package com.sportspage.entity;

import java.util.List;

/**
 * Created by tenma on 2/19/17.
 */

public class ClubDetailResult {

    /**
     * id : 1
     * name : 司徒王朗
     * user_id : 10000
     * description : null
     * capacity : 50
     * join_type : 1
     * invite_type : null
     * extend : null
     * level : null
     * portrait : http://image.sportspage.cn/upload/club/20170217174514277.jpg
     * sport_item : 0
     * icon : http://image.sportspage.cn/upload/club/20170217174514180.jpg
     * vitality : null
     * question : null
     * answer : null
     * time : 2017-02-17 17:45:14
     * leader : {"id":"10000","uname":"RPjAvq","mobile":"15215146881","nick":"天马","sex":"男","email":null,"idcard":null,"area":null,"city":"淮南 潘集","portrait":"http://image.sportspage.cn/upload/portrait/20170219202729516.jpg","wx_openid":"oHx7GwM4szeqnwOXSFwvgg1TnbO4","wxpub_openid":null,"unionid":"oVhw5vx--cuPUFMvv5n2rWLX5ldU","channel":"微信","login_time":null,"reg_time":"2017-01-08 21:26:16","status":"0","portrait_status":"0","valid":"1","qq_openid":null}
     * top_member : [{"id":"10000","uname":"RPjAvq","mobile":"15215146881","nick":"天马","sex":"男","email":null,"idcard":null,"area":null,"city":"淮南 潘集","portrait":"http://image.sportspage.cn/upload/portrait/20170219202729516.jpg","wx_openid":"oHx7GwM4szeqnwOXSFwvgg1TnbO4","wxpub_openid":null,"unionid":"oVhw5vx--cuPUFMvv5n2rWLX5ldU","channel":"微信","login_time":null,"reg_time":"2017-01-08 21:26:16","status":"0","portrait_status":"0","valid":"1","qq_openid":null},{"id":"10005","uname":"unyT9m","mobile":null,"nick":"覃波","sex":"男","email":null,"idcard":null,"area":null,"city":"Shanghai Changning","portrait":"http://wx.qlogo.cn/mmopen/PiajxSqBRaEJsW8icFicAJnJ4CpQkyA1wwuyGxYoK9SJiarTUvbQyPShCHnJ1waNByBhrtsKVQRnYF0XZiaMElEcWvQ/0","wx_openid":"oHx7GwD1G1MqHtCw-d-77UWML7WQ","wxpub_openid":null,"unionid":"oVhw5v0nkBmY3xSi5y_mg5Xx8mgI","channel":"微信","login_time":null,"reg_time":"2017-01-10 16:14:24","status":"0","portrait_status":"0","valid":"1","qq_openid":null},{"id":"10004","uname":"0dRw3F","mobile":"15216612540","nick":"游客56119","sex":"保密","email":null,"idcard":null,"area":null,"city":null,"portrait":"http://image.sportspage.cn/common/default/default.png","wx_openid":null,"wxpub_openid":null,"unionid":null,"channel":"官方","login_time":null,"reg_time":"2017-01-10 14:36:24","status":"0","portrait_status":null,"valid":"1","qq_openid":null},{"id":"10003","uname":"LwSpfD","mobile":null,"nick":"超纯的小白兔🐰","sex":"男","email":null,"idcard":null,"area":null,"city":"Shanghai Po","portrait":"http://wx.qlogo.cn/mmopen/pburdzLK7PVicH0RtSFjsetSgfPYoic7g2OOR83nAcvKtzehmW3MKgWGBohx6TV2hSxjUw1XoqbUtAzFh9hPkQTA/0","wx_openid":"oHx7GwK9yelVx0NHBLJIaK8DIq9E","wxpub_openid":null,"unionid":"oVhw5vzFo13JYOInDrvgfvf-jZf0","channel":"微信","login_time":null,"reg_time":"2017-01-10 10:04:45","status":"0","portrait_status":"0","valid":"1","qq_openid":null},{"id":"10002","uname":"UpPHgk","mobile":"13524911770","nick":"覃波","sex":"女","email":null,"idcard":null,"area":null,"city":" ","portrait":"http://wx.qlogo.cn/mmopen/vXpQUXibMALvuqOVvHXicqcQib6hj6oicsjQSJVGNWQMial1zI8xfkRaXpbt3JQeEqa31I5ueRFHDNEqyz3YacgQc8qXnibnduDohV/0","wx_openid":"oHx7GwNwzMbfaVpmYA3frlDF8Hzw","wxpub_openid":null,"unionid":"oVhw5vwRLGmrkg2_v-LnvOvbCgew","channel":"微信","login_time":null,"reg_time":"2017-01-09 18:20:28","status":"0","portrait_status":"0","valid":"1","qq_openid":null}]
     * ann : {"id":"5","club_id":"1","content":"test","time":"2017-02-17 20:17:22"}
     * sports : [{"id":"10000","user_id":"10000","title":"一起挤二号线","portrait":"http://image.sportspage.cn/upload/sport/20170109135700241.jpg","summary":"如果有机会","sport_type":"1","sport_item":"5","location":" 上海市闵行区沪闵路3458弄66号颛桥地铁站附近500米","location_detail":null,"place":"天空球场（闵行店）","latitude":"31.0678018964596","longitude":"121.40818072549531","geohash":"wtw2dxwxpdhcpdf6chjn4q","active_times":"4","grade":"3","status":"0","time":"2017-01-09 13:57:00","deleted":"0","extend":null,"valid":"0","last_active_time":null}]
     * op_permission : 3
     * actives : []
     * member_count : 5
     */

    private String id;
    private String name;
    private String user_id;
    private String description;
    private String capacity;
    private String join_type;
    private String invite_type;
    private String extend;
    private String level;
    private String portrait;
    private String sport_item;
    private String icon;
    private String vitality;
    private String question;
    private String answer;
    private String time;
    private String sport_count;
    private String sport_item_extend;
    private LeaderBean leader;
    private AnnBean ann;
    private int op_permission;
    private String member_count;
    private String max_vitality;
    private List<TopMemberBean> top_member;
    private List<SportsBean> sports;
    private List<ClubActive> actives;
    public String group_id = "";

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCapacity() {
        return capacity;
    }

    public void setCapacity(String capacity) {
        this.capacity = capacity;
    }

    public String getJoin_type() {
        return join_type;
    }

    public void setJoin_type(String join_type) {
        this.join_type = join_type;
    }

    public String getInvite_type() {
        return invite_type;
    }

    public void setInvite_type(String invite_type) {
        this.invite_type = invite_type;
    }

    public String getExtend() {
        return extend;
    }

    public void setExtend(String extend) {
        this.extend = extend;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getPortrait() {
        return portrait;
    }

    public void setPortrait(String portrait) {
        this.portrait = portrait;
    }

    public String getSport_item() {
        return sport_item;
    }

    public void setSport_item(String sport_item) {
        this.sport_item = sport_item;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getVitality() {
        return vitality;
    }

    public String getSport_count() {
        return sport_count;
    }

    public void setSport_count(String sport_count) {
        this.sport_count = sport_count;
    }

    public String getSport_item_extend() {
        return sport_item_extend;
    }

    public void setSport_item_extend(String sport_item_extend) {
        this.sport_item_extend = sport_item_extend;
    }

    public String getMax_vitality() {
        return max_vitality;
    }

    public void setMax_vitality(String max_vitality) {
        this.max_vitality = max_vitality;
    }

    public void setVitality(String vitality) {
        this.vitality = vitality;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public LeaderBean getLeader() {
        return leader;
    }

    public void setLeader(LeaderBean leader) {
        this.leader = leader;
    }

    public AnnBean getAnn() {
        return ann;
    }

    public void setAnn(AnnBean ann) {
        this.ann = ann;
    }

    public int getOp_permission() {
        return op_permission;
    }

    public void setOp_permission(int op_permission) {
        this.op_permission = op_permission;
    }

    public String getMember_count() {
        return member_count;
    }

    public void setMember_count(String member_count) {
        this.member_count = member_count;
    }

    public List<TopMemberBean> getTop_member() {
        return top_member;
    }

    public void setTop_member(List<TopMemberBean> top_member) {
        this.top_member = top_member;
    }

    public List<SportsBean> getSports() {
        return sports;
    }

    public void setSports(List<SportsBean> sports) {
        this.sports = sports;
    }

    public List<ClubActive> getActives() {
        return actives;
    }

    public void setActives(List<ClubActive> actives) {
        this.actives = actives;
    }

    public static class LeaderBean {
        /**
         * id : 10000
         * uname : RPjAvq
         * mobile : 15215146881
         * nick : 天马
         * sex : 男
         * email : null
         * idcard : null
         * area : null
         * city : 淮南 潘集
         * portrait : http://image.sportspage.cn/upload/portrait/20170219202729516.jpg
         * wx_openid : oHx7GwM4szeqnwOXSFwvgg1TnbO4
         * wxpub_openid : null
         * unionid : oVhw5vx--cuPUFMvv5n2rWLX5ldU
         * channel : 微信
         * login_time : null
         * reg_time : 2017-01-08 21:26:16
         * status : 0
         * portrait_status : 0
         * valid : 1
         * qq_openid : null
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
        private String qq_openid;

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

        public String getQq_openid() {
            return qq_openid;
        }

        public void setQq_openid(String qq_openid) {
            this.qq_openid = qq_openid;
        }
    }

    public static class AnnBean {
        /**
         * id : 5
         * club_id : 1
         * content : test
         * time : 2017-02-17 20:17:22
         */

        private String id;
        private String club_id;
        private String content;
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

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }

        public String getTime() {
            return time;
        }

        public void setTime(String time) {
            this.time = time;
        }
    }

    public static class TopMemberBean {
        /**
         * id : 10000
         * uname : RPjAvq
         * mobile : 15215146881
         * nick : 天马
         * sex : 男
         * email : null
         * idcard : null
         * area : null
         * city : 淮南 潘集
         * portrait : http://image.sportspage.cn/upload/portrait/20170219202729516.jpg
         * wx_openid : oHx7GwM4szeqnwOXSFwvgg1TnbO4
         * wxpub_openid : null
         * unionid : oVhw5vx--cuPUFMvv5n2rWLX5ldU
         * channel : 微信
         * login_time : null
         * reg_time : 2017-01-08 21:26:16
         * status : 0
         * portrait_status : 0
         * valid : 1
         * qq_openid : null
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
        private String qq_openid;

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

        public String getQq_openid() {
            return qq_openid;
        }

        public void setQq_openid(String qq_openid) {
            this.qq_openid = qq_openid;
        }
    }

    public static class SportsBean {
        /**
         * id : 10000
         * user_id : 10000
         * title : 一起挤二号线
         * portrait : http://image.sportspage.cn/upload/sport/20170109135700241.jpg
         * summary : 如果有机会
         * sport_type : 1
         * sport_item : 5
         * location :  上海市闵行区沪闵路3458弄66号颛桥地铁站附近500米
         * location_detail : null
         * place : 天空球场（闵行店）
         * latitude : 31.0678018964596
         * longitude : 121.40818072549531
         * geohash : wtw2dxwxpdhcpdf6chjn4q
         * active_times : 4
         * grade : 3
         * status : 0
         * time : 2017-01-09 13:57:00
         * deleted : 0
         * extend : null
         * valid : 0
         * last_active_time : null
         * event_id
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
        private String last_active_time;
        private String event_id;

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

        public String getLast_active_time() {
            return last_active_time;
        }

        public void setLast_active_time(String last_active_time) {
            this.last_active_time = last_active_time;
        }

        public String getEvent_id() {
            return event_id;
        }

        public void setEvent_id(String event_id) {
            this.event_id = event_id;
        }
    }
}
