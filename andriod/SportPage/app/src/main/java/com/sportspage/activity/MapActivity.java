package com.sportspage.activity;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Point;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AlertDialog;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.MyLocationData;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.search.core.PoiInfo;
import com.baidu.mapapi.search.core.SearchResult;
import com.baidu.mapapi.search.geocode.GeoCodeOption;
import com.baidu.mapapi.search.geocode.GeoCodeResult;
import com.baidu.mapapi.search.geocode.GeoCoder;
import com.baidu.mapapi.search.geocode.OnGetGeoCoderResultListener;
import com.baidu.mapapi.search.geocode.ReverseGeoCodeOption;
import com.baidu.mapapi.search.geocode.ReverseGeoCodeResult;
import com.baidu.mapapi.search.poi.OnGetPoiSearchResultListener;
import com.baidu.mapapi.search.poi.PoiCitySearchOption;
import com.baidu.mapapi.search.poi.PoiDetailResult;
import com.baidu.mapapi.search.poi.PoiIndoorResult;
import com.baidu.mapapi.search.poi.PoiResult;
import com.baidu.mapapi.search.poi.PoiSearch;
import com.baidu.mapapi.search.sug.OnGetSuggestionResultListener;
import com.baidu.mapapi.search.sug.SuggestionResult;
import com.baidu.mapapi.search.sug.SuggestionSearch;
import com.baidu.mapapi.search.sug.SuggestionSearchOption;
import com.orhanobut.logger.Logger;
import com.sportspage.R;
import com.sportspage.adapter.PlaceListAdapter;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.utils.PermissionUtils;
import com.sportspage.utils.Utils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ContentView;
import org.xutils.view.annotation.Event;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

/**
 * Created by Tenma on 2016/11/27.
 */


@ContentView(R.layout.activity_map)
public class MapActivity extends SwipeBackActivity implements OnGetGeoCoderResultListener {

    @ViewInject(R.id.txt_title)
    private TextView mTitle;
    @ViewInject(R.id.iv_back)
    private ImageView mBackView;
    /**
     * 地址列表视图
     */
    private ListView mAddressList;
    /**
     * 地图视图
     */
    private MapView mMapView;
    /**
     * 列表adapter
     */
    private PlaceListAdapter mListAdpter;
    /**  */
    private BaiduMap mBaiduMap;
    /**
     * 地址列表数据
     */
    private List<PoiInfo> mInfoList;
    /**
     * 地图中心点
     */
    private Point mCenterPoint;
    /**
     * 地理坐标点
     */
    private LatLng mLoactionLatLng;
    /**
     * 地理编码
     */
    private GeoCoder mGeoCoder;
    /**
     * 经度
     */
    private double mLongitude;
    /**
     * 纬度
     */
    private double mLatitude;
    /**
     * 地址
     */
    private String mAddress;

    private EditText mETName;

    private AlertDialog mEditDialog;

    private AlertDialog mTextDialog;

    private Bundle mBundle;

    @ViewInject(R.id.et_map_search)
    private EditText mKeyWord;

    private PoiSearch mPoiSearch;

    private SuggestionSearch mSuggestionSearch;

    OnGetPoiSearchResultListener poiListener = new OnGetPoiSearchResultListener() {

        public void onGetPoiResult(PoiResult result) {
            //获取POI检索结果
            if (result == null
                    || result.error == SearchResult.ERRORNO.RESULT_NOT_FOUND) {// 没有找到检索结果
                Utils.showShortToast(MapActivity.this, "未找到结果");
                return;
            }
            List<PoiInfo> addList = result.getAllPoi();
            for (int i = 0; i < addList.size(); i++) {
                PoiInfo poiInfo = new PoiInfo();
                poiInfo.address = addList.get(i).name;
                poiInfo.location = addList.get(i).location;
                mInfoList.add(poiInfo);
            }
            mListAdpter.notifyDataSetChanged();
        }

        public void onGetPoiDetailResult(PoiDetailResult result) {
            //获取Place详情页检索结果--
        }

        @Override
        public void onGetPoiIndoorResult(PoiIndoorResult poiIndoorResult) {

        }

    };

