//
//  YBMSwiftHandler.m
//  YBModelFileDemo
//
//  Created by iMac on 2022/8/18.
//  Copyright © 2022 杨波. All rights reserved.
//

#import "YBMSwiftHandler.h"
#import "NSObject+YBMFConfig.h"

@implementation YBMSwiftHandler

NSString *indent = @"    ";
typedef NSString * (^MethodImplementationBlock)(NSString *);
@synthesize ybmf_skipLine = _ybmf_skipLine;

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ybmf_skipLine = NO;
    }
    return self;
}

#pragma mark - <YBMSwiftHandler>
- (void)mergePropertyMapperCode:(NSMutableString *)codeInfo node:(YBMFNode * _Nonnull)node {
    switch (self.ybmf_config.framework) {
        case YBMFFrameworkYY: {
            [codeInfo appendString:indent];
            [codeInfo appendString:@"override class func modelCustomPropertyMapper() -> [String : Any]? {\n"];
            break;
        }
        default: break;
    }
    
    // 方法返回值开始括号
    [codeInfo appendString:indent];
    [codeInfo appendString:indent];
    [codeInfo appendString:@"return [\n"];

    [node.propertyMapper enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [codeInfo appendString:indent];
        [codeInfo appendString:indent];
        [codeInfo appendString:indent];
        [codeInfo appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",\n", key, obj]];
    }];
    
    // 方法返回值末尾括号
    [codeInfo appendString:indent];
    [codeInfo appendString:indent];
    [codeInfo appendString:@"]\n"];
    
    [codeInfo appendString:indent];
    [codeInfo appendString:@"}\n"];
    if (self.ybmf_skipLine) [codeInfo appendString:@"\n"];
}

- (void)mergeContainerGenericCode:(NSMutableString *)codeInfo node:(YBMFNode * _Nonnull)node {
    switch (self.ybmf_config.framework) {
        case YBMFFrameworkYY: {
            [codeInfo appendString:indent];
            [codeInfo appendString:@"override class func modelContainerPropertyGenericClass() -> [String : Any]? {\n"];
            break;
        }
        default: break;
    }
    
    // 方法返回值开始括号
    [codeInfo appendString:indent];
    [codeInfo appendString:indent];
    [codeInfo appendString:@"return [\n"];
    [node.containerMapper enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [codeInfo appendString:indent];
        [codeInfo appendString:indent];
        [codeInfo appendString:indent];
        [codeInfo appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",\n", key, obj]];
    }];
    
    // 方法返回值末尾括号
    [codeInfo appendString:indent];
    [codeInfo appendString:indent];
    [codeInfo appendString:@"]\n"];
    
    // 方法末尾括号
    [codeInfo appendString:indent];
    [codeInfo appendString:@"}\n"];
    if (self.ybmf_skipLine) [codeInfo appendString:@"\n"];
}

/// 方法重载实现
- (NSString * _Nonnull)ybmf_implementationCodeInfoWithNode:(YBMFNode * _Nonnull)node {
    NSMutableString *codeInfo = [NSMutableString string];
    
    //实现属性映射
    if (node.propertyMapper.count > 0) {
        [self mergePropertyMapperCode:codeInfo node:node];
    }
    
    //实现容器元素映射
    if (node.containerMapper.count > 0) {
        [self mergeContainerGenericCode:codeInfo node:node];
    }
    
    [codeInfo appendString:@"}\n"];
    return codeInfo;
}

/// 属性声明
- (NSString * _Nonnull)ybmf_declarationCodeInfoWithNode:(YBMFNode * _Nonnull)node {
    NSMutableString *codeInfo = [NSMutableString string];
    
    // 类名
    [codeInfo appendString:[NSString stringWithFormat:@"@objcMembers class %@ : %@ {\n", node.className, NSStringFromClass(self.ybmf_config.baseClass)]];
    
    if (self.ybmf_skipLine) [codeInfo appendString:@"\n"];
    
    // 属性
    [node.children enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, YBMFNode * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *codeForParent;
        codeForParent = [self.ybmf_config.codeForParentHandler ybmf_swiftCodeForParentWithNode:obj propertyName:key];
        [codeInfo appendString:indent];
        [codeInfo appendString:codeForParent];
        [codeInfo appendString:@"\n"];
        if (self.ybmf_skipLine) [codeInfo appendString:@"\n"];
    }];
    
    return codeInfo;
}

- (NSString *)ybmf_codeInfoWithNode:(YBMFNode *)node {
    return [NSString stringWithFormat:@"%@\n%@", [self ybmf_declarationCodeInfoWithNode:node], [self ybmf_implementationCodeInfoWithNode:node]];
}

@end
