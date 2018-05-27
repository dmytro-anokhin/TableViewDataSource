//
//  MacOSDataSource.swift
//  AppleHistory
//
//  Created by Dmytro Anokhin on 27/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit
import TableViewDataSource


class MacOSDataSource: TableViewDataSource {

    let generations = [
        [ "Kodiak" ],
        [ "Cheetah", "Puma", "Jaguar", "Panther", "Tiger", "Leopard", "Snow Leopard", "Lion", "Mountain Lion" ],
        [ "Mavericks", "Yosemite", "El Capitan", "Sierra", "High Sierra"]
    ]

    override var numberOfSections: Int {
        return generations.count
    }

    override func registerReusableViews(with tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generations[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = generations[indexPath.section][indexPath.row]

        return cell
    }
}
