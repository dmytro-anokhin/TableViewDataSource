//
//  IMacDataSource.swift
//  AppleHistory
//
//  Created by Dmytro Anokhin on 27/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit
import TableViewDataSource


class IMacDataSource: TableViewDataSource {

    let names = [ "iMac G3", "iMac G4", "iMac G5", "iMac" ]

    override func registerReusableViews(with tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]

        return cell
    }
}
