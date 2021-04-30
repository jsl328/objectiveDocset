
/*!
@header 获取网络状态信息-getNetStatu
@abstract 获取网络状态信息
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_getNetStatu.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "SystemInfoUtil.h"
#import "BOBMessageHandle.h"

/*!
@method
@abstract 方法名：getNetStatu
@param 无参数
@result 输出参数
 @textblock
 <apiXmpBegin>
 status 回调状态
 message 回调信息
 callbackData 返回状态条信息
    --type
    --typeName
 <apiXmpEnd>
 @/textblock
<apiXmpBegin>
function tmf_getNetStatu() {
     TMFJSBridge.invoke('getNetStatu', {}, function(res) {
     if(res['type'] == '7'){
        alert('网络连接正常');
     }else{
        alert('无网络连接');
     }
     });
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_getNetStatu

- (void)invokeWithParameters:(NSDictionary *)parameters
{
    //NSMutableDictionary *values = [NSMutableDictionary dictionary];
    //values[@"status"] =[SystemInfoUtil isNetwork]?@"0":@"1";
    
    NSDictionary *value =MQQDictionaryValue(parameters, nil);
    if (!value) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"11" suffix:@"06"] completed:YES];
        return;
    }else{
        if (![SystemInfoUtil networkType])
            [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"11" suffix:@"00"] completed:YES];
        else
            [self finishWithValues:[BOBMessageHandle successMessageHandle:[SystemInfoUtil networkType]] completed:YES];
    }
}
@end
