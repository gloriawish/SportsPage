package com.sportspage.event;

/**
 * Created by tenma on 3/23/17.
 */

public class UpdateClubNameEvent {

    private String name;

    public UpdateClubNameEvent(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
