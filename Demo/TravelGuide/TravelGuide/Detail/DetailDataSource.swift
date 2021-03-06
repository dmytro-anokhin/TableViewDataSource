//
//  DetailDataSource.swift
//  TravelGuide
//
//  Created by Dmytro Anokhin on 25/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit
import TableViewDataSource


class DetailDataSource: TableViewDataSource {

    private enum Row {

        case welcome

        case shortText

        case fullText

        case more
    }

    let model: Model

    init(model: Model) {
        self.model = model
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]

        switch row {
            case .welcome:
                let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCell", for: indexPath) as! LabelCell
                cell.label.text = model.detail.title

                return cell

            case .shortText:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! LabelCell
                cell.label.text = model.detail.shortText

                return cell

            case .fullText:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! LabelCell
                cell.label.text = model.detail.fullText

                return cell

            case .more:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as! ButtonCell
                cell.button.setTitle(rows.contains(.fullText) ? "Read Less" : "Read More...", for: .normal)
                cell.button.addTarget(self, action: #selector(moreActionHandler), for: .touchUpInside)

                return cell
        }
    }

    // MARK: Private

    @objc
    private func moreActionHandler() {
        guard let moreIndex = rows.index(of: .more) else {
            return
        }

        tableView?.beginUpdates()
        tableView?.reloadRows(at: [ IndexPath(row: moreIndex, section: 0) ], with: .none)

        if let index = rows.index(of: .fullText) { // Delete
            rows.remove(at: index)
            tableView?.deleteRows(at: [ IndexPath(row: index, section: 0) ], with: .fade)
        }
        else { // Insert
            rows.insert(.fullText, at: moreIndex)
            tableView?.insertRows(at: [ IndexPath(row: moreIndex, section: 0) ], with: .fade)
        }

        tableView?.endUpdates()
    }

    private var rows: [Row] = [ .welcome, .shortText, .more ]
}
