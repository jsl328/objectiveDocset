
/*!
@header 数据存储-webContainerData
@abstract 数据存储webContainerData
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_webContainerData.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "BOBBankApplicationMermoryManager.h"
#import "BOBMessageHandle.h"

/*!
@method
@abstract 方法名：webContainerData
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
function tmf_webContainerData() {
     TMFJSBridge.invoke('webContainerData', {
         "key": "key", //存取值key
         "value": "你好", //存值value
         "type": "set" //存取值类型set get remove
     }, function(res) {
         tmf_alert(JSON.stringify(res));
     });
 }
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_webContainerData
-(void)invokeWithParameters:(NSDictionary *)parameters{
    NSDictionary *messageDict = MQQDictionaryValue(parameters, nil);
    if (!messageDict) {
        [self failWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"4" suffix:@"000"] completed:YES];
        return;
    }
    if (messageDict) {
        //NSLog(@"---%@",messageDict);
        NSString *type =messageDict[@"type"];
        if ([type isEqualToString:@"set"]) {
            NSDictionary *ubefore =@{messageDict[@"key"]:messageDict[@"value"]};
            [ubefore enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [[BOBBankApplicationMermoryManager sharedInstance] setApplicationMermoryForData:obj withKey:key];
                [self finishWithValues:[BOBMessageHandle successMessageHandle:@"success"] completed:YES];
                *stop = YES;
                return;
            }];
        }else if ([type isEqualToString:@"get"]){
            NSString *aKey =messageDict[@"key"];
            if (aKey) {
                id obj= [[BOBBankApplicationMermoryManager sharedInstance]getApplicationMermoryForPath:aKey];
                NSLog(@"获取到的值%@",obj);
                [self finishWithValues:[BOBMessageHandle successMessageHandle:obj] completed:YES];
            }else{
                [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"4" suffix:@"001"] completed:YES];
            }
        }else if ([type isEqualToString:@"remove"]){
            NSString *aKey =messageDict[@"key"];
            if (aKey) {
                [[BOBBankApplicationMermoryManager sharedInstance]removeApplicationMermoryForPath:aKey];
                [self finishWithValues:[BOBMessageHandle successMessageHandle:@"success"] completed:YES];
            }else{
                [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"4" suffix:@"002"] completed:YES];
            }
        }//remove
    };
}
@end
