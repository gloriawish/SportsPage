package com.sportspage.wxapi;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AlertDialog;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;

import com.orhanobut.logger.Logger;
import com.sportspage.App;
import com.sportspage.R;
import com.sportspage.activity.MainActivity;
import com.sportspage.common.API;
import com.sportspage.common.Constants;
import com.sportspage.entity.UserInfoResult;
import com.sportspage.utils.Utils;
import com.sportspage.utils.Xutils;
import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;

import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.x;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import io.rong.imkit.RongIM;
import io.rong.imlib.RongIMClient;


public class WXEntryActivity extends Activity implements IWXAPIEventHandler {

    /** Log标记 */
    private final String TAG = "WXEntryActivity";
    /** 微信返回的数据 */
	private String code = "";
	private String state;
	private String country;
	private String lang;
    /** 微信登录信息 */
    private String mAccessToken;
    private String mOpenId;
    private String mUnionId;
    /** 用户信息 */
    private String mUserName;
    private String mPortrait;
    private String mPhone;
    private AlertDialog mLoadingDialog;

	Handler handler = new Handler(new Handler.Callback() {
		@Override
		public boolean handleMessage(Message message) {
			switch (message.what) {
				case 0:
					getAccess_token(code);//通过code获取token
					break;
				case 1:
                    if (Constants.WECHAT_BIND.equals(state)){
                        bindWechat();
                    } else if(Constants.WECHAT_LOGIN.equals(state)){
                        if (!mLoadingDialog.isShowing()){
                            mLoadingDialog.show();
                        }
                        checkWxRegister();
                    }
					break;
			}
			return false;
		}
	});

