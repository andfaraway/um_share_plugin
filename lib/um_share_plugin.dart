import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class UMSharePlugin {
  static const MethodChannel _channel = MethodChannel('um_share_plugin');

  //初始化友盟
  static Future init(String appKey, {String? channel}) async {
    _channel.invokeMethod('init', appKey);
  }

  //初始化平台
  static Future setPlatform(
      {required int platform,
      required String appKey,
      String? appSecret,
      String? redirectURL}) async {
    Map map = {
      'platform': platform,
      'appKey': appKey,
      'appSecret': appSecret,
      'redirectURL': redirectURL
    }..removeWhere((key, value) => value == null);
    _channel.invokeMethod('setPlatform', map);
  }

  static Future<UMShareUserInfo> getUserInfoForPlatform(int platform) async {
    var jsonStr =
        await _channel.invokeMethod('getUserInfoForPlatform', platform);
    return UMShareUserInfo.format(jsonStr);
  }
}

class UMShareUserInfo {
  UMShareUserInfo(
      this.uid,
      this.openid,
      this.accessToken,
      this.refreshToken,
      this.expiration,
      this.name,
      this.iconurl,
      this.unionGender,
      this.originalResponse,
      this.error);

  static UMShareUserInfo format(String jsonStr) {
    Map map = json.decode(jsonStr);
    return UMShareUserInfo(
        map["uid"],
        map["openid"],
        map["accessToken"],
        map["refreshToken"],
        map["expiration"],
        map["name"],
        map["iconurl"],
        map["unionGender"],
        map["originalResponse"],
        map["error"]);
  }

  final String? uid;
  final String? openid;
  final String? accessToken;
  final String? refreshToken;
  final String? expiration;
  final String? name;
  final String? iconurl;
  final String? unionGender;
  final Map? originalResponse;
  final String? error;

// [mdic setValue:resp.uid forKey:@"uid"];
// [mdic setValue:resp.openid forKey:@"openid"];
// [mdic setValue:resp.accessToken forKey:@"accessToken"];
// [mdic setValue:resp.refreshToken forKey:@"refreshToken"];
// [mdic setValue:[NSString stringWithFormat:@"%@",resp.expiration] forKey:@"expiration"];
// [mdic setValue:resp.name forKey:@"name"];
// [mdic setValue:resp.iconurl forKey:@"iconurl"];
// [mdic setValue:resp.unionGender forKey:@"unionGender"];
// [mdic setValue:resp.originalResponse forKey:@"originalResponse"];
}

const UMSocialPlatformType_UnKnown = -2;
//预定义的平台
const UMSocialPlatformType_Predefine_Begin = -1;
const UMSocialPlatformType_Sina = 0; //新浪
const UMSocialPlatformType_WechatSession = 1; //微信聊天
const UMSocialPlatformType_WechatTimeLine = 2; //微信朋友圈
const UMSocialPlatformType_WechatFavorite = 3; //微信收藏
const UMSocialPlatformType_QQ = 4; //QQ聊天页面
const UMSocialPlatformType_Qzone = 5; //qq空间
const UMSocialPlatformType_TencentWb = 6; //腾讯微博
const UMSocialPlatformType_APSession = 7; //支付宝聊天页面
const UMSocialPlatformType_YixinSession = 8; //易信聊天页面
const UMSocialPlatformType_YixinTimeLine = 9; //易信朋友圈
const UMSocialPlatformType_YixinFavorite = 10; //易信收藏
const UMSocialPlatformType_LaiWangSession = 11; //点点虫（原来往）聊天页面
const UMSocialPlatformType_LaiWangTimeLine = 12; //点点虫动态
const UMSocialPlatformType_Sms = 13; //短信
const UMSocialPlatformType_Email = 14; //邮件
const UMSocialPlatformType_Renren = 15; //人人
const UMSocialPlatformType_Facebook = 16; //Facebook
const UMSocialPlatformType_Twitter = 17; //Twitter
const UMSocialPlatformType_Douban = 18; //豆瓣
const UMSocialPlatformType_KakaoTalk = 19; //KakaoTalk
const UMSocialPlatformType_Pinterest = 20; //Pinteres
const UMSocialPlatformType_Line = 21; //Line

const UMSocialPlatformType_Linkedin = 22; //领英

const UMSocialPlatformType_Flickr = 23; //Flickr

const UMSocialPlatformType_Tumblr = 24; //Tumblr
const UMSocialPlatformType_Instagram = 25; //Instagram
const UMSocialPlatformType_Whatsapp = 26; //Whatsapp
const UMSocialPlatformType_DingDing = 27; //钉钉

const UMSocialPlatformType_YouDaoNote = 28; //有道云笔记
const UMSocialPlatformType_EverNote = 29; //印象笔记
const UMSocialPlatformType_GooglePlus = 30; //Google+
const UMSocialPlatformType_Pocket = 31; //Pocket
const UMSocialPlatformType_DropBox = 32; //dropbox
const UMSocialPlatformType_VKontakte = 33; //vkontakte
const UMSocialPlatformType_FaceBookMessenger = 34; //FaceBookMessenger
const UMSocialPlatformType_Tim = 35; // Tencent TIM

const UMSocialPlatformType_WechatWork = 36; //企业微信
const UMSocialPlatformType_DouYin = 37; //抖音

const UMSocialPlatformType_Predefine_end = 999;

//用户自定义的平台
const UMSocialPlatformType_UserDefine_Begin = 1000;
const UMSocialPlatformType_UserDefine_End = 2000;
