package com.sportspage.entity;

import java.util.List;

/**
 * Created by sportspage on 2017/1/9.
 */

public class MainNoticeResult {

    /**
     * size : 4
     * data : [{"id":"124","cate":null,"type":"1002","target_id":"10016","content":"尊敬的用户您好，你通过微信充值的0.01元已经到账。","extend":"","time":"2017-01-06 12:20:16","is_read":"0"},{"id":"123","cate":null,"type":"1002","target_id":"10016","content":"尊敬的用户您好，你通过微信充值的0.01元已经到账。","extend":"","time":"2017-01-06 12:06:57","is_read":"0"},{"id":"122","cate":null,"type":"1002","target_id":"10016","content":"尊敬的用户您好，你通过微信充值的1元已经到账。","extend":"","time":"2017-01-06 11:50:34","is_read":"0"},{"id":"121","cate":null,"type":"1002","target_id":"10016","content":"尊敬的用户您好，你通过微信充值的0.1元已经到账。","extend":"","time":"2017-01-06 11:45:06","is_read":"0"}]
     */

    private int size;
    private List<DataBean> data;

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public List<DataBean> getData() {
        return data;
    }

    public void setData(List<DataBean> data) {
        this.data = data;
    }

    public static class DataBean {
        /**
         * id : 124
         * cate : null
         * type : 1002
         * target_id : 10016
         * content : 尊敬的用户您好，你通过微信充值的0.01元已经到账。
         * extend :
         * time : 2017-01-06 12:20:16
         * is_read : 0
         */

        private String id;
        private Object cate;
        private String type;
        private String target_id;
        private String content;
        private String extend;
        private String time;
        private String is_read;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public Object getCate() {
            return cate;
        }

        public void setCate(Object cate) {
            this.cate = cate;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getTarget_id() {
            return target_id;
        }

        public void setTarget_id(String target_id) {
            this.target_id = target_id;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
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

        public String getIs_read() {
            return is_read;
        }

        public void setIs_read(String is_read) {
            this.is_read = is_read;
        }
    }
}
