/*!
@header 查询当前栈里所有容器参数-queryH5ContainerData
@abstract 查询当前栈里所有容器参数
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_queryH5ContainerData.h"
#import "PCDH5ContainerManager.h"
#import "TMFJSBridgeWKWebViewController.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "BOBMessageHandle.h"
@interface TMFJSBridgeInvocation_queryH5ContainerData ()

/*!
@method
@abstract 方法名：queryH5ContainerData
@param parameters 无输入参数
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData 返回栈信息数组
 --containerId 容器id
 --pageid
 --url
 --param
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
function tmf_getContainerStack(){
    TMFJSBridge.invoke('queryH5ContainerData', {}, function(res) {
        tmf_alert(JSON.stringify(res));
    });
}
<apiXmpEnd>
@/textblock
*/

- (void)queryH5ContainerData;

@end

@implementation TMFJSBridgeInvocation_queryH5ContainerData

- (void)invokeWithParameters:(NSDictionary *)parameters
{
    NSDictionary *value = MQQDictionaryValue(parameters, nil);
    if (!value) {
        [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"6" suffix:@"006"] completed:YES];
        return;
    }
    //获取所有容器的info
    if ([PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers.count>0) {
        NSMutableArray * arrInfo = [[NSMutableArray alloc] initWithCapacity:0];
        for (PCDH5ContainerInfo * info in [PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers) {
            NSDictionary * dic = @{@"containerId":info.ContainerId,
                                   @"pageId":info.PageId,
                                   @"url":info.strUrl,
                                   @"param":info.strParam
                                   };
            //处理前段问题
            TMFJSBridgeWKWebViewController * VC = (TMFJSBridgeWKWebViewController *)info.webVC;
            if (VC) {
                [arrInfo addObject:dic];
            }
        }
        [self finishWithValues:[BOBMessageHandle successMessageHandle:arrInfo] completed:YES];
    }else{
        [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"6" suffix:@"000"] completed:YES];
    }
}
- (void)queryH5ContainerData{
    
}

@end
