
/*!
@header 拨打电话-callPhone
@abstract 拨打电话
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_callPhone.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "BOBMessageHandle.h"


/*!
@method
@abstract 方法名：callPhone
@param telNum 电话号码
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData 调用成功返回YES
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
 function tmf_telPhone(){
     TMFJSBridge.invoke('callPhone', {
         telNum:'15601227191'
     },function(res){
         
     });
 }
<apiXmpEnd>
@/textblock
*/


@implementation TMFJSBridgeInvocation_callPhone
-(void)invokeWithParameters:(NSDictionary *)parameters{
    NSDictionary *value =MQQDictionaryValue(parameters, nil);
    if (!value) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"5" suffix:@"006"] completed:YES];
        return;
    }
    NSString *telNum =value[@"telNum"];
    if (!telNum||[telNum isEqualToString:@""]) {
        [self failWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"5" suffix:@"000"] completed:YES];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",telNum]] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {
                [self finishWithValues:[BOBMessageHandle successMessageHandle:@"success"] completed:YES];
              }];
          } else {
              //iOS10以前
              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",telNum]]];
          }
    });
}
@end
