
/*!
@header 获取设备信息-getDeviceInfo
@abstract  获取设备信息 getDeviceInfo
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_getDeviceInfo.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "SystemInfoUtil.h"
#import "BOBMessageHandle.h"
/*!
@method
@abstract 方法名：getDeviceInfo
@param type 输入参数
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData 设备信息参数
    --platform 平台信息
    --channel 通道
    --ip ipv4地址
    --mac mac地址
    --deviceId 设备id
    --phoneModel 设备模型
    --systemVersion  系统版本
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
 function tmf_getDeviceInfo() {
     TMFJSBridge.invoke('getDeviceInfo', {
     }, function(res) {
         tmf_alert(JSON.stringify(res.systemVersion));
     });
 }
<apiXmpEnd>
@/textblock
*/
@implementation TMFJSBridgeInvocation_getDeviceInfo

- (void)invokeWithParameters:(NSDictionary *)parameters
{
    NSDictionary *value = MQQDictionaryValue(parameters, nil);
    if (!value) {
        //38006
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"8" suffix:@"006"] completed:YES];
        return;
    }
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    values[@"platform"] = [SystemInfoUtil platform];
    values[@"channel"] = @"1";
    values[@"ip"] = [SystemInfoUtil ipAddress:YES];
    values[@"mac"] = [SystemInfoUtil macAddress];
    values[@"deviceId"] =[SystemInfoUtil deviceID];
    values[@"phoneModel"] = [NSString stringWithFormat:@"%@:%@",[SystemInfoUtil deviceName],[SystemInfoUtil deviceType]];
    values[@"systemVersion"] =[SystemInfoUtil systemVersion];
    if (!values) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"8" suffix:@"000"] completed:YES];
    }else{
        [self finishWithValues:values completed:YES];
    }
}
@end
