/*!
@header 打开相机相册-openCameraOrAlbum
@abstract 打开相机相册
@author jiangsl
@version 5.0.0
*/

#import "TMFJSBridgeInvocation_openCameraOrAlbum.h"
//#import "PCDSystemAuthManager.h"
#import "TMFJSBridgeInvocation+Protected.h"
#import "BOBBaseAppGlobalDefines.h"
#import "BOBBaseMediaManager.h"
#import "TMFJSBridgeWKWebViewController.h"
#import "PHAssetUtil.h"
#import "BOBBasePermissionManager.h"
#import "BOBMessageHandle.h"

@interface TMFJSBridgeInvocation_openCameraOrAlbum()<RootViewControllerProtocol>
/*!
@method
@abstract 方法名：openCameraOrAlbum
@param phonsNum 多张照片时选择的数量
@param type Photo:相册;Camera:相机;CameraPhoto:相册和相机;
@param morePhoto 是否支持多张照片选择:Y-多张;N-单张
@param compress 是否压缩: Y-压缩(注：300k以上压缩，300k以内不压缩) N-不压缩
@result 输出参数
@textblock
<apiXmpBegin>
status 回调状态
callbackData 图片
 --sourceImg:原图
 --thumbImg:压缩后的图片
<apiXmpEnd>
@/textblock
@discussion 用法：
@textblock
<apiXmpBegin>
function tmf_openCameraOrAlbum() {
    TMFJSBridge.invoke('openCameraOrAlbum', {
        "type": "CameraPhoto", //Photo：相册；Camera：相机；CameraPhoto：相册和相机；
        "morePhoto": "Y", //是否支持多张照片选择；Y：多张；N：单张
        "phonsNum": "5", //多张照片时选择的数量（注：超过数量提示不可选择）
        "compress": "Y" //是否压缩； Y:压缩（注：300k以上压缩，300k以内不压缩） N：不压缩
    }, function(res) {
        tmf_alert(JSON.stringify(res.sourceImg));
    });
}
<apiXmpEnd>
@/textblock
*/
- (void)openCameraOrAlbum;
@end

@implementation TMFJSBridgeInvocation_openCameraOrAlbum

- (void)invokeWithParameters:(NSDictionary *)parameters {
    
    NSDictionary *value = MQQDictionaryValue(parameters, nil);
    if (!value) {
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"15" suffix:@"06"] completed:YES];
        return;
    }
    
    //初始化相册选择器
    [BOBBaseMediaManager sharedInstance].delegate = self;
    
    NSString *type = parameters[@"type"];
    self.photosNum = [parameters[@"phonsNum"] intValue]; //相册张数
    NSString *strCompress = parameters[@"compress"];  //是否压缩
    if ([strCompress isEqualToString:@"Y"]) {
        self.isPressPhoto = YES;
    } else {
        self.isPressPhoto = NO;
    }
    
    UIImagePickerControllerSourceType tmpType = -1;
    if ([type isEqualToString:@"Photo"]) {
        tmpType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if ([type isEqualToString:@"CameraPhoto"]) {
        //手动选择拍照还是相册
        [self dealPhotoCameraWithData:parameters];
        return;
    } else if ([type isEqualToString:@"Camera"]) {
        //拍照
        tmpType = UIImagePickerControllerSourceTypeCamera;
    } else {
        [self dealPhotoCameraWithData:parameters];
    }
    [self addPicEvent:parameters type:tmpType responseBlock: ^(id responseData ,NSError *error) {
        
    }];
}

- (void)dealPhotoCameraWithData:(id)data {
    NSDictionary *parma = (NSDictionary *)data;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertCamera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击相机");
        [self addPicEvent:parma
                     type:UIImagePickerControllerSourceTypeCamera
            responseBlock: ^(id responseData ,NSError *error){}];
    }];
    UIAlertAction *alertPhonto = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击相册");
        [self addPicEvent:parma
                     type:UIImagePickerControllerSourceTypePhotoLibrary
            responseBlock: ^(id responseData , NSError *error) {}];
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
        [self.rooterVC dismissViewControllerAnimated:YES completion:NULL];
    }];
    [actionSheet addAction:alertCamera];
    [actionSheet addAction:alertPhonto];
    [actionSheet addAction:alertCancel];
    UIViewController *rootVC =[[[UIApplication sharedApplication] delegate] window].rootViewController;
    if (rootVC) {
        [rootVC presentViewController:actionSheet animated:YES completion:nil];
    }
}

