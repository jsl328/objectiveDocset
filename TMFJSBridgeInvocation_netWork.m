//
//  tNetWork.m
//  BOBBaseApp
//
//  Created by jiangsl on 2021/3/22.
//

#import "TMFJSBridgeInvocation_netWork.h"
#import "TMFJSBridgeInvocation+Protected.h"

#import "XMNetworking.h"
#import "NSMutableDictionary+BOBBaseNetSafeSetObject.h"
#import "NonGateWayNetWorkManager.h"
#import "BOBMessageHandle.h"
@implementation TMFJSBridgeInvocation_netWork
-(void)invokeWithParameters:(NSDictionary *)parameters{
    
    //NSMutableDictionary *values = [NSMutableDictionary dictionary];
    
    NSString *strUrl = MQQStringValue(parameters[@"url"], nil);
    NSString *method =MQQStringValue(parameters[@"param"],@"POST");
    double timeout = MQQDoubleValue(parameters[@"timeout"], 120);
    //BOOL verifySSL = MQQBoolValue(parameters[@"sslVerify"],NO);
    
    NSDictionary *param = MQQDictionaryValue(parameters[@"param"], nil);
    if (!param) {
        [self finishWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"8" suffix:@"000"] completed:YES];
        return;
    }
    //NSDictionary *header = MQQDictionaryValue(parameters[@"header"], nil);
    //NSDictionary *query = MQQDictionaryValue(parameters[@"query"], nil);
    [[NonGateWayNetWorkManager nonGWNetWorkSharedInstance] nonGateWayNetWorkRequestURL:strUrl method:method timeOut:timeout withHeader:nil withParams:param withUseInfo:nil completed:^(XMResponse * _Nullable response, NSDictionary * _Nullable errorDict) {
        if (response) {
            id val= MQQDictionaryValue(response.responseObj, nil);
            NSLog(@"--网络请求--%@",val);
            [self finishWithValues:[BOBMessageHandle successMessageHandle:val] completed:YES];
        }else{
            //values[@"data"] = errorDict;
            [self failWithValues:[BOBMessageHandle failUnCoverageFuncMessageHandlePrefix:@"8" suffix:@"001"] completed:YES];
        }
    }];
}
@end
