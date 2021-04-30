/*!
@header 打开新容器-打开第三方页面-openNewH5Container
@abstract 打开新容器-打开第三方页面
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_openNewH5Container.h"
#import "PCDH5ContainerManager.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "TMFJSBridgeWKWebViewController.h"
#import "BOBBaseWebViewManager.h"
#import "UIView+Controller.h"
#import "BOBQBWKWebViewService.h"
#import "BOBMessageHandle.h"

@interface TMFJSBridgeInvocation_openNewH5Container ()

/*!
@method
@abstract 方法名：openNewH5Container
@param url 页面全地址-必需
@param pageId 页面id-必需
@param containerId 容器id，保证唯一性-必需
@param pageTitle 页面标题-非必需
@param param 页面参数-非必需，格式为json字符串
@param userAgent UA
@param isThirdUrl 是否是三方页面，“true”为是，其他为否
@param setNavBackImg 是否设置导航头，“true”为是，其他为否
@param pageTitleParam 字符串类型，导航头设置参数
@param jsFunc 数组，需要注入的js方法，数字里的每个方法为字符串类型
@param interceptEventForiOS 预拦截H5页面url的数组，用于打开三方页面，三方页面触发了url，客户端进行匹配，执行相应方法
@param setRightBtn 用于第三方页面头部右按钮服务声明，并点击弹框显示内容，“true”为设置，其他为不设置
@param rightBtnAlertContent 点击弹框显示内容-用于第三方页面头部右按钮服务声明
@param type 值：1、正常打开新容器；2、关闭当前所有容器，打开新容器；3、关闭当前容器，打开新容器；4、关闭传入的容器ID之后的所有容器，打开新容器
@param shutContainerId 关闭的容器ID
@result 无输出参数
@discussion 用法：
@textblock
<apiXmpBegin>
function tmf_openT3H5Container() {
    // 获得 新的url
    var containerId = "10009"; //(new Date()).getTime();
    var pageId = "1009";
    TMFJSBridge.invoke('openNewH5Container', {
        "url": "http://www.baidu.com", //页面全地址
        "pageId": pageId, //页面id
        "pageTitle": "第三方页面", //标题
        "containerId": containerId, //容器id，保证唯一性
        "param": '{"param1":"001","param2":"002","param3":"003"}',
        "isThirdUrl": "true",
        "pageTitleParam": '{"navShow":"true","bgColor":"#ffffff","title":"第三方页面-百度","leftButton":{"exist":"true","name":"back","func":"leftbtnFunc"},"leftButton2":{"exist":"true","name":"close","func":""},"rightButton":{"exist":"true","name":"协议","func":"rightbtnFunc"} }',
        "jsFunc": ["var leftbtnFunc = function(){alert('左按钮点击');}", "function rightbtnFunc(){alert('右按钮点击-用户协议观看');}"]
    }, function(res) {});
}
<apiXmpEnd>
@/textblock
*/

- (void)openNewH5Container;

@end

@implementation TMFJSBridgeInvocation_openNewH5Container

- (void)invokeWithParameters:(NSDictionary *)parameters
{
    NSDictionary *value =MQQDictionaryValue(parameters, nil);
    if (!value) {
        [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"4" suffix:@"006"] completed:YES];
        return;
    }
    if (value) {
//        [[BOBQBWKWebViewService QBSharedInstance]usageQBWebView:self.webViewController cancel:^{
//        }];
//        return;
        @autoreleasepool {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                PCDH5ContainerInfo * info = [[PCDH5ContainerInfo alloc] init];
                NSString * url = value[@"url"];
                if (url == nil || [url isEqualToString:@""]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"url为空，无法打开新容器" preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                    [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"4" suffix:@"000"] completed:YES];
                    return;
                }
                info.strUrl   = url;
                info.url =[NSURL fileURLWithPath:url];
                
                info.PageId   = value[@"pageId"]?value[@"pageId"]:@"";
                info.strTitle   = value[@"pageTitle"]?value[@"pageTitle"]:@"";
                info.ContainerId   = value[@"containerId"]?value[@"containerId"]:@"";
                info.strParam = value[@"param"]?value[@"param"]:@{};
                info.arrJsFunc = value[@"jsFunc"]?value[@"jsFunc"]:@[];
                
                
                NSString *type;
                if ([value[@"type"] isKindOfClass:[NSNumber class]]) {
                    type = MQQStringValue([NSString stringWithFormat:@"%@",value[@"type"]], @"");
                } else {
                    type = MQQStringValue(value[@"type"], @"");
                }
                
                NSString *shutContainerID;
                if ([value[@"shutContainerId"] isKindOfClass:[NSNumber class]]) {
                    shutContainerID = MQQStringValue([NSString stringWithFormat:@"%@",value[@"shutContainerId"]], @"");
                } else {
                    shutContainerID = MQQStringValue(value[@"shutContainerId"], @"");
                }
                
                PCDH5ContainerInfo * toInfo;
                NSInteger index = -1;
                
                if (shutContainerID && [type isEqualToString:@"4"]) {
                    //关闭到指定容器后
                    for (int i = 0; i< [PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers.count; i++) {
                        PCDH5ContainerInfo * infoTemp = [PCDH5ContainerManager shareH5ManagerInstance].arrH5Containers[i];
                        if ([infoTemp.ContainerId isEqualToString:shutContainerID]) {
                            toInfo = infoTemp;
                            index = i;
                            break;
                        }
                    }
                }
                TMFJSBridgeWKWebViewController *rootVC = (TMFJSBridgeWKWebViewController *)self.webViewController;
                UINavigationController * navVC = rootVC.tabBarController.navigationController;
                if (navVC==nil) {
                    navVC = rootVC.navigationController;
                }
                //打开新容器
                [[PCDH5ContainerManager shareH5ManagerInstance] pushStack:info navigationVC:navVC];
                if ([type isEqualToString:@"2"]||[type isEqualToString:@"3"]||[type isEqualToString:@"4"]) {
                    //增加一个type类型 (打开后移除) 值：1、正常打开新容器；2、关闭当前所有容器，打开新容器；3、关闭当前容器，打开新容器；4、关闭传入的容器ID之后的所有容器，打开新容器,关闭的容器ID字段为：shutContainerId
                    [[PCDH5ContainerManager shareH5ManagerInstance] closeContainerVCAfterOpenNewNavigationVC:navVC containerInfo:toInfo infoIndex:index WithType:[type integerValue]];
                }
            });
        }
        if (![PCDH5ContainerManager shareH5ManagerInstance].jsInvoctaion) {
            [self finishWithValues:[BOBMessageHandle successMessageHandle:@"打开容器"] completed:YES];
        }
    }else{
        NSLog(@"参数不对，页面无法加载。。");
        [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"4" suffix:@"001"] completed:YES];
    }
}
- (void)openNewH5Container{
    
}
@end
