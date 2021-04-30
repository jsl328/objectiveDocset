
#import "TMFJSBridgeInvocation_encryptUseAES.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "BBBankSecurity.h"
@implementation TMFJSBridgeInvocation_encryptUseAES
-(void)invokeWithParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *rest = [NSMutableDictionary dictionary];
    rest[@"error"] =@(1);
    NSDictionary *messageDict = MQQDictionaryValue(parameters, nil);
    if (!messageDict||!messageDict[@"userid"]) {
        [self failWithValues:rest completed:YES];
        return;
    }
    NSString *userid = messageDict[@"userid"];
    BOOL qos =MQQBoolValue(messageDict[@"flag"], YES);
    if (qos) {
        NSString *encryCliper = [BBBankSecurity encryptedWithAES:userid iv:nil];
        rest[@"callData"] = encryCliper;
    }else{
        NSString *decryCliper = [BBBankSecurity decryptedWithAES: userid iv:nil];
        rest[@"callData"] = decryCliper;
    }
    [self failWithValues:rest completed:YES];
}

@end
