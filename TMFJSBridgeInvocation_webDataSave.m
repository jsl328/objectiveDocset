
/*!
@header 数据微型持久化存储-webDataSave
@abstract 数据微型持久化存储webDataSave
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_webDataSave.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "PCDSaveUtil.h"
#import "BOBMessageHandle.h"

/*!
@method
@abstract 方法名：webDataSave
@param type 输入参数"set","get","remove"
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData 如果type=get返回存储数据，如果type=set，remove返回操作成功
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
function saveWebData(t) {
     TMFJSBridge.invoke('webDataSave', {
         key:"/JX/JX0/TJX0001/maskFlag",
         value:"{\"maskFlag\":1}",
         type:t
     }, function (res) {
         alert(res)
     });
}
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_webDataSave
-(void)invokeWithParameters:(NSDictionary *)parameters{
//    NSMutableDictionary *rest = [NSMutableDictionary dictionary];
    NSDictionary *messageDict = MQQDictionaryValue(parameters, nil);
    NSString *type =messageDict[@"type"];
    if (!messageDict||!type||[type isEqualToString:@""]) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"17" suffix:@"06"] completed:YES];
        return;
    }
    //rest[@"success"] =@(NO);
    NSString *suc = nil;
    if ([type isEqualToString:@"set"]) {
        NSDictionary *ubefore =@{messageDict[@"key"]:messageDict[@"value"]};
        [PCDSaveUtil addUserObject:ubefore];
//        rest[@"success"] =@(YES);
        suc = @"success";
    }else if ([type isEqualToString:@"get"]){
        NSString *aKey =messageDict[@"key"];
        if (!aKey) {
            [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"17" suffix:@"00"] completed:YES];
            return;
        }
        if (aKey) {
            NSString *res =[PCDSaveUtil userObjectForKey:aKey];
            [self finishWithValues:[BOBMessageHandle successMessageHandle:res] completed:YES];
        }
        return;
    }else if ([type isEqualToString:@"remove"]){
        NSString *aKey =messageDict[@"key"];
        if (aKey) {
            [PCDSaveUtil removeUserObjectForKey:aKey];
//            rest[@"success"] =@(YES);
            suc = @"success";
        }
    }
    [self finishWithValues:[BOBMessageHandle successMessageHandle:suc] completed:YES];
}
@end
