package com.sportspage.entity;

import java.util.List;

/**
 * Created by code on 9/19/16.
 */
public class Root {
    private String msg;

    private List<Result> result ;

    private String retCode;

    public void setMsg(String msg){
        this.msg = msg;
    }
    public String getMsg(){
        return this.msg;
    }
    public void setResult(List<Result> result){
        this.result = result;
    }
    public List<Result> getResult(){
        return this.result;
    }
    public void setRetCode(String retCode){
        this.retCode = retCode;
    }
    public String getRetCode(){
        return this.retCode;
    }
}
