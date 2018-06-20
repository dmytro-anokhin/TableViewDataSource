//
//  TableViewProxyTests.swift
//  TableViewDataSourceTests
//
//  Created by Dmytro Anokhin on 21/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import XCTest
@testable import TableViewDataSource


fileprivate class TestTableViewDataSource: TableViewDataSource {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = String(indexPath.row)

        return cell
    }
}


class TableViewProxyTests: XCTestCase {

    func testTableViewProxy() {
        let tableView = UITableView(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0), style: .plain)

        let dataSource = TestTableViewDataSource()
        tableView.dataSource = dataSource

        let mapping = TableViewSectionMapping(dataSource: dataSource)
        XCTAssertEqual(mapping.updateMappings(startingWith: 0), 1)

        let proxy = TableViewProxy.proxy(with: tableView, mapping: mapping)

        XCTAssertEqual(proxy.numberOfSections, 1)
        XCTAssertEqual(proxy.numberOfRows(inSection: 0), 2)

        XCTAssertEqual(proxy.rect(forSection: 0),
            CGRect(x: 0.0, y: 0.0, width: 375.0, height: 88.0))

        XCTAssertEqual(proxy.rectForRow(at: IndexPath(row: 0, section: 0)),
            CGRect(x: 0.0, y: 0.0, width: 375.0, height: 45.0))
        XCTAssertEqual(proxy.rectForRow(at: IndexPath(row: 1, section: 0)),
            CGRect(x: 0.0, y: 45.0, width: 375.0, height: 45.0))
    }
}
