//
//  YBMSwiftHandler.h
//  YBModelFileDemo
//
//  Created by iMac on 2022/8/18.
//  Copyright © 2022 杨波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBMFNode.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YBMSwiftHandler <NSObject>

/** 方法之间是否空行 */
@property (nonatomic, assign) BOOL ybmf_skipLine;

- (NSString *)ybmf_codeInfoWithNode:(YBMFNode *)node;

@end


@interface YBMSwiftHandler : NSObject<YBMSwiftHandler>

@end

NS_ASSUME_NONNULL_END
