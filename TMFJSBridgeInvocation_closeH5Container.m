/*!
@header 关闭容器-closeH5Container
@abstract 关闭容器
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_closeH5Container.h"
#import "PCDH5ContainerManager.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "BOBMessageHandle.h"

@interface TMFJSBridgeInvocation_closeH5Container()
/*!
@method
@abstract 方法名：closeH5Container
@param containerId 容器id,保证唯一性
@param reloadWeb 是否需要容器自动刷新
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData 无
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
function tmf_closeH5Container() {
    TMFJSBridge.invoke('closeH5Container', {
        "containerId": "" //容器id，保证唯一性
    }, function(res) {});
}
<apiXmpEnd>
@/textblock
*/
- (void)closeH5Container;

@end

@implementation TMFJSBridgeInvocation_closeH5Container

- (void)invokeWithParameters:(NSDictionary *)parameters
{
    @autoreleasepool {
        NSString *containerId = parameters[@"containerId"]; //容器Id
        NSString * reloadWeb = MQQStringValue(parameters[@"needReload"], @"false") ;
        UIViewController *rootVC = (UIViewController *)self.webViewController;
        if (containerId && ![containerId isEqualToString:@""]) {  //跳指定容器
            if ([containerId isEqualToString:@"allContainer"]) {  //关闭所有容器,回到第一个容器开启的页面
                [[PCDH5ContainerManager shareH5ManagerInstance] popStackAllContainer:rootVC.navigationController];
            }else{
                PCDH5ContainerInfo * toInfo;
                for (PCDH5ContainerInfo * info in [PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers) {
                    NSLog(@"%@",info.ContainerId);
                    if ([[NSString stringWithFormat:@"%@", info.ContainerId] isEqualToString:containerId]) {
                        toInfo = info;
                        break;
                    }
                }
                //找不到对应容器Id，不做出栈处理
                if (toInfo) {
                    if (reloadWeb && [reloadWeb isEqualToString:@"true"]) {
                        toInfo.isNeedReload = YES;
                    }else{
                        toInfo.isNeedReload = NO;
                    }
                    [[PCDH5ContainerManager shareH5ManagerInstance] popStack:toInfo navigationVC:rootVC.navigationController];
                    [self finishWithValues:[BOBMessageHandle successMessageHandle:@"关闭容器成功"] completed:YES];
                }
                /* 2020.08.05 与Android统一找不到容器ID的逻辑：容器ID，返回首页
                else{
                    //                [[PCDToastView TipWithTitle:@"容器ID不对，返回上一级。" Type:Words] show];
                    //容器ID不对，直接关闭当前容器
                    if ([PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers.count >= 2) {
                        PCDH5ContainerInfo * toInfo = [PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers[[PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers.count-2];
                        if (toInfo) {
                            if (reloadWeb && [reloadWeb isEqualToString:@"true"]) {
                                toInfo.isNeedReload = YES;
                            }else{
                                toInfo.isNeedReload = NO;
                            }
                        }
                        [[PCDH5ContainerManager shareH5ManagerInstance] popStack:toInfo navigationVC:rootVC.navigationController];
                        [self finishWithValues:@{@"status":@"0",
                                                 @"message":@"关闭容器，返回上一级"
                        } completed:YES];
                        
                    }else{
                        [[PCDH5ContainerManager shareH5ManagerInstance] popStack:nil navigationVC:rootVC.navigationController];
                        [self finishWithValues:@{@"status":@"0",
                                                 @"message":@"关闭容器，返回上一级"
                        } completed:YES];
                    }
                }
                 */
                // 2020.08.05 与Android统一找不到容器ID的逻辑：容器ID，返回首页
                else {
                    [[PCDH5ContainerManager shareH5ManagerInstance] resetH5ContainerInfo];
                    [self.webViewController.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            
        }else{ //如果为空，则直接返回上一级,关闭当前容器
            //判断下上一级页面是否是客户端页面（扫一扫），是则返回客户端页面，否则走容器栈处理；（测试bug处理）
            UINavigationController * navVC = self.webViewController.navigationController;
            //获取上一级页面的VC
            if ([PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers.count >= 2) {
                
                PCDH5ContainerInfo * toInfo = [PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers[[PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers.count-2];
                if (toInfo) {
                    if (reloadWeb && [reloadWeb isEqualToString:@"true"]) {
                        toInfo.isNeedReload = YES;
                    }else{
                        toInfo.isNeedReload = NO;
                    }
                }
                [[PCDH5ContainerManager shareH5ManagerInstance] popStack:toInfo navigationVC:rootVC.navigationController];
                [self finishWithValues:[BOBMessageHandle successMessageHandle:@"关闭容器，返回上一级"] completed:YES];
            }else{
                [[PCDH5ContainerManager shareH5ManagerInstance] popStack:nil navigationVC:rootVC.navigationController];
                [self finishWithValues:[BOBMessageHandle successMessageHandle:@"关闭容器，返回上一级"] completed:YES];
            }
        }
    };
}
- (void)closeH5Container{
    
}

@end