    @Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        mLoadingDialog = new AlertDialog.Builder(this,R.style.dialog).create();
        mLoadingDialog.setCanceledOnTouchOutside(false);
        View content = LayoutInflater.from(this).inflate(R.layout.dialog_loading, null);
        mLoadingDialog.setView(content);
        boolean b = App.api.handleIntent(this.getIntent(), this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);
		boolean b = App.api.handleIntent(intent, this);
		Log.i("onNewIntent", "onNewIntent:" + b);
	}

	// 第三方应用发送到微信的请求处理后的响应结果，会回调到该方法
	@Override
	public void onResp(BaseResp resp) {
		switch (resp.errCode) {
			case BaseResp.ErrCode.ERR_OK:
				Log.i("onResp","ERR_OK");
                if (resp.getType() == ConstantsAPI.COMMAND_SENDAUTH) {
                    code = ((SendAuth.Resp) resp).code;
                    state = ((SendAuth.Resp) resp).state;
                    country = ((SendAuth.Resp) resp).country;
                    lang = ((SendAuth.Resp) resp).lang;
                    handler.sendEmptyMessage(0);
                }else {
                    finish();
                }
				break;
			case BaseResp.ErrCode.ERR_USER_CANCEL:
				Log.i("onResp","ERR_USER_CANCEL");
                finish();
				break;
			case BaseResp.ErrCode.ERR_AUTH_DENIED:
				Log.i("onResp","ERR_AUTH_DENIED");
                finish();
				break;
			case BaseResp.ErrCode.ERR_BAN:
				Log.i("onResp","ERR_BAN");
                finish();
				break;
			case BaseResp.ErrCode.ERR_COMM:
				Log.i("onResp","一般错误");
                finish();
				break;
			case BaseResp.ErrCode.ERR_SENT_FAILED:
				Log.i("onResp","发送失败");
                finish();
				break;
			case BaseResp.ErrCode.ERR_UNSUPPORT:
				Log.i("onResp","不支持的错误");
                finish();
				break;
			default:
				break;
		}

	}

	@Override
	public void onReq(BaseReq arg0) {
        Log.i("onReq", "onReq");
	}

	/**
	 * 获取openid accessToken值用于后期操作
	 *
	 * @param code 请求码
	 */
	private void getAccess_token(final String code) {
		String path = "https://api.weixin.qq.com/sns/oauth2/access_token";
		RequestParams requestParams = new RequestParams(path);
		requestParams.addParameter("appid", Constants.APP_ID);
		requestParams.addParameter("secret", Constants.APP_SECRET);
		requestParams.addParameter("code", code);
		requestParams.addParameter("grant_type", "authorization_code");
		requestParams.setAsJsonContent(true);
		requestParams.setConnectTimeout(5000);
		Log.i("token", Constants.APP_ID+"__"+ Constants.APP_SECRET+"---"+code+"____");
		x.http().get(requestParams, new Callback.CommonCallback<String>() {
			@Override
			public void onSuccess(String result) {
				Log.i("getAccess_token", "getAccess_token:" + result);
				//解析获取token返回的结果
				parseGetToken(result);
				handler.sendEmptyMessage(1);
			}
			@Override
			public void onError(Throwable ex, boolean isOnCallback) {
				Log.i("getAccess_token-error:", ex.toString());
                Utils.showShortToast(WXEntryActivity.this, getString(R.string.network_error));
                finish();
			}
			@Override
			public void onCancelled(CancelledException cex) {
                Utils.showShortToast(WXEntryActivity.this, getString(R.string.network_error));
                finish();
			}

			@Override
			public void onFinished() {
			}
		});
	}

    /**
     * 解析access_token返回的数据
     *
     * @param result 返回的数据
     */
	private void parseGetToken(String result) {
        Map<String,String> map = Utils.parseJsonWithGson(result, HashMap.class);
        mAccessToken = map.get("access_token");
        mOpenId = map.get("openid");
        mUnionId = map.get("unionid");
	}

    private void bindWechat() {
        String userId = Utils.getValue(x.app(),"userId");
        Map<String,String> map = new HashMap<>();
        map.put("userId",userId);
        map.put("openid",mOpenId);
        map.put("unionid",mUnionId);
        Xutils.getInstance(this,false).post(API.BIND_WEIXIN,map,new Xutils.XCallBack(){
            @Override
            public void onResponse(String result) {
                Utils.showShortToast(x.app(),"绑定成功");
                Utils.putBooleanValue(x.app(),"bind",true);
            }

            @Override
            public void onFinished() {
                mLoadingDialog.dismiss();
                finish();
            }
        });
    }

    /**
     * 检测微信是否已经注册
     *
     */
    private void checkWxRegister() {
        Map<String,String> map = new HashMap<>();
        map.put("openid",mOpenId);
        RequestParams params = new RequestParams(API.CHECK_WX_REGISTER);
        try {
            params.addQueryStringParameter("sign",Utils.getSignature(map,Constants.SECRET));
            params.addQueryStringParameter("openid",mOpenId);
            x.http().get(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                   int code = Utils.getCode(result);
                    if(code == Constants.HTTP_ERROR_600){
                        getUserInfo();
                    } else if(code == Constants.HTTP_OK_200) {
                        registerByWechat();
                    } else{
                        Utils.showShortToast(WXEntryActivity.this,getString(R.string.login_failure));
                        finish();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Log.d(TAG,ex.getMessage());
                    Utils.showShortToast(WXEntryActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(WXEntryActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onFinished() {
                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 通过微信注册
     *
     */
    private void registerByWechat(){
        Map<String,String> map = new HashMap<>();
        map.put("unionid",mUnionId);
        map.put("openid",mOpenId);
        RequestParams params = new RequestParams(API.REGISTER_WITH_WX);
        try {
            params.addParameter("sign",Utils.getSignature(map,Constants.SECRET));
            params.addParameter("unionid",mUnionId);
            params.addParameter("openid",mOpenId);
            x.http().post(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Logger.json(result);
                    int code = Utils.getCode(result);
                    if(code== Constants.HTTP_OK_200 || code == Constants.HTTP_ERROR_600){
                        loginWithWechat();
                    } else {
                        Utils.showShortToast(WXEntryActivity.this,getString(R.string.login_failure));
                        finish();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Log.d(TAG,ex.getMessage());
                    Utils.showShortToast(WXEntryActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(WXEntryActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onFinished() {
                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 通过微信登录
     *
     */
    private void loginWithWechat() {
        Map<String,String> map = new HashMap<>();
        map.put("openid",mOpenId);
        RequestParams params = new RequestParams(API.LOGIN_WITH_WX);
        try {
            params.addParameter("sign",Utils.getSignature(map,Constants.SECRET));
            params.addParameter("openid",mOpenId);
            x.http().get(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Logger.json(result);
                    UserInfoResult userInfo = Utils.parseJsonWithGson(result,UserInfoResult.class);
                    if(userInfo.getCode() == Constants.HTTP_OK_200){
                        mUserName = userInfo.getResult().getId();
                        mPortrait = userInfo.getResult().getPortrait();
                        mPhone = userInfo.getResult().getMobile();
                        loginByToken(userInfo.getResult().getToken());
                    } else {
                        Utils.showShortToast(WXEntryActivity.this,getString(R.string.login_failure));
                        finish();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Log.d(TAG,ex.getMessage());
                    Utils.showShortToast(WXEntryActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(WXEntryActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onFinished() {
                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    /**
     * 通过token登录融云
     *
     * @param token token
     */
    private void loginByToken(final String token) {
        RongIM.connect(token, new RongIMClient.ConnectCallback() {
            @Override
            public void onTokenIncorrect() {
                Log.d(TAG, "--onTokenIncorrect");
                finish();
            }

            @Override
            public void onSuccess(String userId) {
                Logger.d("userId"+userId);
                Utils.putValue(WXEntryActivity.this,"token",token);
                Utils.putValue(WXEntryActivity.this,"userId",userId);
                Utils.putValue(WXEntryActivity.this,"nick",mUserName);
                Utils.putValue(WXEntryActivity.this,"portrait", mPortrait);
                Utils.putValue(WXEntryActivity.this,"mobile", mPhone);
                Utils.showShortToast(WXEntryActivity.this,getString(R.string.login_success));
                Intent intent = new Intent();
                intent.setClass(WXEntryActivity.this,MainActivity.class);
                Utils.start_Activity(WXEntryActivity.this,intent);
                mLoadingDialog.dismiss();
                finish();
            }

            @Override
            public void onError(RongIMClient.ErrorCode errorCode) {
                Log.d(TAG, "--onError" + errorCode);
                finish();
            }
        });
    }

    /**
     * 获取微信用户信息
     *
     */
    private void getUserInfo(){
        String path = "https://api.weixin.qq.com/sns/userinfo";
        RequestParams requestParams = new RequestParams(path);
        requestParams.addParameter("access_token", mAccessToken);
        requestParams.addParameter("openid", mOpenId);
        requestParams.setAsJsonContent(true);
        requestParams.setConnectTimeout(5000);
        x.http().get(requestParams, new Callback.CommonCallback<String>() {
            @Override
            public void onSuccess(String result) {
                addWxclientInfo(result);
            }
            @Override
            public void onError(Throwable ex, boolean isOnCallback) {
                Utils.showShortToast(WXEntryActivity.this, getString(R.string.network_error));
                finish();
            }
            @Override
            public void onCancelled(CancelledException cex) {
                Utils.showShortToast(WXEntryActivity.this, getString(R.string.network_error));
                finish();
            }

            @Override
            public void onFinished() {
            }
        });
    }

    /**
     * 提交授权数据
     *
     */
    private void addWxclientInfo(String result) {
        Map<String,String> map = new HashMap<>();
        map.put("openid",mOpenId);
        map.put("json",result);
        RequestParams params = new RequestParams(API.ADD_WXCLIENT);
        try {
            params.addParameter("sign",Utils.getSignature(map,Constants.SECRET));
            params.addParameter("openid",mOpenId);
            params.addParameter("json",result);
            x.http().post(params, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Log.d(TAG,"addWxclientInfo -------------->"+result);
                    int code = Utils.getCode(result);
                    if(code==Constants.HTTP_OK_200){
                        registerByWechat();
                    } else {
                        Utils.showShortToast(WXEntryActivity.this,getString(R.string.login_failure));
                        finish();
                    }
                }

                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Log.d(TAG,ex.getMessage());
                    Utils.showShortToast(WXEntryActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Utils.showShortToast(WXEntryActivity.this, getString(R.string.network_error));
                    finish();
                }

                @Override
                public void onFinished() {
                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void finish() {
        if(mLoadingDialog.isShowing()){
            mLoadingDialog.dismiss();
        }
        super.finish();
    }
}