package com.sportspage.entity;

/**
 * Created by Tenma on 2016/12/12.
 */

public class WalletResult {

    /**
     * id : 17
     * user_id : 10016
     * balance : 0.00
     * freeze : 0.00
     * score : 0
     * charge_times : 0
     */

    private String id;
    private String user_id;
    private String balance;
    private String freeze;
    private String score;
    private String charge_times;

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

    public String getBalance() {
        return balance;
    }

    public void setBalance(String balance) {
        this.balance = balance;
    }

    public String getFreeze() {
        return freeze;
    }

    public void setFreeze(String freeze) {
        this.freeze = freeze;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    public String getCharge_times() {
        return charge_times;
    }

    public void setCharge_times(String charge_times) {
        this.charge_times = charge_times;
    }
}