- (void) addPicEvent:(NSDictionary *)parma
                type:(UIImagePickerControllerSourceType)picType
       responseBlock:(void(^)(id responseData ,NSError *error))responseCallback {
    if (picType == UIImagePickerControllerSourceTypePhotoLibrary) {  //相册使用可以选择单张，多张的
        [self showPhotosAlbumForMorePhotos:parma];
    }else if (picType ==UIImagePickerControllerSourceTypeCamera){
        //拍照
        [self systemCaptureImage:parma];
    }
}
//拍照
-(void)systemCaptureImage:(NSDictionary *)parma{
    if (![BOBBasePermissionManager deviceHasCameraPermission]) {
        //没有相机权限
        [self finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"15" suffix:@"01"] completed:YES];
        return;
    }
    @PCDWeakSelf(self);
    NSMutableDictionary *options = [[NSMutableDictionary alloc] initWithDictionary:parma];
    options[@"cameraType"] = @"image";
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BOBBaseMediaManager sharedInstance].camera captureImage:options compelte:^(UIImage * _Nonnull image, NSURL * _Nonnull vedioUrl, id  _Nonnull reusltDetail) {
            if (image == nil && vedioUrl == nil && reusltDetail == nil) {
                //[selfWeak failWithValues:@{@"status":@"1",@"message":@"拍照失败"} completed:YES];
                [selfWeak finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"15" suffix:@"00"] completed:YES];
            }else{
                if ([[options objectForKey: @"cameraType"] isEqualToString:@"video"]) {
                    //录制视频
                }else{
                    //拍照
                    NSArray *aessets =@[@{@"metaData":UIImageJPEGRepresentation(image, 1.0)}];
                    [self imagesCompress:aessets];
                }
            }
        } errorCall:^(NSError *error) {
            if (error) {
//                [selfWeak failWithValues:@{@"status":@"1",@"message":error.description} completed:YES];
                [selfWeak finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"15" suffix:@"00"] completed:YES];
            }
        }];
    });
}

