#import "UmSharePlugin.h"
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>

@implementation UmSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"um_share_plugin"
            binaryMessenger:[registrar messenger]];
  UmSharePlugin* instance = [[UmSharePlugin alloc] init];
  instance.channel = channel;
  [registrar addMethodCallDelegate:instance channel:channel];
  [registrar addApplicationDelegate:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

  if ([call.method isEqualToString:@"init"]) {
    //初始化友盟
    [UMConfigure initWithAppkey:call.arguments channel:nil];
      
  }else if ([call.method isEqualToString:@"setPlatform"]) {
      //初始化平台信息
      NSDictionary *dic = call.arguments;
      NSInteger platform = [[dic valueForKey:@"platform"] integerValue];
      NSString *appKey = [dic valueForKey:@"appKey"];
      NSString *appSecret = [dic valueForKey:@"appSecret"];
      NSString *redirectURL = [dic valueForKey:@"redirectURL"];
    
      UMSocialPlatformType type = platform;
      [[UMSocialManager defaultManager] setPlaform:type appKey:appKey appSecret:appSecret redirectURL:redirectURL];
      
  }else if ([call.method isEqualToString:@"getUserInfoForPlatform"]) {
      //获取回调信息
      UMSocialPlatformType type = [call.arguments intValue];
      
      FlutterResult blockResult = result;
      [[UMSocialManager defaultManager] getUserInfoWithPlatform:type currentViewController:nil completion:^(id result, NSError *error) {
          NSMutableDictionary *mdic = [NSMutableDictionary dictionary];

          if(error == nil){
              UMSocialUserInfoResponse *resp = result;
              
              [mdic setValue:resp.uid forKey:@"uid"];
              [mdic setValue:resp.openid forKey:@"openid"];
              [mdic setValue:resp.accessToken forKey:@"accessToken"];
              [mdic setValue:resp.refreshToken forKey:@"refreshToken"];
              [mdic setValue:[NSString stringWithFormat:@"%@",resp.expiration] forKey:@"expiration"];
              [mdic setValue:resp.name forKey:@"name"];
              [mdic setValue:resp.iconurl forKey:@"iconurl"];
              [mdic setValue:resp.unionGender forKey:@"unionGender"];
              [mdic setValue:resp.originalResponse forKey:@"originalResponse"];
              
          }else{
              [mdic setValue:[error.userInfo valueForKey:@"message"] forKey:@"error"];
          }
          @try {
              NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mdic options:NSJSONWritingPrettyPrinted error:nil];
              NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
              blockResult(jsonStr);
          } @catch (NSException *exception) {
              NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"error":@"failure"} options:NSJSONWritingPrettyPrinted error:nil];
              NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
              blockResult(jsonStr);
          }
      }];
  }
}



#pragma mark - AppDelegate

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
         // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler
{
    if (![[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil]) {
        // 其他SDK的回调
    }
    return YES;
}


@end
