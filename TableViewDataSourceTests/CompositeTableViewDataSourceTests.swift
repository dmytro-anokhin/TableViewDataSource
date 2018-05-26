//
//  CompositeTableViewDataSourceTests.swift
//  TableViewDataSourceTests
//
//  Created by Dmytro Anokhin on 22/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import XCTest
@testable import TableViewDataSource


fileprivate class TestTableViewDataSource: NSObject, TableViewDataSourceType {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]

        return cell
    }

    var numberOfSections: Int {
        return sections.count
    }

    let sections: [[String]]

    init(_ sections: [[String]]) {
        self.sections = sections
    }
}


class CompositeTableViewDataSourceTests: XCTestCase {

    func testCompositeTableViewDataSource() {
        // Structure representing data sources
        let structure = [
            // First data source
            [[
                "First data source, first section, first row",
                "First data source, first section, second row"
            ], [
                "First data source, second section, first row"
            ]],
            // Second data source
            [[
                "Second data source, first section, first row"
            ], [
            ], [
                "Second data source, third section, first row"
            ]]
        ]

        // Same structure flatten in 2 dimension array representing sections and rows in a table view
        let flatten = structure.reduce([], { $0 + $1 })

        let composite = CompositeTableViewDataSource(structure.map { TestTableViewDataSource($0) })

        let tableView = UITableView(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0), style: .plain)
        tableView.dataSource = composite

        XCTAssertEqual(tableView.numberOfSections, flatten.count)

        for (section, rows) in flatten.enumerated() {
            XCTAssertEqual(tableView.numberOfRows(inSection: section), rows.count)
        }
    }
}
