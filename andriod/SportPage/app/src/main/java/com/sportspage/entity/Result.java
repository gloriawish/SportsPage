package com.sportspage.entity;

import java.util.List;

/**
 * Created by code on 9/19/16.
 */
public class Result {
    private List<City> city ;

    private String province;

    public void setCity(List<City> city){
        this.city = city;
    }
    public List<City> getCity(){
        return this.city;
    }
    public void setProvince(String province){
        this.province = province;
    }
    public String getProvince(){
        return this.province;
    }
}
