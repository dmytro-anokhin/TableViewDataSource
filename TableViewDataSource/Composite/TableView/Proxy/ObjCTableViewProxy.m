//
//  ObjCTableViewProxy.m
//  TableViewDataSource
//
//  Created by Dmytro Anokhin on 21/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

#import "ObjCTableViewProxy.h"

@import ObjectiveC.runtime;


@implementation ObjCTableViewProxy

+ (UITableView *)proxyWithTableView:(UITableView *)tableView mapping:(TableViewSectionMapping *)mapping
{
    return [[self alloc] initWithTableView:tableView mapping:mapping];
}

- (instancetype)initWithTableView:(UITableView *)tableView mapping:(TableViewSectionMapping *)mapping
{
    self = [super init];
    if (nil == self)
        return nil;

    _tableView = tableView;
    _mapping = mapping;

    return self;
}

#pragma mark - Forwarding

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return _tableView;
}

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super instanceMethodSignatureForSelector:selector];
    if (signature)
        return signature;

    return [UITableView instanceMethodSignatureForSelector:selector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (signature)
        return signature;
    else
        return [[self forwardingTargetForSelector:selector] methodSignatureForSelector:selector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL responds = [super respondsToSelector:aSelector];
    if (!responds)
        responds = [[self forwardingTargetForSelector:aSelector] respondsToSelector:aSelector];
    return responds;
}

+ (BOOL)instancesRespondToSelector:(SEL)selector
{
    if (!selector)
        return NO;

    if (class_respondsToSelector(self, selector))
        return YES;

    return [UITableView instancesRespondToSelector:selector];
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return [_tableView valueForKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [_tableView setValue:value forKey:key];
}

@end
