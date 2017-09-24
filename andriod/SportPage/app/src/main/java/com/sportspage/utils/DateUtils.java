package com.sportspage.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by Tenma on 2016/12/29.
 */

public class DateUtils {

    public static String getFormatTime(String time,String format){
        if (time.isEmpty()){
            return "";
        }
        SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat dateFormat2 = new SimpleDateFormat(format) ;
        Date date = null ;
        try{
            date = dateFormat1.parse(time) ;   // 将给定的字符串中的日期提取出来
        }catch(Exception e){            // 如果提供的字符串格式有错误，则进行异常处理
            e.printStackTrace() ;       // 打印异常信息
        }
        return dateFormat2.format(date);
    }

    public static String getFormatTime(Date date) {
        if (date == null) {
            return "";
        }
        SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd");
        String dateStr = dateFormat1.format(date);
        return dateStr;
    }
}
