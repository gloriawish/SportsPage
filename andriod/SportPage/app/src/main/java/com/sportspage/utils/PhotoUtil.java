package com.sportspage.utils;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.StateListDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.provider.Settings;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.FileProvider;
import android.util.Base64;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.sportspage.common.Constants;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 相机 或者相册选取类
 *
 * @author liuml
 */
public class PhotoUtil {
    // 相册，拍照，取消
    private TextView camera, photo, back;
    private AlertDialog dialog;
    private Activity context;
    // 创建一个以当前时间为名称的文件
    public static final int CAMRA_SETRESULT_CODE = 0;// 相册返回码
    public static final int PHOTO_SETRESULT_CODE = 1;// 拍照返回码
    public static final int PHOTO_CORPRESULT_CODE = 2;// 裁剪返回码

    public PhotoUtil(Activity context) {
        this.context = context;

    }

    public void showDialog() {
        if (android.os.Environment.getExternalStorageState().equals(
                android.os.Environment.MEDIA_MOUNTED)) {
            View view = initView();
            dialog = new AlertDialog.Builder(context)
                    .setView(view).create();
            dialog.show();
            addListener();

        } else {
            Toast.makeText(context, "请插入内存卡", Toast.LENGTH_SHORT).show();
        }
    }

    // 设置点击背景
    private StateListDrawable getBackGroundColor() {
        Drawable press = new ColorDrawable(0xffd7d7d7);
        Drawable normal = new ColorDrawable(0xffffffff);
        StateListDrawable drawable = new StateListDrawable();
        drawable.addState(new int[]{android.R.attr.state_pressed}, press);
        drawable.addState(new int[]{-android.R.attr.state_pressed}, normal);
        return drawable;
    }

