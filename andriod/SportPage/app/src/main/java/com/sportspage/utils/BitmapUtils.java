package com.sportspage.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.os.Environment;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * 图片选择类
 * Created by lml on 2015/7/1.
 */
public class BitmapUtils {

    private Context context;
    private File mOutputFile;

    public BitmapUtils(Context context) {
        this.context = context;
    }

    //获取压缩旋转后的图片路径
    public String getPath(String path, String newPath) {
        mOutputFile = new File(newPath);
        Bitmap bitmap = decodeFile(path);
        if (bitmap != null) {
            compressImage(bitmap);
        }
        return newPath;
    }

    //获取压缩旋转后的图片路径
    public String getPath(Bitmap bitmap, String newPath) {
        mOutputFile = new File(newPath);
//        Bitmap bitmap = decodeFile(path);
        if (bitmap != null) {
            compressImage(bitmap);
        }
        return newPath;
    }


    /*
   * 图片并且按比例缩放以减少内存消耗，虚拟机对每张图片的缓存大小也是有限制的
   * @param path 图片路径
   */
    public Bitmap decodeFile(String path) {
        // decode image size
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        Bitmap bitmap = BitmapFactory.decodeFile(path, options);
        // Find the correct scale value. It should be the power of 2.
        final int REQUIRED_SIZE = 480;//2700
        int width_tmp = options.outWidth, height_tmp = options.outHeight;
        int scale = 1;

        int scaleWidth = width_tmp / REQUIRED_SIZE;
        int scaleHeight = height_tmp / REQUIRED_SIZE;
        scale = scaleHeight > scaleWidth ? scaleWidth : scaleHeight;
//        if (scale <= 1) {
//            return null;
//        }
        // decode with inSampleSize
        options.inSampleSize = scale;
        options.inPreferredConfig = Bitmap.Config.RGB_565;
        options.inPurgeable = true;
        options.inInputShareable = true;
        options.inJustDecodeBounds = false;
        try {
            bitmap = BitmapFactory.decodeFile(path, options);
        } catch (OutOfMemoryError err) {
            err.printStackTrace();
            return null;
        }

        try {
            int degree = readPictureDegree(path);
            if (degree != 0) {
                bitmap = rotaingImageView(degree, bitmap);
            }
        } catch (OutOfMemoryError err) {
            err.printStackTrace();
        }

        return bitmap;
    }

    /*
     * 保存Bitmap
     * @param filename 保存的文件路径
     * @param bitmap 原始图片
     */
    public ByteArrayInputStream compressImage(Bitmap image) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        int options = 100;
        image.compress(Bitmap.CompressFormat.JPEG, options, baos);//质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        while (baos.toByteArray().length / 1024 > 2000) {    //判断如果图片大于200K,进行压缩避免在生成图,大于继续压缩
            baos.reset();//重置baos即清空baos
            image.compress(Bitmap.CompressFormat.JPEG, options, baos);//这里压缩options%，把压缩后的数据存放到baos中
            options -= 10;//每次都减少10
        }
        writeImageToDisk(baos.toByteArray());
        //把压缩后的数据baos存放到ByteArrayInputStream中
//        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());
//        if (image != null && !image.isRecycled()) {
//            image.recycle();
//        }
        try {
            baos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    public byte[] compressImageClassPhoto(Bitmap image) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        int options = 100;
        image.compress(Bitmap.CompressFormat.JPEG, options, baos);//质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        while (baos.toByteArray().length / 1024 > 2000) {    //循环判断如果压缩后图片是否大于100kb,大于继续压缩
            baos.reset();//重置baos即清空baos
            image.compress(Bitmap.CompressFormat.JPEG, options, baos);//这里压缩options%，把压缩后的数据存放到baos中
            options -= 10;//每次都减少10
        }
        byte[] bytes = baos.toByteArray();
        return bytes;
    }

    /**
     * 将图片写入到磁盘
     *
     * @param img 图片数据流
     */
    public void writeImageToDisk(byte[] img) {
        try {
            FileOutputStream fops = new FileOutputStream(mOutputFile);
            fops.write(img);
            fops.flush();
            fops.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 将图片写入到磁盘
     *
     * @param img 图片数据流
     */
    public void writeImageToDisk(String filepath, byte[] img) {
        try {
            FileOutputStream fops = new FileOutputStream(filepath);
            fops.write(img);
            fops.flush();
            fops.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /*
   * 保存Bitmap
   * @param filename 保存的文件路径
   * @param bitmap 原始图片
   */
    public void saveBitmapInSD(String filename, Bitmap bitmap) {
        if (!Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())) {
            return;
        }
        byte[] bytes = compressImageClassPhoto(bitmap);
        writeImageToDisk(filename, bytes);
    }

    /**
     * 读取图片属性：旋转的角度
     *
     * @param path 图片绝对路径
     * @return degree旋转的角度
     */
    public static int readPictureDegree(String path) {
        int degree = 0;
        try {
            ExifInterface exifInterface = new ExifInterface(path);
            int orientation = exifInterface.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);
            switch (orientation) {
                case ExifInterface.ORIENTATION_ROTATE_90:
                    degree = 90;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_180:
                    degree = 180;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_270:
                    degree = 270;
                    break;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return degree;
    }

    /*
     * 旋转图片
     * @param angle 图片旋转角度
     * @param bitmap 原始图片
     * @return Bitmap 返回旋转后图片
     */
    public static Bitmap rotaingImageView(int angle, Bitmap bitmap) {
        //旋转图片 动作
        Matrix matrix = new Matrix();
        matrix.postRotate(angle);
        // 创建新的图片
        Bitmap resizedBitmap = Bitmap.createBitmap(bitmap, 0, 0,
                bitmap.getWidth(), bitmap.getHeight(), matrix, true);
        return resizedBitmap;
    }


}
