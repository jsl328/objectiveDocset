//
//  TMFJSBridgeInvocation_openCameraOrAlbum.h
//  PCDBank
//
//  Created by jiangsl on 2019/11/27.
//  Copyright © 2019 jiangsl. All rights reserved.
//  相机，相册jsApi插件

//#import "TMFJSBridgeInvocationBase.h"
//#import "TZImagePickerController.h"
#import "TMFJSBridgeInvocation.h"
NS_ASSUME_NONNULL_BEGIN

@interface TMFJSBridgeInvocation_openCameraOrAlbum : TMFJSBridgeInvocation

//@property(nonatomic,assign)BOOL isMorePhoto;
@property(nonatomic,assign)BOOL isPressPhoto;
@property(nonatomic,assign)int photosNum;

@end

NS_ASSUME_NONNULL_END