    private void addListener() {
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });
        camera.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    PermissionUtils.requestPermission(context,
                            PermissionUtils.CODE_READ_EXTERNAL_STORAGE,mPermissionGrant);
                } else {
                    Intent intent = new Intent(Intent.ACTION_PICK,
                            MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                    ((Activity) context).startActivityForResult(intent,
                            CAMRA_SETRESULT_CODE);
                    dialog.dismiss();
                }
            }
        });
        photo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    if (ContextCompat.checkSelfPermission(context,
                            Manifest.permission.READ_EXTERNAL_STORAGE)
                            != PackageManager.PERMISSION_GRANTED) {
                        ActivityCompat.requestPermissions(context,
                                new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, Constants.PERMISSION_READ);
                    }else{
                        PermissionUtils.requestPermission(context,
                                PermissionUtils.CODE_CAMERA,mPermissionGrant);
                    }
                } else {
                    useCamera();
                }

            }
        });
    }

    private PermissionUtils.PermissionGrant mPermissionGrant = new PermissionUtils.PermissionGrant() {
        @Override
        public void onPermissionGranted(int requestCode) {
        if (requestCode == PermissionUtils.CODE_CAMERA) {
            useCamera();
        } else if(requestCode == PermissionUtils.CODE_READ_EXTERNAL_STORAGE) {
            Intent intent = new Intent(Intent.ACTION_PICK,
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
            ((Activity) context).startActivityForResult(intent,
                    CAMRA_SETRESULT_CODE);
        }
        dialog.dismiss();
        }
    };


    private void useCamera() {
        Uri imageUri = null;
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            imageUri = FileProvider.getUriForFile(context,
                    "com.sportspage.FileProvider", new File(getPhotoPath()));
        } else {
            imageUri = Uri.fromFile(new File(getPhotoPath()));
        }
        intent.putExtra(MediaStore.EXTRA_OUTPUT,imageUri);
        ((Activity) context).startActivityForResult(intent,
                PHOTO_SETRESULT_CODE);
        dialog.dismiss();
    }

    @SuppressLint("NewApi")
    private View initView() {
        LinearLayout layout = new LinearLayout(context);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT);
        layout.setLayoutParams(params);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setBackgroundColor(0xffffffff);
        camera = new TextView(context);
        LinearLayout.LayoutParams textViewParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        camera.setLayoutParams(textViewParams);
        camera.setPadding(20, 20, 0, 20);
        camera.setText("相册");
        camera.setTextColor(0xff000000);
        camera.setTextSize(20);
        camera.setBackground(getBackGroundColor());
        TextView blod1 = new TextView(context);
        LinearLayout.LayoutParams blodViewParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 1);
        blod1.setLayoutParams(blodViewParams);
        blod1.setBackgroundColor(0xffd7d7d7);
        TextView blod2 = new TextView(context);
        blod2.setLayoutParams(blodViewParams);
        blod2.setBackgroundColor(0xffd7d7d7);
        photo = new TextView(context);
        LinearLayout.LayoutParams photoParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        photo.setLayoutParams(photoParams);
        photo.setPadding(20, 20, 0, 20);
        photo.setText("拍照");
        photo.setTextColor(0xff000000);
        photo.setBackground(getBackGroundColor());
        photo.setTextSize(20);
        back = new TextView(context);
        LinearLayout.LayoutParams backParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        back.setLayoutParams(backParams);
        back.setGravity(Gravity.CENTER);
        back.setPadding(0, 25, 0, 25);
        back.setText("取消");
        back.setTextSize(14);
        back.setBackground(getBackGroundColor());
        layout.addView(camera);
        layout.addView(blod1);
        layout.addView(photo);
        layout.addView(blod2);
        layout.addView(back);
        return layout;
    }

    // 拍照使用系统当前日期加以调整作为照片的名称
    private static String getPhotoFileName() {
        Date date = new Date(System.currentTimeMillis());
        SimpleDateFormat dateFormat = new SimpleDateFormat(
                "'IMG'_yyyyMMdd_HHmmss");
        return dateFormat.format(date) + ".jpg";
    }

    // 拍照路径
    public String getPhotoPath() {
        File file = new File(Environment.getExternalStorageDirectory(), "/imgs");
        if (!file.exists()) {
            file.mkdirs();
        }
        String path = file.getPath() + "photo.jpg";
        return path;
    }


    public Uri getPhotoUri() {
        File file = new File(Environment.getExternalStorageDirectory(), "/imgs");
        if (!file.exists()) {
            file.mkdirs();
        }
        Uri uri = Uri.fromFile(new File(file.getPath()+"photo.jpg"));
        return uri;
    }

    // file转换成BitMap
    public static Bitmap readBitmapAutoSize(String filePath) {
        // outWidth和outHeight是目标图片的最大宽度和高度，用作限制
        Bitmap bm = null;
        try {

            BitmapFactory.Options opt = new BitmapFactory.Options();
            opt.inJustDecodeBounds = true;
            // 设置只是解码图片的边距，此操作目的是度量图片的实际宽度和高度
            BitmapFactory.decodeFile(filePath, opt);
            opt.inDither = false;
            opt.inPreferredConfig = Bitmap.Config.RGB_565;
            // 设置加载图片的颜色数为16bit，默认是RGB_8888，表示24bit颜色和透明通道，但一般用不上
            // opt.inSampleSize = 1;
            opt.inSampleSize = computeSampleSize(opt, -1, 900 * 900);
            opt.inJustDecodeBounds = false;
            bm = BitmapFactory.decodeFile(filePath, opt);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bm;
    }

    public static int computeSampleSize(BitmapFactory.Options options,
                                        int minSideLength, int maxNumOfPixels) {
        int initialSize = computeInitialSampleSize(options, minSideLength,
                maxNumOfPixels);
        int roundedSize;
        if (initialSize <= 8) {
            roundedSize = 1;
            while (roundedSize < initialSize) {
                roundedSize <<= 1;
            }
        } else {
            roundedSize = (initialSize + 7) / 8 * 8;
        }
        return roundedSize;
    }

    private static int computeInitialSampleSize(BitmapFactory.Options options,
                                                int minSideLength, int maxNumOfPixels) {
        double w = options.outWidth;
        double h = options.outHeight;
        int lowerBound = (maxNumOfPixels == -1) ? 1 : (int) Math.ceil(Math
                .sqrt(w * h / maxNumOfPixels));
        int upperBound = (minSideLength == -1) ? 128 : (int) Math.min(
                Math.floor(w / minSideLength), Math.floor(h / minSideLength));
        if (upperBound < lowerBound) {
            return lowerBound;
        }
        if ((maxNumOfPixels == -1) && (minSideLength == -1)) {
            return 1;
        } else if (minSideLength == -1) {
            return lowerBound;
        } else {
            return upperBound;
        }
    }

    // bitmap转换成字节流
    public static String bitmaptoString(Bitmap bitmap) {
        // 将Bitmap转换成字符串
        String result = "";
        ByteArrayOutputStream bStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, bStream);
        byte[] bytes = bStream.toByteArray();
        byte[] bb = Base64.encode(bytes, Base64.DEFAULT);
        try {
            result = new String(bb, "UTF-8").replace("+", "%2B");
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
        }
        return result;
    }

    // 得到相册路径
//    public String getCameraPath(Intent data) {
//        Uri originalUri = data.getData();
//        String[] proj = {MediaStore.Images.Media.DATA};
//
//        // 好像是android多媒体数据库的封装接口，具体的看Android文档     数据库
//        Cursor cursor = ((Activity) context).managedQuery(originalUri, proj,
//                null, null, null);
//        // 获取游标
//        int column_index = cursor
//                .getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
//        // 将光标移至开头 ，这个很重要，不小心很容易引起越界
//        cursor.moveToFirst();
//        // 最后根据索引值获取图片路径
//        String path = cursor.getString(column_index);
//        return path;
//    }

    public Uri getCameraUri(Intent data) {
        Uri originalUri = data.getData();
        return originalUri;
    }
}