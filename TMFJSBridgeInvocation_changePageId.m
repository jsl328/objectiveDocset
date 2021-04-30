/*!
@header 更改页面id-changePageId
@abstract 更改页面id
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_changePageId.h"
#import "PCDH5ContainerManager.h"
#import "TMFJSBridgeInvocation+Protected.h"

#import "BOBBaseAppGlobalDefines.h"
#import "BOBMessageHandle.h"

@interface TMFJSBridgeInvocation_changePageId()

/*!
@method
@abstract 方法名：changePageId
@param containerId 容器id
@param pageId 新页面id
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
callbackData 无
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
function tmf_changePageId() {
    TMFJSBridge.invoke('changePageId', {
        "containerId": "1000111", //容器id
        "pageId": "1002" //新页面id
    }, function(res) {
        tmf_alert(JSON.stringify(res));
    });
}
<apiXmpEnd>
@/textblock
*/

- (void)changePageId;

@end

@implementation TMFJSBridgeInvocation_changePageId

- (void)changePageId{
    
}
- (void)invokeWithParameters:(NSDictionary *)parameters {
    NSString *pageId = parameters[@"pageId"];
    NSString *containerId = parameters[@"containerId"]; //容器Id
    
    if (pageId == nil ||
        containerId == nil ||
        [pageId isEqualToString:@""] ||
        [containerId isEqualToString:@""]) {
        [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"2" suffix:@"000"] completed:YES];
        return;
    }
    
    //判断是否为当前容器
    PCDH5ContainerInfo *currentInfo = [PCDH5ContainerManager shareH5ManagerInstance].currentInfo;
    if ([currentInfo.ContainerId isEqualToString:containerId]) {
        currentInfo.PageId = pageId;
        [PCDH5ContainerManager shareH5ManagerInstance].currentInfo = currentInfo;
    }
    
    //同时更改模型数组里的info信息；
    if ([PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers.count > 0) {
        [[PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers enumerateObjectsUsingBlock:^(PCDH5ContainerInfo *_Nonnull info, NSUInteger index, BOOL * _Nonnull stop) {
            if ([info.ContainerId isEqualToString:containerId]) {
                PCDH5ContainerInfo *newInfo = info;
                newInfo.PageId = pageId;
                if ([PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers.count > 0) {
                    [[PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers replaceObjectAtIndex:index withObject:newInfo];
                }
                [self finishWithValues:[BOBMessageHandle successMessageHandle:@"更换成功"] completed:YES];
                *stop = YES;
                return;
            }
        }];
        
        /*
        PCDH5ContainerInfo *newInfo;
        for (PCDH5ContainerInfo *info in [PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers) {
            if ([info.ContainerId isEqualToString:containerId]) {
                newInfo = info;
                newInfo.PageId = pageId;
                NSInteger index = [[PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers indexOfObject:info];
                if ([PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers.count > 0) {
                    [[PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers replaceObjectAtIndex:index withObject:newInfo];
                }
                [self finishWithValues:@{@"status":@"0",@"message":@"更换成功"} completed:YES];
                return;
            }
        }
         */
        [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"2" suffix:@"001"] completed:YES];
    } else {
        //回调
        [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"2" suffix:@"002"] completed:YES];
    }
}

@end
