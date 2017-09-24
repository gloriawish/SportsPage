package com.sportspage.event;

/**
 * Created by tenma on 3/23/17.
 */

public class UpdateCoverEvent {

    private String path;

    public UpdateCoverEvent(String path) {
        this.path = path;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }
}
