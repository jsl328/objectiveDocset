
#import "TMFJSBridgeInvocation_gateWay.h"
#import "TMFJSBridgeInvocation+Protected.h"

#import "TMFSharkCheckManager.h"
#import "BOBBaseNetWorkJSONHelper.h"
#import "NonGateWayNetWorkManager.h"
#import "NSObject+ToDictionary.h"
#import "BOBMessageHandle.h"


@implementation TMFJSBridgeInvocation_gateWay
-(void)invokeWithParameters:(NSDictionary *)parameters
{
    //初始化返回数据容器
    //NSMutableDictionary *values = [NSMutableDictionary dictionary];
    //isPassGateWay字段作为走不走网关的标识符,defalut = YES,走网关
    BOOL isPassGateWay = MQQBoolValue(parameters[@"isPassGateWay"], YES);
    if (isPassGateWay) {
        //初始化移动网关
        [[TMFSharkCheckManager sharkShared]initSharkSDK];
        //网关接口名称
        NSString *cmd = MQQStringValue(parameters[@"cmdId"], nil);
        if (!cmd) {
            [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"7" suffix:@"000"] completed:YES];
            return;
        }
        NSDictionary *objDict = MQQDictionaryValue(parameters[@"data"], nil);
        //NSData *objData = MQQDataValue(parameters[@"data"], nil);
        //在子线程延迟执行,并且延迟1秒执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[TMFSharkCheckManager sharkShared]fetchSharkRequestWithcmd:cmd reqHeader:nil reqData:objDict completed:^(TMFSharkResponseHeaders * _Nullable headers, NSData * _Nullable responseData, NSError * _Nullable error) {
                // 业务解析数据
                NSString *responseString = nil;
                if (error.code==0) {
                    id val = [responseData JSONValue];
                    NSLog(@"网关接口返回数据之---%@",val);
                    [self finishWithValues:[BOBMessageHandle successMessageHandle:val] completed:YES];
                }else{
                    NSLog(@"did finish request, data: %@, error: %@", responseString,
                    error);
                    [self failWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"7" suffix:@"001"] completed:YES];
                }
            }];
        });
    }else{
        //不走网关的纯洁的网络请求，使用NonGateWayNetWorkManager
        NSString *strUrl = MQQStringValue(parameters[@"url"], nil);
        NSString *method =MQQStringValue(parameters[@"param"],@"POST");
        double timeout = MQQDoubleValue(parameters[@"timeout"], 120);
        //BOOL verifySSL = MQQBoolValue(parameters[@"sslVerify"],NO);
        NSDictionary *param = MQQDictionaryValue(parameters[@"param"], nil);
        if (!param) {
            [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"7" suffix:@"000"] completed:YES];
            return;
        }
        [[NonGateWayNetWorkManager nonGWNetWorkSharedInstance] nonGateWayNetWorkRequestURL:strUrl method:method timeOut:timeout withHeader:nil withParams:param withUseInfo:nil completed:^(XMResponse * _Nullable response, NSDictionary * _Nullable errorDict) {
            if (response) {
                id val = MQQDictionaryValue(response.responseObj, nil);
                NSLog(@"不通过网关发出去的请求%@",val);
                [self finishWithValues:[BOBMessageHandle successMessageHandle:val] completed:YES];
            }else{
                [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"7" suffix:@"001"] completed:YES];
            }
        }];
    }
}

@end
