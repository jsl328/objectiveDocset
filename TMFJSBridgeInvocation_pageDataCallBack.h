//
//  TMFJSBridgeInvocation_pageDataCallBack.h
//  PCDBank
//
//  Created by jiangsl on 2019/11/14.
//  Copyright © 2021 jiangsl. All rights reserved.
//

#import "TMFJSBridgeInvocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMFJSBridgeInvocation_pageDataCallBack : TMFJSBridgeInvocation
-(void)callbackWithIdentifier:(id)identifier values:(NSDictionary *)values;
@end

NS_ASSUME_NONNULL_END
