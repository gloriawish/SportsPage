package com.sportspage.event;

/**
 * Created by tenma on 3/23/17.
 */

public class UpdateBadgeEvent {

    private String path;

    public UpdateBadgeEvent(String path) {
        this.path = path;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }
}
