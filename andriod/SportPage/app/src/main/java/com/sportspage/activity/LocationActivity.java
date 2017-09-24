package com.sportspage.activity;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.sportspage.R;
import com.sportspage.utils.Utils;

import org.xutils.view.annotation.ContentView;
import org.xutils.x;

@ContentView(R.layout.activity_location)
public class LocationActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.hideNavigationBar(this);
        x.view().inject(this);
    }
}
