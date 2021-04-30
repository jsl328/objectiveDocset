
/*!
@header 二维码扫描-openCodeDetector
@abstract 二维码扫描 openCodeDetector
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_openCodeDetector.h"
#import "TMFJSBridgeInvocation+Protected.h"

#import "PCDCodeScannerController.h"
#import "BOBMessageHandle.h"

@interface TMFJSBridgeInvocation_openCodeDetector()<PCDCodeScannerControllerDelegate>

@end

/*!
@method
@abstract 方法名：openCodeDetector
@param type 无输入参数
@result 输出参数为二维码识别结果
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData 返回成功二维码识别结果
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
function tmf_qrCodeScan() {
     TMFJSBridge.invoke('openCodeDetector', {
         "leftBtnFunc": function(){tmf_ryt_alert("left");},
         "centerBtnFunc": function(){tmf_ryt_alert("center");},
         "rightBtnFunc": function(){tmf_ryt_alert("right");},
         "scanCallback": function(res){tmf_scan_alert(res.callbackData);}
     }, function (res) {
     });
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_openCodeDetector
- (void)invokeWithParameters:(NSDictionary *)parameters
{
    NSDictionary *dict = MQQDictionaryValue(parameters, nil);
    if (!dict) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"18" suffix:@"06"] completed:YES];
        return;
    }
    //二维码扫描
    PCDCodeScannerController *codeVC = [[PCDCodeScannerController alloc] initWithNibName:@"PCDCodeScannerController" bundle:nil];
    codeVC.delegate = self;
    codeVC.isClose = YES;
    UINavigationController *nav = self.webViewController.navigationController;
    if (nav == nil) {
        nav = self.webViewController.tabBarController.navigationController;
    }
    [nav pushViewController:codeVC animated:NO];
}
- (void)codeScannerController:(PCDCodeScannerController *)controller didScanResult:(NSString *)result
{
    [controller.navigationController popViewControllerAnimated:YES];
    [self finishWithValues:[BOBMessageHandle successMessageHandle:result] completed:YES];
    
}
@end
