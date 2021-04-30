
/*!
@header 设备越狱检查-rootCheck
@abstract 设备越狱检查rootCheck
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_rootCheck.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "SystemInfoUtil.h"
#import "BOBBaseAppGlobalDefines.h"
#import "BOBMessageHandle.h"

/*!
@method
@abstract 方法名：rootCheck
@param type 无输入参数
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData true:越狱,false:未越狱
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
 function tmf_rootCheck(){
  TMFJSBridge.invoke('rootCheck', {
         }, function(res) {
             alert(res);
         });
 }
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_rootCheck
- (void)invokeWithParameters:(NSDictionary *)parameters
{
    //@PCDWeakSelf(self);
    //NSMutableDictionary *values = [NSMutableDictionary dictionary];
    BOOL isBroken = [SystemInfoUtil isBroken];
    if (isBroken) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"当前设备为越狱设备,请在非越狱设备上运行本应用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            abort();
            //selfWeak.webViewController =nil;
        }];
        [alert addAction:conform];
        [self.webViewController presentViewController:alert animated:YES completion:nil];
    }
    [self finishWithValues:[BOBMessageHandle successMessageHandle:[NSString
                                                                   stringWithFormat:@"%d",isBroken]] completed:YES];
}
@end
