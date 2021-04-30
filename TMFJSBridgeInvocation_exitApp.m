//
//  TMFJSBridgeInvocation_exitApp.m
//  BOBBaseApp
//
//  Created by jiangsl on 2021/4/7.
//  Copyright © 2021 jiangsl. All rights reserved.
//

/*!
@header 手动退出app-exitApp
@abstract 手动退出app exitApp
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_exitApp.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "BOBMessageHandle.h"

/*!
@method
@abstract 方法名：exitApp
@param type 输入参数
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData true:退出成功
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
function tmf_exitApp(t) {
     TMFJSBridge.invoke('exitApp', {
         type:t,
     }, function (res) {
         alert(res)
     });
 }
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_exitApp

- (void)invokeWithParameters:(NSDictionary *)parameters
{
    NSDictionary *value = MQQDictionaryValue(parameters, nil);
    if (!value) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"7" suffix:@"006"] completed:YES];
        return;
    }
    NSString *message = MQQStringValue(parameters[@"type"], nil);
    if (!message||[message isEqualToString:@""]) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"7" suffix:@"000"] completed:YES];
        return;
    }
    if (message&&[message isEqualToString:@"exitApp"]) {
        //退出App
        [self exitApplication];
    }
}
- (void)exitApplication {
    //NSMutableDictionary *values = [NSMutableDictionary dictionary];
    //@WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [UIView animateWithDuration:0.5f animations:^{
            window.alpha = 0;
            //window.frame = CGRectMake(0, window.bounds.size.height / 2, window.bounds.size.width, 0.5);
        } completion:^(BOOL finished) {
            //values[@"success"] = @(YES);
            [self finishWithValues:[BOBMessageHandle successMessageHandle:@"success"] completed:YES];
            exit(0);//这种方式安全一些
        }];
    });
}
@end


