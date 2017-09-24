package com.sportspage.event;

/**
 * Created by tenma on 4/8/17.
 */

public class ClubJoinWayEvent {

    private String mWay;

    public ClubJoinWayEvent(String way) {
        mWay = way;
    }

    public String getmWay() {
        return mWay;
    }
}
