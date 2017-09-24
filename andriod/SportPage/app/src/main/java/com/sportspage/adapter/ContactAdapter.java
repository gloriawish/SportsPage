package com.sportspage.adapter;

import java.util.Collections;
import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.SectionIndexer;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.sportspage.R;
import com.sportspage.common.ViewHolder;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.utils.PingYinUtil;
import com.sportspage.utils.PinyinComparator;

import org.xutils.x;

public class ContactAdapter extends BaseAdapter implements SectionIndexer {
	private Context mContext;
	private List<UserInfoResult.ResultBean> UserInfos;// 好友信息

	public ContactAdapter(Context mContext, List<UserInfoResult.ResultBean> UserInfos) {
		this.mContext = mContext;
		this.UserInfos = UserInfos;
		// 排序(实现了中英文混排)
		Collections.sort(UserInfos, new PinyinComparator());
	}

	@Override
	public int getCount() {
		return UserInfos.size();
	}

	@Override
	public Object getItem(int position) {
		return UserInfos.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		UserInfoResult.ResultBean user = UserInfos.get(position);
		if (convertView == null) {
			convertView = LayoutInflater.from(mContext).inflate(
					R.layout.item_contact, null);

		}
		ImageView ivAvatar = ViewHolder.get(convertView,
				R.id.contactitem_avatar_iv);
		TextView tvCatalog = ViewHolder.get(convertView,
				R.id.contactitem_catalog);
		TextView tvNick = ViewHolder.get(convertView, R.id.contactitem_nick);
		String catalog = PingYinUtil.converterToFirstSpell(user.getNick())
				.substring(0, 1);
		if (position == 0) {
			tvCatalog.setVisibility(View.VISIBLE);
			tvCatalog.setText(catalog);
		} else {
			UserInfoResult.ResultBean Nextuser = UserInfos.get(position - 1);
			String lastCatalog = PingYinUtil.converterToFirstSpell(
					Nextuser.getNick()).substring(0, 1);
			if (catalog.equals(lastCatalog)) {
				tvCatalog.setVisibility(View.GONE);
			} else {
				tvCatalog.setVisibility(View.VISIBLE);
				tvCatalog.setText(catalog);
			}
		}
		Glide.with(mContext).load(user.getPortrait()).into(ivAvatar);
		tvNick.setText(user.getNick());
		return convertView;
	}

	@Override
	public int getPositionForSection(int section) {
		for (int i = 0; i < UserInfos.size(); i++) {
			UserInfoResult.ResultBean user = UserInfos.get(i);
			String l = PingYinUtil.converterToFirstSpell(user.getNick())
					.substring(0, 1);
			char firstChar = l.toUpperCase().charAt(0);
			if (firstChar == section) {
				return i;
			}
		}
		return 0;
	}

	@Override
	public int getSectionForPosition(int position) {
		return 0;
	}

	@Override
	public Object[] getSections() {
		return null;
	}
}