    private OnGetSuggestionResultListener suggestionListener = new OnGetSuggestionResultListener() {
        @Override
        public void onGetSuggestionResult(SuggestionResult result) {
            if (result == null || result.getAllSuggestions() == null) {
                Utils.showShortToast(MapActivity.this, "未找到结果");
                return;
                //未找到相关结果
            }
            //获取在线建议检索结果
            List<SuggestionResult.SuggestionInfo> suggestions = result.getAllSuggestions();
            List<PoiInfo> addList = new ArrayList<>();
            for (int i = 0; i < suggestions.size(); i++) {
                PoiInfo poiInfo = new PoiInfo();
                poiInfo.address = suggestions.get(i).key;
                poiInfo.location = suggestions.get(i).pt;
                mInfoList.add(poiInfo);
            }
            mListAdpter.notifyDataSetChanged();
        }
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
        initView();
        initMap();
        getimgxy();
    }

    /**
     * 初始化地图
     */
    private void initMap() {
        mMapView.showZoomControls(true);
        mBaiduMap = mMapView.getMap();
        Double latitude = Double.parseDouble(Utils.getValue(this, "latitude", "999"));
        Double lontitude = Double.parseDouble(Utils.getValue(this, "lontitude", "999"));
        MapStatusUpdate u = MapStatusUpdateFactory.newLatLngZoom(new LatLng(latitude, lontitude), 17f);
        mBaiduMap.setMapStatus(u);
        //开启定位图层
        mBaiduMap.setMyLocationEnabled(true);
        mSuggestionSearch = SuggestionSearch.newInstance();
        mSuggestionSearch.setOnGetSuggestionResultListener(suggestionListener);
        mPoiSearch = PoiSearch.newInstance();
        mPoiSearch.setOnGetPoiSearchResultListener(poiListener);
        mGeoCoder = GeoCoder.newInstance();
        mGeoCoder.setOnGetGeoCodeResultListener(this);
    }

    @Event(R.id.btn_map_search)
    private void search(View v) {
        PermissionUtils.requestPermission(this, PermissionUtils.CODE_WRITE_EXTERNAL_STORAGE, mPermissionGrant);
        mInfoList.clear();
        mPoiSearch.searchInCity((new PoiCitySearchOption())
                .city(Constants.KEY_CITY)
                .keyword(mKeyWord.getText().toString())
                .pageNum(10));
        mSuggestionSearch.requestSuggestion(new SuggestionSearchOption()
                .keyword(mKeyWord.getText().toString()).city(Constants.KEY_CITY));
        searchFromServer();
        Utils.hideKeyBoard();
    }

    private PermissionUtils.PermissionGrant mPermissionGrant = new PermissionUtils.PermissionGrant() {
        @Override
        public void onPermissionGranted(int requestCode) {
        }
    };

    private void searchFromServer() {
        String userId = Utils.getValue(this, "userId");
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("search", mKeyWord.getText().toString());
        map.put("city", Constants.KEY_CITY);
        RequestParams params = new RequestParams(API.SEARCH_PLACE);
        try {
            params.addQueryStringParameter("sign", Utils.getSignature(map, Constants.SECRET));
            params.addQueryStringParameter("userId", userId);
            params.addQueryStringParameter("search", mKeyWord.getText().toString());
            params.addQueryStringParameter("city", Constants.KEY_CITY);
            x.http().get(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Logger.json(result);
                    try {
                        JSONObject jsonObject = new JSONObject(result);
                        if (jsonObject.getInt("code") == Constants.HTTP_OK_200) {
                            JSONObject resultObject = jsonObject.getJSONObject("result");
                            JSONArray data = resultObject.getJSONArray("data");
                            for (int i = 0; i < data.length(); i++) {
                                PoiInfo info = new PoiInfo();
                                info.name = data.getJSONObject(i).getString("name");
                                info.address = data.getJSONObject(i).getString("address");
                                info.location = new LatLng(data.getJSONObject(i).getDouble("latitude")
                                        , data.getJSONObject(i).getDouble("longitude"));
                                mInfoList.add(i, info);
                            }
                            mListAdpter.notifyDataSetChanged();
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {

                }

                @Override
                public void onCancelled(CancelledException cex) {

                }

                @Override
                public void onFinished() {

                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }


    }

    /**
     * 初始化视图
     */
    private void initView() {
        mTitle.setText("运动地址");
        mBackView.setVisibility(View.VISIBLE);
        mBundle = new Bundle();
        mMapView = (MapView) findViewById(R.id.bmapView);
        mAddressList = (ListView) findViewById(R.id.lv_map);
        // 初始化POI信息列表
        mInfoList = new ArrayList<>();
        mListAdpter = new PlaceListAdapter(getLayoutInflater(), mInfoList);
        mEditDialog = new AlertDialog.Builder(MapActivity.this)
                .setPositiveButton("是", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        mBundle.putString("name", mETName.getText().toString());
                        setResult(RESULT_OK, new Intent().putExtra("info", mBundle));
                        finish();
                    }
                }).setNegativeButton("否", null).create();
        mETName = new EditText(this);
        mETName.setHint("请输入地点名称");
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.setMargins(50, 0, 0, 50);
        mETName.setLayoutParams(lp);
        mEditDialog.setView(mETName);
        mTextDialog = new AlertDialog.Builder(MapActivity.this)
                .setPositiveButton("是", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        setResult(RESULT_OK, new Intent().putExtra("info", mBundle));
                        finish();
                    }
                }).setNegativeButton("否", null).create();
    }

