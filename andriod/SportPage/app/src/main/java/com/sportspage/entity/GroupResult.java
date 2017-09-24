package com.sportspage.entity;

import java.util.List;

/**
 * Created by Tenma on 2017/1/6.
 */

public class GroupResult {

    /**
     * size : 2
     * data : [{"id":"9","name":"囚徒健身","portrait":"http://image.sportspage.cn/upload/group/group_9_20161220174828680.jpg","introduce":"囚徒健身专用群","size":"32","extend":null,"owner":"10011","create_time":"2016-12-20 17:48:27"},{"id":"54","name":"233交流群","portrait":"http://image.sportspage.cn/upload/group/group_54_20161229222534320.jpg","introduce":"无","size":"32","extend":"51","owner":"10016","create_time":"2016-12-29 22:25:33"}]
     */

    private int size;
    private List<Group> data;

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public List<Group> getData() {
        return data;
    }

    public void setData(List<Group> data) {
        this.data = data;
    }

    public static class Group {
        /**
         * id : 9
         * name : 囚徒健身
         * portrait : http://image.sportspage.cn/upload/group/group_9_20161220174828680.jpg
         * introduce : 囚徒健身专用群
         * size : 32
         * extend : null
         * owner : 10011
         * create_time : 2016-12-20 17:48:27
         */

        private String id;
        private String name;
        private String portrait;
        private String introduce;
        private String size;
        private Object extend;
        private String owner;
        private String create_time;

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

        public String getPortrait() {
            return portrait;
        }

        public void setPortrait(String portrait) {
            this.portrait = portrait;
        }

        public String getIntroduce() {
            return introduce;
        }

        public void setIntroduce(String introduce) {
            this.introduce = introduce;
        }

        public String getSize() {
            return size;
        }

        public void setSize(String size) {
            this.size = size;
        }

        public Object getExtend() {
            return extend;
        }

        public void setExtend(Object extend) {
            this.extend = extend;
        }

        public String getOwner() {
            return owner;
        }

        public void setOwner(String owner) {
            this.owner = owner;
        }

        public String getCreate_time() {
            return create_time;
        }

        public void setCreate_time(String create_time) {
            this.create_time = create_time;
        }
    }
}
