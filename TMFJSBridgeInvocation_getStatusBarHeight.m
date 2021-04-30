
/*!
@header 获取设备状态条高度-getStatusBarHeight
@abstract 获取设备状态条高度
@author jiangsl
@version 5.0.0
*/


#import "TMFJSBridgeInvocation_getStatusBarHeight.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "SystemInfoUtil.h"
#import "BOBMessageHandle.h"

/*!
@method
@abstract 方法名：getStatusBarHeight
@param parameters 无输入参数
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData 返回设备的状态条高度，比如20,44
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
function tmf_getStatusBarHeight() {
     TMFJSBridge.invoke('getStatusBarHeight', {}, function(res) {
        alert(JSON.stringify(res.statusBarHeight));
     });
}
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_getStatusBarHeight

- (void)invokeWithParameters:(NSDictionary *)parameters
{
    //NSMutableDictionary *values = [NSMutableDictionary dictionary];
    //NSString *message = MQQStringValue(parameters[@"message"], nil);
    NSDictionary *value =MQQDictionaryValue(parameters, nil);
    if (!value) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"12" suffix:@"06"] completed:YES];
        return;
    }else{
        if (![SystemInfoUtil systemStatusBarHeiht])
            [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"12" suffix:@"00"] completed:YES];
        else
            [self finishWithValues:[BOBMessageHandle successMessageHandle: @{@"statusBarHeight":@([SystemInfoUtil systemStatusBarHeiht])}] completed:YES];
    }
}

@end
