
/*!
@header 保存图片到相册-savePhoto
@abstract  保存图片到相册 savePhoto
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_savePhoto.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "BOBMessageHandle.h"
#import <JKCategories/NSData+JKBase64.h>

/*!
@method
@abstract 方法名：savePhoto
@param ImgBase64String 输入参数图片base64字符串
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
message 回调信息
callbackData  存储成功返回"success"字符串
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
 function savePhoto(){
     TMFJSBridge.invoke('savePhoto',{
         ImgBase64String:'data:image/jpeg;base64,/9j/4AAQSkZ'
     }, function(res) {
         tmf_alert(JSON.stringify(res));
     });
 }
<apiXmpEnd>
@/textblock
*/

@implementation TMFJSBridgeInvocation_savePhoto

- (void)invokeWithParameters:(NSDictionary *)parameters
{
    NSDictionary *value =MQQDictionaryValue(parameters, nil);
    NSString *imgBase64String =value[@"ImgBase64String"];
    if (!value||!imgBase64String||[imgBase64String isEqualToString:@""]) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"16" suffix:@"06"] completed:YES];
        return;
    }
    NSData *ima = [NSData jk_dataWithBase64EncodedString:imgBase64String];
    if (!ima) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"16" suffix:@"00"] completed:YES];
        return;
    }
    UIImage *imgOrigin = [[UIImage alloc]initWithData:ima];
    UIImageWriteToSavedPhotosAlbum(imgOrigin, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
//参数1:图片对象
//参数2:成功方法绑定的target
//参数3:成功后调用方法
//参数4:需要传递信息(成功后调用方法的参数)
#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(!error){
        //msg = @"保存图片成功";
//        NSMutableDictionary *values = [NSMutableDictionary dictionary];
//        [@"saveSuccess":yes];
        [self finishWithValues:[BOBMessageHandle successMessageHandle:@"success"] completed:YES];
    }else{
        //msg = @"保存图片失败" ;
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"16" suffix:@"02"] completed:YES];
    }
}

@end
