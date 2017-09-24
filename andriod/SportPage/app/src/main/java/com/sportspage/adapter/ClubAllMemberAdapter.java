package com.sportspage.adapter;

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

import java.util.Collections;
import java.util.List;

public class ClubAllMemberAdapter extends BaseAdapter implements SectionIndexer {
	private Context mContext;
	private List<UserInfoResult.ResultBean> mAdmins;
	private List<UserInfoResult.ResultBean> mMembers;

	public ClubAllMemberAdapter(Context mContext,List<UserInfoResult.ResultBean> admins
			, List<UserInfoResult.ResultBean> members) {
		this.mContext = mContext;
		this.mAdmins = admins;
        this.mMembers = members;
		// 排序(实现了中英文混排)
		Collections.sort(mMembers, new PinyinComparator());
	}

	@Override
	public int getCount() {
		return mAdmins.size() + mMembers.size();
	}

	@Override
	public Object getItem(int position) {
        if (position >= mAdmins.size()) {
            return mMembers.get(position-mAdmins.size());
        }
		return mAdmins.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		UserInfoResult.ResultBean user;
        if (position < mAdmins.size()) {
            user = mAdmins.get(position);
        } else {
            user = mMembers.get(position - mAdmins.size());
        }
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
			tvCatalog.setText("创始人、管理员(" + mAdmins.size()+"人)");
		} else {
            if (position > mAdmins.size()) {
                position = position - mAdmins.size();
                UserInfoResult.ResultBean Nextuser = mMembers.get(position - 1);
                String lastCatalog = PingYinUtil.converterToFirstSpell(
                        Nextuser.getNick()).substring(0, 1);
                if (catalog.equals(lastCatalog)) {
                    tvCatalog.setVisibility(View.GONE);
                } else {
                    tvCatalog.setVisibility(View.VISIBLE);
                    tvCatalog.setText(catalog);
                }
            } else if(position < mAdmins.size()){
                tvCatalog.setVisibility(View.GONE);
            } else if (position == mAdmins.size()) {
                tvCatalog.setText(catalog);
            }
		}
		Glide.with(mContext).load(user.getPortrait()).into(ivAvatar);
		tvNick.setText(user.getNick());
		return convertView;
	}

	@Override
	public int getPositionForSection(int section) {
		for (int i = 0; i < mMembers.size(); i++) {
			UserInfoResult.ResultBean user = mMembers.get(i);
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
