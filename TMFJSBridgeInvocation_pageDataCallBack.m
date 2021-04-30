/*!
@header 页面数据更新接口-pageDataCallBack
@abstract 页面数据更新接口
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_pageDataCallBack.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "TMFJSBridgeWKWebViewController.h"

@interface TMFJSBridgeInvocation_pageDataCallBack ()

/*!
@method
@abstract 方法名：pageDataCallBack
@param callback 回调方法体，该方法为客户端主动调用js去更新页面数据或其他处理；非必需，不需要时传值nil
@result 输出参数
@textblock
<apiXmpBegin>
 status 回调状态
 callbackData 返回栈信息数组
  --type 生命周期方法,"2"进入后台,"1"进入前台
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
function life_callback() {
    TMFJSBridge.invoke('pageDataCallBack', {
        "callback": function(res) {
            var text = res.type;
            if (text == "1") {
                tmf_alert('回调方法调用-取数据');
            } else {
                tmf_alert('回调方法调用-清数据');
            }
        }, //回调方法
    }, function(res) {
        tmf_alert(JSON.stringify(res));
    });
}
<apiXmpEnd>
@/textblock
*/

- (void)pageDataCallBack;

@end

@implementation TMFJSBridgeInvocation_pageDataCallBack

- (void)invokeWithParameters:(NSDictionary *)parameters {
    TMFJSBridgeWKWebViewController *webVC = (TMFJSBridgeWKWebViewController *)self.webViewController;
    //NSDictionary *message = MQQDictionaryValue(parameters[@"callback"], nil);
    webVC.jsInvoctaion = self;
    webVC.jsCallBack = parameters[@"callback"];
}

-(void)callbackWithIdentifier:(id)identifier values:(NSDictionary *)values{
    if (values) {
        [self finishWithValues:values completed:YES];
    }
//    NSMutableDictionary *values = [NSMutableDictionary dictionary];
//    [webVC pageDataCallBack:^{
//        [values setObject:@{@"text":@"1"} forKey:@"callbackData"];
//        [self finishWithValues:values completed:YES];
//    } withRecall:^{
//        [values setObject:@{@"text":@"2"} forKey:@"callbackData"];
//        [self finishWithValues:values completed:YES];
//    }];
}
- (void)pageDataCallBack{
    
}

@end
