package com.sportspage.adapter;

import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.baidu.mapapi.search.core.PoiInfo;
import com.sportspage.R;

import java.util.List;

/**
 * Created by Tenma on 2016/11/26.
 */

public class PlaceListAdapter extends BaseAdapter {
    /** 存放位置信息 */
    List<PoiInfo> mList;
    /** 加载布局 */
    LayoutInflater mInflater;
    /** 被选中的item的index */
    private int selectedPosition=-1;

    /**
     *  ViewHolder
     */
    private class MyViewHolder {
        TextView placeName;
        TextView placeAddress;
    }

    public PlaceListAdapter(LayoutInflater mInflater , List<PoiInfo> mList) {
        super();
        this.mList = mList;
        this.mInflater = mInflater;
    }

    @Override
    public int getCount() {
        // TODO Auto-generated method stub
        return mList.size();
    }

    @Override
    public Object getItem(int position) {
        // TODO Auto-generated method stub

        return mList.get(position);
    }

    @Override
    public long getItemId(int position) {
        // TODO Auto-generated method stub
        return position;
    }

    /**
     *  设置被选中item的index
     */
    public void setSelection(int p) {
        selectedPosition = p;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub
        MyViewHolder holder;
        if (convertView == null) {
            convertView = mInflater.inflate(R.layout.item_maplist, parent, false);
            holder = new MyViewHolder();
            holder.placeName = (TextView) convertView
                    .findViewById(R.id.mapname);
            holder.placeAddress = (TextView) convertView
                    .findViewById(R.id.mapaddress);

            holder.placeName.setText(mList.get(position).name);
            holder.placeAddress.setText(mList.get(position).address);
            convertView.setTag(holder);
        } else {
            holder = (MyViewHolder) convertView.getTag();
        }
        holder.placeName.setText(mList.get(position).name);
        holder.placeAddress.setText(mList.get(position).address);
        //根据重新加载的时候第position条item是否是当前所选择的，选择加载不同的图片
        if(selectedPosition == position ){
            holder.placeName.setTextColor(Color.parseColor("#ff6501"));
            holder.placeAddress.setTextColor(Color.parseColor("#ff6501"));
        }
        else {
            holder.placeName.setTextColor(Color.parseColor("#000000"));
            holder.placeAddress.setTextColor(Color.parseColor("#8f605f5f"));
        }

        return convertView;
    }
}
