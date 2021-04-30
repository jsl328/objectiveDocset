
/*!
@header 返回上一页-goBack
@abstract  返回上一页 goBack
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_goBack.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "TMFJSBridgeWKWebViewController.h"
#import "BOBMessageHandle.h"

/*!
@method
@abstract 方法名：goBack
@param type  无输入参数
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData 返回"success"
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
 function goBack(){
    TMFJSBridge.invoke('goBack', {
    }, function (res) {
        alert(res);
    });
 }
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_goBack
-(void)invokeWithParameters:(NSDictionary *)parameters
{
//    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    NSDictionary *message = MQQDictionaryValue(parameters, nil);
    if (!message) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"18" suffix:@"06"] completed:YES];
        return;
    }
    if (message) {
        TMFJSBridgeWKWebViewController *webVC = (TMFJSBridgeWKWebViewController*)self.webViewController;
        //实施更新
        [webVC goBack:^(NSString * _Nonnull name , NSInteger tag) {
            //name是按钮的名字，tag是button的tag
            if (name) {
                [self finishWithValues:[BOBMessageHandle successMessageHandle:@"success"] completed:YES];
            }
        }];
    }
}
@end
