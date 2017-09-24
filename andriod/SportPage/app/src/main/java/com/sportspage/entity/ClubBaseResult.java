package com.sportspage.entity;

/**
 * Created by tenma on 2/19/17.
 */

public class ClubBaseResult {

    /**
     * id : 1
     * name : 司徒王朗
     * user_id : 10000
     * description : null
     * capacity : 50
     * type : 1
     * extend : null
     * level : null
     * time : 2017-02-17 17:45:14
     * portrait : http://image.sportspage.cn/upload/club/20170217174514277.jpg
     * sport_item : 0
     * icon : http://image.sportspage.cn/upload/club/20170217174514180.jpg
     * ann : {"id":"5","club_id":"1","content":"test","time":"2017-02-17 20:17:22"}
     */

    private String id;
    private String name;
    private String user_id;
    private Object description;
    private String capacity;
    private String type;
    private Object extend;
    private Object level;
    private String time;
    private String portrait;
    private String sport_item;
    private String icon;
    private AnnBean ann;

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

    public Object getDescription() {
        return description;
    }

    public void setDescription(Object description) {
        this.description = description;
    }

    public String getCapacity() {
        return capacity;
    }

    public void setCapacity(String capacity) {
        this.capacity = capacity;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Object getExtend() {
        return extend;
    }

    public void setExtend(Object extend) {
        this.extend = extend;
    }

    public Object getLevel() {
        return level;
    }

    public void setLevel(Object level) {
        this.level = level;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
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

    public AnnBean getAnn() {
        return ann;
    }

    public void setAnn(AnnBean ann) {
        this.ann = ann;
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
}
