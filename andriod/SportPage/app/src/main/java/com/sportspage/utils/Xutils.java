package com.sportspage.utils;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.support.v7.app.AlertDialog;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;

import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.common.Constants;

import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.image.ImageOptions;
import org.xutils.x;

import java.io.File;
import java.io.IOException;
import java.util.Map;


public class Xutils {

    private volatile static Xutils instance;
    private Handler handler;
    private ImageOptions options;
    private AlertDialog mLoadingDialog;
    private boolean mIsShow = true;

    private Xutils(Context context) {
        handler = new Handler(Looper.getMainLooper());
        mLoadingDialog = new AlertDialog.Builder(context,R.style.dialog).create();
        mLoadingDialog.setCanceledOnTouchOutside(false);
        View content = LayoutInflater.from(context).inflate(R.layout.dialog_loading, null);
        mLoadingDialog.setView(content);
    }

    /**
     *
     * @param context
     * @param isShowDialog
     * @return
     */
    public static Xutils getInstance(Context context,boolean isShowDialog) {
        instance = new Xutils(context);
        instance.mIsShow = isShowDialog;
        return instance;
    }

    /**
     *
     * @param context

     * @return
     */
    public static Xutils getInstance(Context context) {
        instance = new Xutils(context);
        return instance;
    }



