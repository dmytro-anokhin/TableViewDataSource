//
//  ObjCTableViewProxy.h
//  TableViewDataSource
//
//  Created by Dmytro Anokhin on 21/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

@import UIKit;

@class TableViewSectionMapping;


NS_ASSUME_NONNULL_BEGIN


@interface ObjCTableViewProxy : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) TableViewSectionMapping *mapping;

+ (UITableView *)proxyWithTableView:(UITableView *)tableView mapping:(TableViewSectionMapping *)mapping;

- (instancetype)initWithTableView:(UITableView *)tableView mapping:(TableViewSectionMapping *)mapping;

@end


NS_ASSUME_NONNULL_END
