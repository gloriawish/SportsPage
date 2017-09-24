package com.sportspage.event;

/**
 * Created by tenma on 3/29/17.
 */

public class PublishNoticeEvent {

    private String content;

    public PublishNoticeEvent(String content) {
        this.content = content;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
