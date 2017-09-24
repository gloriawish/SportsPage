package com.sportspage.fragment;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;

import com.sportspage.R;

/**
 * Created by DYJ.
 * 日期：2017/1/8.
 * 描述：
 * 备注：
 */

public class SplashItemFragment extends Fragment {

    private View contentView;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        if (contentView == null) {
            int resId = getArguments().getInt("resId", 0);
            int picId = getArguments().getInt("picId", 0);
            if (resId != 0) {
                contentView = inflater.inflate(resId, null);
                if (picId != 0) {
                    ImageView img = (ImageView) contentView.findViewById(R.id.iv_splash_item);
                    Button btn = (Button) contentView.findViewById(R.id.btn_splash_start);
                    if (btn != null&&getActivity().getIntent().getBooleanExtra("flag",false)){
                        btn.setVisibility(View.GONE);
                    }
                    img.setImageResource(picId);
                }
            }

        }
        return contentView;
    }

    public static SplashItemFragment newInstance(int resId, int picId) {
        Bundle bundle = new Bundle();
        bundle.putInt("resId", resId);
        bundle.putInt("picId", picId);
        SplashItemFragment fragment = new SplashItemFragment();
        fragment.setArguments(bundle);
        return fragment;
    }

}