#pragma mark - 多相册选取
- (void)showPhotosAlbumForMorePhotos:(NSDictionary *)options {
    @PCDWeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![BOBBasePermissionManager deviceHasPhotoPermission]) {
            //没有相册权限
            [selfWeak finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"15" suffix:@"01"] completed:YES];
            return;
        }
        //；Y：多张；N：单张
        if ([options[@"morePhoto"] isEqualToString:@"N"]) {
            //单张
            //[YXMediaManager sharedInstance].gallery.mediaType = bridgeObject.reqData[@"options"][@"filter"];
            [BOBBaseMediaManager sharedInstance].gallery.mediaType = @"image";
            [BOBBaseMediaManager sharedInstance].gallery.maximum = 1;

            [[BOBBaseMediaManager sharedInstance].gallery singlePickPHAsset:^(BOOL hasChoose, PHAsset *asset) {
                [PHAssetUtil handleAsset:asset options:options complete:^(NSDictionary * _Nonnull fileObj) {
                    if (fileObj != nil) {
                        //图片的源数据
                        NSArray *aessts = @[fileObj];
                        [self imagesCompress:aessts];
                    }
                }];
            } error:^(NSError *error) {
                if (error) {
//                    [selfWeak failWithValues:@{@"status":@"1",@"message":error.description} completed:YES];
                    [selfWeak finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"15" suffix:@"00"] completed:YES];
                }
            }];
        }else{
            //多张,如果大于6张直接返回
            if ([options[@"phonsNum"]intValue] >6) {
                return;
            }
            [BOBBaseMediaManager sharedInstance].gallery.mediaType = @"image";
            [BOBBaseMediaManager sharedInstance].gallery.maximum = [options[@"phonsNum"] intValue];
            [[BOBBaseMediaManager sharedInstance].gallery pickPHAsset:^(BOOL hasChoose, NSArray<PHAsset *> *assets) {
                [PHAssetUtil handleAssets:assets options:options complete:^(NSArray * _Nonnull fileObjs) {
                    if (fileObjs != nil&& fileObjs.count>0) {
                        [self imagesCompress:fileObjs];
                    }else{
                        NSLog(@"没有选择图片");
                    }
                }];
            } error:^(NSError *error) {
                if (error) {
//                    [selfWeak failWithValues:@{@"status":@"1",@"message":error.description} completed:YES];
                    [selfWeak finishWithValues:[BOBMessageHandle failCoverageFuncMessageHandlePrefix:@"15" suffix:@"00"] completed:YES];
                }
            }];
        }
    });
}
//批量图片压缩
-(void)imagesCompress:(NSArray *)assets{
    NSMutableArray *calls =[[NSMutableArray alloc]init];
    @PCDWeakSelf(self);
    for (NSDictionary *imageFile in assets) {
        //图片的源
        NSData *imageOrigin =imageFile[@"metaData"];
        UIImage *imageMeta = [UIImage imageWithData:imageOrigin];
        if (imageOrigin) {
            //先按照规定大小裁切一次(100,100)
            UIImage *imageThumb = [self reSizeImage:imageMeta toSize:CGSizeMake(100, 100)];
            if (self.isPressPhoto) {
                if (imageOrigin.length>300*1024) {  //300kb以内不压缩
                    CGSize size = CGSizeMake(400, 400*imageMeta.size.height/imageMeta.size.width); //大小
                    NSDictionary *compressedDic= [selfWeak imageCompress:imageMeta ratio:1.0 size:size isCompress:YES];
                    [calls addObject:compressedDic];
                } else {
                    NSDictionary *compressedDic=[selfWeak imageCompress:imageThumb ratio:.5 size:CGSizeZero isCompress:NO];
                    [calls addObject:compressedDic];
                }
            }else{
                NSDictionary *compressedDic=[selfWeak imageCompress:imageMeta ratio:1.0 size:CGSizeZero isCompress:NO];
                [calls addObject:compressedDic];
            }
        }else{
            NSDictionary *compressedDic=[selfWeak imageCompress:imageMeta ratio:1.0 size:CGSizeZero isCompress:NO];
            [calls addObject:compressedDic];
        }
    }
    if (calls&&calls.count == assets.count) {
        //NSDictionary * dicCallBack = @{@"callbackData":calls,@"status":@"0",@"message":@"success"};
        [self finishWithValues:[BOBMessageHandle successMessageHandle:calls] completed:YES];
//        [self finishWithValues:dicCallBack completed:YES];
        [BOBBaseMediaManager sharedInstance].delegate = nil;//释放代理对象
    }
}
//图片jpeg压缩，不支持png压缩
-(NSDictionary *)imageCompress:(UIImage *)orginImage  ratio:(float)ratio size:(CGSize)size isCompress:(BOOL)press{
    UIImage *preImageOrigin =nil;
    NSData *imageData =nil;
    NSData *imageThumbData =nil;
    if (press) {
        preImageOrigin = [self reSizeImage:orginImage toSize:size];
    }else{
        preImageOrigin =orginImage;
    }
    if (preImageOrigin) {
        //源数据按照压缩系数压缩
        imageData =UIImageJPEGRepresentation(orginImage, ratio);
        //对(100,100)大小的数据做压缩系数的压缩
        imageThumbData =UIImageJPEGRepresentation(preImageOrigin,ratio);
    }
    NSDictionary *dic = @{@"sourceImg":[imageData base64EncodedStringWithOptions:0],@"thumbImg":[imageThumbData base64EncodedStringWithOptions:0]};
    return  dic;
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

//图片大小等比压缩
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)openCameraOrAlbum{
    
}
- (UIViewController *)rooterVC {
    return self.webViewController;
}

@end
