//
//  TableViewDataSourceCompositeType.swift
//  TableViewDataSource
//
//  Created by Dmytro Anokhin on 26/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit


protocol TableViewDataSourceCompositeType: CompositeType {

    func tableView(for dataSource: TableViewDataSourceType) -> UITableView?
}
