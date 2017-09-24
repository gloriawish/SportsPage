package com.sportspage.utils;

import com.sportspage.entity.UserInfoResult;

import java.util.Comparator;


public class PinyinComparator implements Comparator {

	@Override
	public int compare(Object arg0, Object arg1) {
		// 按照名字排序
		UserInfoResult.ResultBean user0 = (UserInfoResult.ResultBean) arg0;
		UserInfoResult.ResultBean user1 = (UserInfoResult.ResultBean) arg1;
		String catalog0 = "";
		String catalog1 = "";

		if (user0 != null && user0.getNick() != null
				&& user0.getNick().length() > 1)
			catalog0 = PingYinUtil.converterToFirstSpell(user0.getNick())
					.substring(0, 1);

		if (user1 != null && user1.getNick() != null
				&& user1.getNick().length() > 1)
			catalog1 = PingYinUtil.converterToFirstSpell(user1.getNick())
					.substring(0, 1);
		int flag = catalog0.compareTo(catalog1);
		return flag;

	}

}
