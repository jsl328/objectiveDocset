/*!
@header 第三方网络请求-rpcRequest
@abstract 第三方网络请求 rpcRequest
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_rpcRequest.h"
#import "TMFJSBridgeInvocation+Protected.h"

#import "XMNetworking.h"
#import "NSMutableDictionary+BOBBaseNetSafeSetObject.h"
#import "NonGateWayNetWorkManager.h"
#import "BOBMessageHandle.h"
#import "SystemInfoUtil.h"
/*!
@method
@abstract 方法名：rpcRequest
@param url 请求url
@param method 请求方方式get,post
@param param 请求参数{"tranCode":"MB2408","pkgId":"123","shopId":"40136","type":"YB",}
@result 参考业务后台提供的接口文档
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData 返回业务接口数据
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
 function tmf_rpcRequest( {
    TMFJSBridge.invoke('rpcRequest',
      {"url":"https://www.baidu.com",
       "method":"post",
       "param":{"tranCode":"MB2408",
                "pkgId":"123",
                "shopId":"40136",
                "type":"YB",
         }},
        function (res) {
            alert(JSON.stringify(res))
        });x
}
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_rpcRequest
-(void)invokeWithParameters:(NSDictionary *)parameters{
    if (![SystemInfoUtil isNetwork]) {
        //无网络
        [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"8" suffix:@"000"] completed:YES];
        return;
    }
    //NSMutableDictionary *values = [NSMutableDictionary dictionary];
    NSString *strUrl = MQQStringValue(parameters[@"url"], nil);
    NSString *method =MQQStringValue(parameters[@"param"],@"POST");
    double timeout = MQQDoubleValue(parameters[@"timeout"], 120);
    //BOOL verifySSL = MQQBoolValue(parameters[@"sslVerify"],NO);
    if (!strUrl||!method||[strUrl isEqualToString:@""]||[method isEqualToString:@""]) {
        [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"8" suffix:@"006"] completed:YES];
        return;
    }
    NSDictionary *param = MQQDictionaryValue(parameters[@"param"], nil);
    if (!param) {
        [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"8" suffix:@"006"] completed:YES];
        return;
    }
    //NSDictionary *header = MQQDictionaryValue(parameters[@"header"], nil);
    //NSDictionary *query = MQQDictionaryValue(parameters[@"query"], nil);
    [[NonGateWayNetWorkManager nonGWNetWorkSharedInstance] nonGateWayNetWorkRequestURL:strUrl method:method timeOut:timeout withHeader:nil withParams:param withUseInfo:nil completed:^(XMResponse * _Nullable response, NSDictionary * _Nullable errorDict) {
        if (response) {
            id val= MQQDictionaryValue(response.responseObj, nil);
            NSLog(@"--网络请求--%@",val);
            [self finishWithValues:[BOBMessageHandle successMessageHandle:val] completed:YES];
        }else{
            //values[@"data"] = errorDict;
            [self failWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"8" suffix:@"001"] completed:YES];
        }
    }];
}
@end
