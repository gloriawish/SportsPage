package com.sportspage.entity;

import java.util.List;

/**
 * Created by code on 9/19/16.
 */
public class City {
    private String city;

    private List<District> district ;

    public void setCity(String city){
        this.city = city;
    }
    public String getCity(){
        return this.city;
    }
    public void setDistrict(List<District> district){
        this.district = district;
    }
    public List<District> getDistrict(){
        return this.district;
    }
}
