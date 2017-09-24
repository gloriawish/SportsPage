package com.sportspage.activity;

import android.os.Bundle;
import android.view.View;

import com.sportspage.R;
import com.sportspage.utils.Utils;

import org.xutils.view.annotation.Event;

import me.yokeyword.swipebackfragment.SwipeBackActivity;

/**
 * Created by Tenma on 2016/12/12.
 */

public class SubConversationListActivtiy extends SwipeBackActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        setContentView(R.layout.activity_sub_conversationlist);
    }

}
