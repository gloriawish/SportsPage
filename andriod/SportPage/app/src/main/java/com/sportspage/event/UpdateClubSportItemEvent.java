package com.sportspage.event;

/**
 * Created by tenma on 3/23/17.
 */

public class UpdateClubSportItemEvent {

    private String item;

    public UpdateClubSportItemEvent(String item) {
        this.item = item;
    }

    public String getItem() {
        return item;
    }

    public void setItem(String item) {
        this.item = item;
    }
}