    /**
     * 初始化地图物理坐标
     */
    private void getimgxy() {
        mCenterPoint = mBaiduMap.getMapStatus().targetScreen;
        mLoactionLatLng = mBaiduMap.getMapStatus().target;
        // 地理编码
        mAddressList.setAdapter(mListAdpter);
        mAddressList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

                PoiInfo info = mInfoList.get(i);
                String name = info.name;
                if (name == null || name.isEmpty()) {
                    mGeoCoder.reverseGeoCode(new ReverseGeoCodeOption().location(info.location));
                } else {
                    mBundle.putString("name", name);
                    mTextDialog.setTitle(info.address);
                    mTextDialog.setMessage(info.name);
                    mTextDialog.show();
                }
                mListAdpter.setSelection(i);
                mListAdpter.notifyDataSetChanged();
                mBaiduMap.clear();
                LatLng la = info.location;
                mLatitude = la.latitude;
                mLongitude = la.longitude;
                mAddress = info.address;
                mBundle.putString("address", mAddress);
                mBundle.putDouble("latitude", mLatitude);
                mBundle.putDouble("longitude", mLongitude);
                MyLocationData locData = new MyLocationData.Builder()
                        // 此处设置开发者获取到的方向信息，顺时针0-360
                        .direction(100).latitude(mLatitude)
                        .longitude(mLongitude).build();
                mBaiduMap.setMyLocationData(locData);
                //设置定位数据
                mLoactionLatLng = new LatLng(mLatitude,
                        mLongitude);
                MapStatusUpdate u = MapStatusUpdateFactory.newLatLngZoom(mLoactionLatLng, 15);    //设置地图中心点以及缩放级别
                mBaiduMap.animateMapStatus(u);
            }
        });

    }

    @Override
    public void onGetGeoCodeResult(GeoCodeResult geoCodeResult) {
    }

    @Override
    public void onGetReverseGeoCodeResult(ReverseGeoCodeResult reverseGeoCodeResult) {

        if (reverseGeoCodeResult == null
                || reverseGeoCodeResult.error != SearchResult.ERRORNO.NO_ERROR) {
            // 没有找到检索结果
            Logger.d("没有找到检索结果");
        } else {
            // 当前位置信息
            if (reverseGeoCodeResult.getAddress() != null
                    || !reverseGeoCodeResult.getAddress().isEmpty()) {
                mEditDialog.setTitle(reverseGeoCodeResult.getAddress());
                mEditDialog.show();
            }
        }
    }

    @Override
    protected void onPause() {
        mMapView.onPause();
        super.onPause();
    }

    @Override
    protected void onResume() {
        mMapView.onResume();
        super.onResume();
    }

    @Override
    protected void onDestroy() {
        // 关闭定位图层
        mBaiduMap.setMyLocationEnabled(false);
        mMapView.onDestroy();
        mPoiSearch.destroy();
        mSuggestionSearch.destroy();
        mMapView = null;
        super.onDestroy();
    }

    @Event(R.id.iv_back)
    private void goBack(View v){
        finish();
        overridePendingTransition(R.anim.push_right_in,
                R.anim.push_right_out);
    }

}
