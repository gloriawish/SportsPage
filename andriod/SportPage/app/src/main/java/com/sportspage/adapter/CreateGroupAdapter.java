package com.sportspage.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.SectionIndexer;
import android.widget.TextView;

import com.sportspage.R;
import com.sportspage.common.ViewHolder;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.utils.PingYinUtil;
import com.sportspage.utils.PinyinComparator;
import com.sportspage.utils.Utils;

import org.xutils.x;

import java.util.Collections;
import java.util.List;

public class CreateGroupAdapter extends BaseAdapter implements SectionIndexer {
	private Context mContext;
	private List<UserInfoResult.ResultBean> mDatas;// 好友信息

	public CreateGroupAdapter(Context mContext, List<UserInfoResult.ResultBean> datas) {
		this.mContext = mContext;
		this.mDatas = datas;
		// 排序(实现了中英文混排)
		Collections.sort(mDatas, new PinyinComparator());
	}

	@Override
	public int getCount() {
		return mDatas.size();
	}

	@Override
	public Object getItem(int position) {
		return mDatas.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		UserInfoResult.ResultBean user = mDatas.get(position);
		if (convertView == null) {
			convertView = LayoutInflater.from(mContext).inflate(
					R.layout.item_create_group, null);
			convertView.setBackgroundColor(mContext.getResources().getColor(R.color.white));
		}
		ImageView ivAvatar = ViewHolder.get(convertView,
				R.id.contactitem_avatar_iv);
		TextView tvCatalog = ViewHolder.get(convertView,
				R.id.contactitem_catalog);
		TextView tvNick = ViewHolder.get(convertView, R.id.contactitem_nick);
		final CheckBox checkBox = ViewHolder.get(convertView,R.id.checkbox);
		convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (checkBox.isChecked()) {
                    checkBox.setChecked(false);
                    mDatas.get(position).setChecked(false);
                } else {
                    checkBox.setChecked(true);
                    mDatas.get(position).setChecked(true);
                }
            }
        });
        checkBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                mDatas.get(position).setChecked(isChecked);
            }
        });
		String catalog = PingYinUtil.converterToFirstSpell(user.getNick())
				.substring(0, 1);
		if (position == 0) {
			tvCatalog.setVisibility(View.VISIBLE);
			tvCatalog.setText(catalog);
		} else {
			UserInfoResult.ResultBean Nextuser = mDatas.get(position - 1);
			String lastCatalog = PingYinUtil.converterToFirstSpell(
					Nextuser.getNick()).substring(0, 1);
			if (catalog.equals(lastCatalog)) {
				tvCatalog.setVisibility(View.GONE);
			} else {
				tvCatalog.setVisibility(View.VISIBLE);
				tvCatalog.setText(catalog);
			}
		}
        x.image().bind(ivAvatar,user.getPortrait());
		tvNick.setText(user.getNick());
		return convertView;
	}

	@Override
	public int getPositionForSection(int section) {
		for (int i = 0; i < mDatas.size(); i++) {
			UserInfoResult.ResultBean user = mDatas.get(i);
			String l = PingYinUtil.converterToFirstSpell(user.getNick())
					.substring(0, 1);
			char firstChar = l.toUpperCase().charAt(0);
			if (firstChar == section) {
				return i;
			}
		}
		return 0;
	}

    public String getCheckUserIds(){
        StringBuilder builder = new StringBuilder();

        for (int i=0;i<mDatas.size();i++){
            if (mDatas.get(i).isChecked()){
                builder.append(mDatas.get(i).getId()+",");
            }
        }
        String str = builder.toString();
		if (str.equals("")) {
			return "";
		}
        String ids = str.substring(0,str.length()-1);
        return ids;
    }

	@Override
	public int getSectionForPosition(int position) {
		return 0;
	}

	@Override
	public Object[] getSections() {
		return null;
	}

    @Override
    public boolean areAllItemsEnabled() {
        return false;
    }

    @Override
    public boolean isEnabled(int position) {
        return false;
    }
}
