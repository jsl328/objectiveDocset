
#import "TMFJSBridgeInvocation_getSingleNotice.h"
#import "TMFJSBridgeInvocation+Protected.h"

#import "TMFDataPushRegistrationManager.h"
@implementation TMFJSBridgeInvocation_getSingleNotice

- (void)invokeWithParameters:(NSDictionary *)parameters
{
    [[TMFDataPushRegistrationManager sharedInstance]updateCommonProfiles:@"" pro:@"" city:@"" depart:@""];
    [[TMFDataPushRegistrationManager sharedInstance]updateUserInfos:@"userId"];
    [[TMFDataPushRegistrationManager sharedInstance]updateCustomTags:@[@{@"key1":@"value1"},@{@"key2":@"value2"}]];
    [TMFDataPushRegistrationManager sharedInstance].jsInvoctaion = self;
    [TMFDataPushRegistrationManager sharedInstance].jsCallBack = parameters[@"callback"];
}

-(void)callbackWithIdentifier:(id)identifier values:(NSDictionary *)values
{
//    NSMutableDictionary *values = [NSMutableDictionary dictionary];
//    NSString *message = MQQStringValue(parameters[@"message"], nil);
//    if (message) {
//        values[@"version"] = @"1.0.0.0";
//    }
    [self finishWithValues:values completed:YES];
}
@end
