package com.sportspage.utils;

import android.app.Activity;
import android.graphics.drawable.Drawable;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.orhanobut.logger.Logger;
import com.sportspage.R;

import org.xutils.common.Callback;
import org.xutils.image.ImageOptions;
import org.xutils.x;

/**
 * Created by Tenma on 2016/12/29.
 */

public class LogicUtils {
    /**
     *  根据评分获取不同的图片ID
     *
     *  @param grade 评分
     *  @return 图片ID
     * */
    public static int getStarId(String grade){
        switch (grade){
            case "0.5":
                return R.drawable.star_0_5;
            case "1":
                return R.drawable.star_1;
            case "1.5":
                return R.drawable.star_1_5;
            case "2":
                return R.drawable.star_2;
            case "2.5":
                return R.drawable.star_2_5;
            case "3":
                return R.drawable.star_3;
            case "3.5":
                return R.drawable.star_3_5;
            case "4":
                return R.drawable.star_4;
            case "4.5":
                return R.drawable.star_4_5;
            case "5":
                return R.drawable.star_5;
        }
        return R.drawable.star_3;
    }


    /**
     *  根据不同的item值获取运动类型
     *
     *  @param sport_item item值
     *  @return 运动类型
     * */
    public static String getType(String sport_item) {
        switch (sport_item){
            case "1":
                return "羽毛球";
            case "2":
                return "足球";
            case "3":
                return "篮球";
            case "4":
                return "网球";
            case "5":
                return "跑步";
            case "6":
                return "游泳";
            case "7":
                return "壁球";
            case "8":
                return "皮划艇";
            case "9":
                return "棒球";
            case "10":
                return "乒乓";
        }
        return "羽毛球";
    }

    /**
     *  根据不同的item值获取运动类型
     *
     *  @param sport_item item值
     *  @return 运动类型
     * */
    public static int getTypeId(String sport_item) {
        switch (sport_item){
            case "1":
                return R.drawable.mine_focus_record_badminton;
            case "2":
                return R.drawable.mine_focus_record_football;
            case "3":
                return R.drawable.mine_focus_record_basketball;
            case "4":
                return R.drawable.mine_focus_record_tennis;
            case "5":
                return R.drawable.mine_focus_record_jogging;
            case "6":
                return R.drawable.mine_focus_record_swimming;
            case "7":
                return R.drawable.mine_focus_record_squash;
            case "8":
                return R.drawable.mine_focus_record_kayak;
            case "9":
                return R.drawable.mine_focus_record_baseball;
            case "10":
                return R.drawable.mine_focus_record_pingpang;
            case "20":
                return R.drawable.mine_focus_record_custom;
        }
        return R.drawable.mine_focus_record_football;
    }

    /**
     *  根据不同的status值获取运动状态
     *
     *  @param status item值
     *  @return 运动状态
     * */
    public static String getStatus(String status) {
        switch (status){
            case "1":
                return "报名中";
            case "2":
                return "已锁定";
            case "3":
                return "进行中";
            case "4":
                return "已取消";
            case "5":
                return "已结束";
        }
        return "报名中";
    }

    public static void loadImageFromUrl(final ImageView imageView, String url){
//        ImageOptions imageOptions = new ImageOptions.Builder()
//                .setImageScaleType(ImageView.ScaleType.CENTER_CROP)//缩放
//                .setLoadingDrawableId(R.mipmap.ic_launcher)//加载中默认显示图片
//                .setUseMemCache(true)//设置使用缓存
//                .setFailureDrawableId(R.mipmap.ic_launcher)//加载失败后默认显示图片
//                .build();
        Glide.with(imageView.getContext()).load(url).error(R.mipmap.ic_launcher).into(imageView);
//        x.image().loadDrawable(url, imageOptions, new Callback.CommonCallback<Drawable>() {
//            @Override
//            public void onSuccess(Drawable result) {
//                imageView.setImageDrawable(result);
//            }
//
//            @Override
//            public void onError(Throwable ex, boolean isOnCallback) {
//                Logger.d(ex.getMessage());
//            }
//
//            @Override
//            public void onCancelled(CancelledException cex) {
//                Logger.d(cex.getMessage());
//            }
//
//            @Override
//            public void onFinished() {
//
//            }
//        });
    }
}
