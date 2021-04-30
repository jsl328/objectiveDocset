
/*!
@header 获取设备guid信息-getPCDGUID
@abstract 获取设备guid信息
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_getPCDGUID.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "TMFSharkCheckManager.h"
#import "BOBMessageHandle.h"

/*!
@method
@abstract 方法名：getPCDGUID
@param parameters 无输入参数
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData 返回guid信息，字符串
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
 function tmf_getGUID( {
    TMFJSBridge.invoke('getPCDGUID', {}, function(res) {
        tmf_alert(JSON.stringify(res));
    });
}
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_getPCDGUID
-(void)invokeWithParameters:(NSDictionary *)parameters{
    NSDictionary *value =MQQDictionaryValue(parameters, nil);
    if (!value) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"9" suffix:@"006"] completed:YES];
        return ;
    }
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    [[TMFSharkCheckManager sharkShared]fetchGUID:^(NSString * _Nullable guid, NSError * _Nullable error) {
        if (guid) {
            values[@"guid"] = guid;
            [self finishWithValues:[BOBMessageHandle successMessageHandle:values] completed:YES];
        }else{
            //39000
            [self failWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"9" suffix:@"000"] completed:YES];
        }
    }];
}
@end
