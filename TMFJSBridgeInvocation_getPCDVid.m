
/*!
@header 获取设备vid信息-getPCDVid
@abstract 获取设备vid信息
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_getPCDVid.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "BOBMessageHandle.h"
#import "TMFSharkCheckManager.h"


/*!
@method
@abstract 方法名：getPCDVid
@param parameters 无输入参数
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData 返回vid信息，字符串
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
 function tmf_getGUID() {
     TMFJSBridge.invoke('getPCDGUID', {}, function (res) {
         alert(JSON.stringify(res));
     });
 }
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_getPCDVid

- (void)invokeWithParameters:(NSDictionary *)parameters
{
    NSDictionary *value =MQQDictionaryValue(parameters, nil);
    if (!value) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"13" suffix:@"06"] completed:YES];
        return;
    }
    [[TMFSharkCheckManager sharkShared]fetchVID:^(NSString * _Nullable vid, NSError * _Nullable error) {
        if (!vid) {
            [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"13" suffix:@"00"] completed:YES];
        }else{
            [self finishWithValues:[BOBMessageHandle successMessageHandle:vid] completed:YES];
        }
    }];
}
@end
