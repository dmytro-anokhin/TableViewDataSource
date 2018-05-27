//
//  ViewController.swift
//  AppleHistory
//
//  Created by Dmytro Anokhin on 27/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit
import TableViewDataSource


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let dataSource = CompositeTableViewDataSource([
        IMacDataSource(), MacOSDataSource()
    ])

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.configure(with: tableView)
    }
}
