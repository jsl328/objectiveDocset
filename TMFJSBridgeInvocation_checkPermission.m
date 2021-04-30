
/*!
@header 权限检查-checkPermission
@abstract 权限检查 checkPermission
@author jiangsl
@version 5.0.0
*/
#import "TMFJSBridgeInvocation_checkPermission.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "BOBBasePermissionManager.h"
#import "BOBMessageHandle.h"

typedef NS_OPTIONS(NSUInteger, PermissionType) {
    PermissionTypeLocation = 1 << 0,
    PermissionTypePhotoLib = 1 << 1,
    PermissionTypeCamera= 1 << 2,
    PermissionTypeRecord = 1 << 3,
    PermissionTypeContact= 1 << 4,
    PermissionTypeOther = 1 << 5,
};

@implementation TMFJSBridgeInvocation_checkPermission
/*!
@method
@abstract 方法名：checkPermission
@param type 权限,location定位权限
@result 输出参数
@textblock
<apiXmpBegin>
 status 回调状态
 callbackData 返回权限开关，open开，close关
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
function life_callback() {
 TMFJSBridge.invoke('checkPermission', {
        "type": "location"
    }, function(res) {
        alert(JSON.stringify(res));
    });
}
<apiXmpEnd>
@/textblock
*/
- (void)invokeWithParameters:(NSDictionary *)parameters
{
    NSDictionary *value = MQQDictionaryValue(parameters, nil);
    if (!value) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"6" suffix:@"006"] completed:YES];
        return;
    }
    NSString *type = MQQStringValue(parameters[@"type"], nil);
    if (!type||[type isEqualToString:@""]) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"6" suffix:@"000"] completed:YES];
        return;
    }
    BOOL ret =NO;
    if ([type isEqualToString:@"location"]) {
        //定位权限
        ret = [BOBBasePermissionManager deviceHasLocationPermission];
//        values[@"callbackData"] = @(ret);
    }else if ([type isEqualToString:@"photoLib"]){
        ret = [BOBBasePermissionManager deviceHasPhotoPermission];
//        values[@"callbackData"] = @(ret);
    }else if ([type isEqualToString:@"camera"]){
        ret = [BOBBasePermissionManager deviceHasCameraPermission];
//        values[@"callbackData"] = @(ret);
    }else if ([type isEqualToString:@"record"]){
        ret = [BOBBasePermissionManager deviceHasRecordPermission];
//        values[@"callbackData"] = @(ret);
    }else if ([type isEqualToString:@"contact"]){
        ret = [BOBBasePermissionManager deviceHasContactPermission];
//        values[@"callbackData"] = @(ret);
    }else{
        
    }
    [self finishWithValues:[BOBMessageHandle successMessageHandle:ret?@"open":@"close"] completed:YES];
}
@end
