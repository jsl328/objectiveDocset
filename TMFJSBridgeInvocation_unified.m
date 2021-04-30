
#import "TMFJSBridgeInvocation_unified.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "WCDBModuleManager.h"
#import "SingleORM.h"
@implementation TMFJSBridgeInvocation_unified
-(void)invokeWithParameters:(NSDictionary *)parameters{
    NSMutableDictionary *rest = [NSMutableDictionary dictionary];
    rest[@"error"] =@(1);
    NSDictionary *messageDict = MQQDictionaryValue(parameters, nil);
    if (!messageDict||!messageDict[@"type"]) {
        [self failWithValues:rest completed:YES];
        return;
    }
    NSString *type = messageDict[@"type"];
    int rawNum = MQQIntValue(messageDict[@"idNum"], 100);
    if ([type isEqualToString:@"create"]) {
        SingleORM *insertObj =[[SingleORM alloc]init];
        insertObj.name =@"insert obj";
        insertObj.goal = 86;
        insertObj.identifier =rawNum;
        [[WCDBModuleManager WCDBMetaShareInstance]insertORMIntoDatabase:insertObj callBack:^(BOOL ret, NSError * _Nullable error) {
            if (ret) {
                rest[@"data"] =@(ret);
                [self finishWithValues:rest completed:YES];
            }else{
                rest[@"data"] =@(ret);
                [self failWithValues:rest completed:YES];
            }
        }];
    }else if ([type isEqualToString:@"get"]){
        [[WCDBModuleManager WCDBMetaShareInstance]selectORMMetaForSqlWhere:rawNum callBack:^(BOOL ret, id  _Nullable obj) {
            if (ret) {
                rest[@"data"] =obj;
                [self finishWithValues:rest completed:YES];
            }else{
                rest[@"data"] =@(ret);
                [self failWithValues:rest completed:YES];
            }
        }];
    }else if ([type isEqualToString:@"update"]){
        SingleORM *insertObj =[[SingleORM alloc]init];
        insertObj.name =@"update obj";
        insertObj.goal = 98;
        insertObj.identifier =rawNum;
        [[WCDBModuleManager WCDBMetaShareInstance]updateORMMetaForSqlWhere:rawNum withOrmObj:insertObj callBack:^(BOOL ret, NSError * _Nullable error) {
            if (ret) {
                rest[@"data"] =@(ret);
                [self finishWithValues:rest completed:YES];
            }else{
                rest[@"data"] =@(ret);
                [self failWithValues:rest completed:YES];
            }
        }];
    }
}
@end
