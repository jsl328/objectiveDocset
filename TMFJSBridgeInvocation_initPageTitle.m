/*!
@header 自定义导航栏-initPageTitle
@abstract  自定义导航栏 initPageTitle
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_initPageTitle.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "TMFJSBridgeWKWebViewController.h"
#import "BOBMessageHandle.h"

/*!
@method
@abstract 方法名：initPageTitle
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
 function initPageTitle() {
     TMFJSBridge.invoke('initPageTitle', {"statuBarShow":"true","navShow":"true", "titleColor":"#222222", "bgColor":"#ffffff","title":"初始化标题","isShowLine":"false","leftButton":{"exist":"true","name":"back","func":function (res) {goBack();}},"rightButton":{"exist":"true","name":"更多","func":function (res) {alert("更多按钮点击");}}}, function (res) {
     });
 }
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_initPageTitle

- (void)invokeWithParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    NSDictionary *message = MQQDictionaryValue(parameters, nil);
    if (!message) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"19" suffix:@"06"] completed:YES];
        return;
    }
    if (message) {
        TMFJSBridgeWKWebViewController *webVC = (TMFJSBridgeWKWebViewController*)self.webViewController;
        BOOL statuBarShow =[message[@"statuBarShow"] boolValue];
        BOOL navShow =[message[@"navShow"] boolValue];
        NSString * titleColor =message[@"titleColor"];
        NSString * bgColor =message[@"bgColor"];
        NSString * title =message[@"title"];
        BOOL isShowLine =[message[@"isShowLine"] boolValue];
        BOOL lexist =[message[@"leftButton"][@"exist"] boolValue];
        NSString * lName =message[@"leftButton"][@"name"];
        BOOL rexist =[message[@"rightButton"][@"exist"] boolValue];
        NSString * rName =message[@"rightButton"][@"name"];
        
        //落实更新
        [webVC updateHeaderAttributes:statuBarShow navShow:navShow titleColor:titleColor bgColor:bgColor title:title showLine:isShowLine leftExist:lexist leftName:lName rightExist:rexist rightName:rName leftAction:^(NSString * _Nonnull name, NSInteger tag) {
            [self finishWithValues:values completed:YES];
        } rightAciton:^(NSString * _Nonnull name , NSInteger tag) {
            [self finishWithValues:values completed:YES];
        }];
    }
}
/*
 TMFJSBridge.invoke('initPageTitle', {"statuBarShow":"false","navShow":"false", "titleColor":"#222222", "bgColor":"#ffffff","title":"初始化标题","isShowLine":"false","leftButton":{"exist":"true","name":"whiteback","func":function (res) {goBack();}},"rightButton":{"exist":"true","name":"更多","func":function (res) {alert("更多按钮点击");}}
 
 }, function (res) {
 });
 */
@end
