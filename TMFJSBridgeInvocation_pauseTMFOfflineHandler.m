
#import "TMFJSBridgeInvocation_pauseTMFOfflineHandler.h"
#import "TMFJSBridgeInvocation+Protected.h"

#import "BOBOfflineMessageIntercept.h"

//static BOOL ErrorHasOccured(void);
//static BOOL HandleError(void);

@implementation TMFJSBridgeInvocation_pauseTMFOfflineHandler

- (void)invokeWithParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    
    NSString *message = MQQStringValue(parameters[@"message"], nil);
    if (message) {
        values[@"version"] = @"1.0.0.0";
    }
    NSRecursiveLock *aLock = [[NSRecursiveLock alloc] init];
    [aLock lock];
    voidOnExit {
        [aLock unlock];
        NSLog(@"2");
    };
    NSLog(@"1");
    [BOBOfflineMessageIntercept blockCleanUpCarryMutliParam];
    [self finishWithValues:values completed:YES];
}

//static BOOL ErrorHasOccured(){
//    return NO;
//}
//
//static BOOL HandleError(){
//    return  NO;
//}
@end
