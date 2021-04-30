
/*!
@header rpc网关请求-rpcSharkPost
@abstract rpc网关请求，通过TMF的网关请求
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_rpcSharkPost.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "TMFSharkCheckManager.h"
#import "NSObject+ToDictionary.h"
#import "BOBMessageHandle.h"
#import "SystemInfoUtil.h"

/*!
@method
@abstract 方法名：rpcSharkPost
@param url 请求url，例如MB9999
@param param 请求参数
@result 输出参数
 @textblock
 <apiXmpBegin>
 status 回调状态
 message 回调信息
 callbackData 返回请求数据
 <apiXmpEnd>
 @/textblock
<apiXmpBegin>
 //RPC通讯请求
 function rpc(){
      TMFJSBridge.invoke('rpcSharkPost', {"url":"MB2408","param":{"tranCode":"MB2408","pkgId":"123"}},
           function (res) {
               alert(JSON.stringify(res))
           });
 }
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_rpcSharkPost
- (void)invokeWithParameters:(NSDictionary *)parameters
{
    if (![SystemInfoUtil isNetwork]) {
        //没有网络的情况
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"7" suffix:@"000"] completed:YES];
        return;
    }
    //初始化移动网关
    [[TMFSharkCheckManager sharkShared]initSharkSDK];
    //网关接口名称
    NSString *cmd = MQQStringValue(parameters[@"url"], nil);
    if (!cmd) {
        [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"7" suffix:@"006"] completed:YES];
        return;
    }
    NSDictionary *objDict = MQQDictionaryValue(parameters[@"param"], nil);
    //NSData *objData = MQQDataValue(parameters[@"data"], nil);
    //在子线程延迟执行,并且延迟1秒执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[TMFSharkCheckManager sharkShared]fetchSharkRequestWithcmd:cmd reqHeader:nil reqData:objDict completed:^(TMFSharkResponseHeaders * _Nullable headers, NSData * _Nullable responseData, NSError * _Nullable error) {
            // 业务解析数据
            NSString *responseString = nil;
            if (error.code==0) {
                id val= [responseData JSONValue];
                NSLog(@"网关检查%@",val);
                [self finishWithValues:[BOBMessageHandle successMessageHandle:val] completed:YES];
            }else{
                NSLog(@"did finish request, data: %@, error: %@", responseString,
                error);
                [self failWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"7" suffix:@"001"] completed:YES];
            }
        }];
    });
}
@end