    /**
     * 异步get请求
     *
     * @param url
     * @param maps
     * @param callback
     */
    public void get(String url, Map<String, String> maps, final XCallBack callback) {
        if (!mLoadingDialog.isShowing() && mIsShow){
            mLoadingDialog.show();
        }
        RequestParams params = new RequestParams(url);
        try {
            params.addQueryStringParameter("sign", Utils.getSignature(maps, Constants.SECRET));
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (maps != null && !maps.isEmpty()) {
            for (Map.Entry<String, String> entry : maps.entrySet()) {
                params.addQueryStringParameter(entry.getKey(), entry.getValue());
            }
        }
        x.http().get(params, new Callback.CommonCallback<String>() {

            @Override
            public void onSuccess(String result) {
                Logger.json(result);
                try {
                    JSONObject object = new JSONObject(result);
                    if (object.getInt("code") == Constants.HTTP_OK_200) {
                        onSuccessResponse( object.getString("result"), callback);
                    }else{
                        Utils.showShortToast(x.app(), object.getString("error"));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onError(Throwable ex, boolean isOnCallback) {
                Utils.showShortToast(x.app(), x.app().getString(R.string.network_error));
                ex.printStackTrace();
            }

            @Override
            public void onCancelled(CancelledException cex) {
                Utils.showShortToast(x.app(), x.app().getString(R.string.network_error));
            }

            @Override
            public void onFinished() {
                mLoadingDialog.dismiss();
                onRequestFinished(callback);
            }
        });
    }

    /**
     * 异步post请求
     *
     * @param url
     * @param maps
     * @param callback
     */
    public void post(String url, Map<String, String> maps, final XCallBack callback) {
        if (!mLoadingDialog.isShowing() && mIsShow){
            mLoadingDialog.show();
        }
        RequestParams params = new RequestParams(url);
        try {
            params.addParameter("sign", Utils.getSignature(maps, Constants.SECRET));
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (maps != null && !maps.isEmpty()) {
            for (Map.Entry<String, String> entry : maps.entrySet()) {
                params.addBodyParameter(entry.getKey(), entry.getValue());
            }
        }

        x.http().post(params, new Callback.CommonCallback<String>() {

            @Override
            public void onSuccess(String result) {
                Logger.json(result);
                try {
                    JSONObject object = new JSONObject(result);
                    if (object.getInt("code") == Constants.HTTP_OK_200) {
                        if (object.get("result")!=null){
                            onSuccessResponse( object.getString("result"), callback);
                        } else {
                            onSuccessResponse("",callback);
                        }

                    }else{
                        Utils.showShortToast(x.app(), object.getString("error"));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onError(Throwable ex, boolean isOnCallback) {
                Utils.showShortToast(x.app(), x.app().getString(R.string.network_error));
                ex.printStackTrace();
            }

            @Override
            public void onCancelled(CancelledException cex) {
                Utils.showShortToast(x.app(), x.app().getString(R.string.network_error));
            }

            @Override
            public void onFinished() {
                mLoadingDialog.dismiss();
                onRequestFinished(callback);
            }
        });
    }


    /**
     * 带缓存数据的异步 get请求
     *
     * @param url
     * @param maps
     * @param pnewCache
     * @param callback
     */
    public void getCache(String url, Map<String, String> maps, final boolean pnewCache,
                         final XCallBack callback) {

        RequestParams params = new RequestParams(url);
        if (maps != null && !maps.isEmpty()) {
            for (Map.Entry<String, String> entry : maps.entrySet()) {
                params.addQueryStringParameter(entry.getKey(), entry.getValue());
            }
        }
        x.http().get(params, new Callback.CacheCallback<String>() {
            @Override
            public void onSuccess(String result) {
                onSuccessResponse(result, callback);
            }

            @Override
            public void onError(Throwable ex, boolean isOnCallback) {

            }

            @Override
            public void onCancelled(CancelledException cex) {

            }

            @Override
            public void onFinished() {
                onRequestFinished(callback);
            }

            @Override
            public boolean onCache(String result) {
                boolean newCache = pnewCache;
                if (newCache) {
                    newCache = !newCache;
                }
                if (!newCache) {
                    newCache = !newCache;
                    onSuccessResponse(result, callback);
                }
                return newCache;
            }
        });
    }

    /**
     * 带缓存数据的异步 post请求
     *
     * @param url
     * @param maps
     * @param pnewCache
     * @param callback
     */
    public void postCache(String url, Map<String, String> maps, final boolean pnewCache,
                          final XCallBack callback) {
        RequestParams params = new RequestParams(url);
        if (maps != null && !maps.isEmpty()) {
            for (Map.Entry<String, String> entry : maps.entrySet()) {
                params.addBodyParameter(entry.getKey(), entry.getValue());
            }
        }

        x.http().post(params, new Callback.CacheCallback<String>() {
            @Override
            public void onSuccess(String result) {
                onSuccessResponse(result, callback);
            }

            @Override
            public void onError(Throwable ex, boolean isOnCallback) {

            }

            @Override
            public void onCancelled(CancelledException cex) {

            }


            @Override
            public void onFinished() {
                onRequestFinished(callback);
            }

            @Override
            public boolean onCache(String result) {
                boolean newCache = pnewCache;
                if (newCache) {
                    newCache = !newCache;
                }
                if (!newCache) {
                    newCache = !newCache;
                    onSuccessResponse(result, callback);
                }
                return newCache;
            }
        });
    }


    /**
     * 正常图片显示
     *
     * @param iv
     * @param url
     * @param option
     */
    public void bindCommonImage(ImageView iv, String url, boolean option) {
        if (option) {
            options = new ImageOptions.Builder().setLoadingDrawableId(R.mipmap.ic_launcher)
                    .setFailureDrawableId(R.mipmap.ic_launcher).build();
            x.image().bind(iv, url, options);
        } else {
            x.image().bind(iv, url);
        }
    }

    /**
     * 圆形图片显示
     *
     * @param iv
     * @param url
     * @param option
     */
    public void bindCircularImage(ImageView iv, String url, boolean option) {
        if (option) {
            options = new ImageOptions.Builder().setLoadingDrawableId(R.mipmap.ic_launcher)
                    .setFailureDrawableId(R.mipmap.ic_launcher).setCircular(true).build();
            x.image().bind(iv, url, options);
        } else {
            x.image().bind(iv, url);
        }
    }


    /**
     * 异步post请求
     *
     * @param url 请求地址
     * @param maps 参数列表
     * @param fileParamName 文件参数名
     * @param path 文件路径
     * @param callback 回调方法
     */
    public void updateFile(String url, Map<String, String> maps,String fileParamName, String path, final XCallBack callback) {
        if (!mLoadingDialog.isShowing() && mIsShow){
            mLoadingDialog.show();
        }
        RequestParams params = new RequestParams(url);
        try {
            params.addParameter("sign", Utils.getSignature(maps, Constants.SECRET));
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (maps != null && !maps.isEmpty()) {
            for (Map.Entry<String, String> entry : maps.entrySet()) {
                params.addBodyParameter(entry.getKey(), entry.getValue());
            }
        }
        File file = new File(path);
        if (!file.exists()){
            file.mkdir();
        }
        params.addBodyParameter(fileParamName, file, "image/jpg", file.getName());
        x.http().post(params, new Callback.CommonCallback<String>() {

            @Override
            public void onSuccess(String result) {
                Logger.json(result);
                try {
                    JSONObject object = new JSONObject(result);
                    if (object.getInt("code") == Constants.HTTP_OK_200) {
                        if (object.get("result")!=null){
                            onSuccessResponse( object.getString("result"), callback);
                        } else {
                            onSuccessResponse("",callback);
                        }

                    }else{
                        Utils.showShortToast(x.app(), object.getString("error"));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onError(Throwable ex, boolean isOnCallback) {
                Utils.showShortToast(x.app(), x.app().getString(R.string.network_error));
                ex.printStackTrace();
            }

            @Override
            public void onCancelled(CancelledException cex) {
                Utils.showShortToast(x.app(), x.app().getString(R.string.network_error));
            }

            @Override
            public void onFinished() {
                mLoadingDialog.dismiss();
                onRequestFinished(callback);
            }
        });
    }


    /**
     * 异步get请求返回结果,json字符串
     *
     * @param result
     * @param callback
     */
    private void onSuccessResponse(final String result, final XCallBack callback) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                if (callback != null) {
                    callback.onResponse(result);
                }
            }
        });
    }

    private void onRequestFinished(final XCallBack callback){
        handler.post(new Runnable() {
            @Override
            public void run() {
                if (callback != null) {
                    callback.onFinished();
                }
            }
        });
    }


    public interface XCallBack {
        void onResponse(String result);

        void onFinished();
    }
}