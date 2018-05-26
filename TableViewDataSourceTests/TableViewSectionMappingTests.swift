//
//  TableViewSectionMappingTests.swift
//  TableViewDataSourceTests
//
//  Created by Dmytro Anokhin on 21/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import XCTest
@testable import TableViewDataSource


fileprivate class TestTableViewDataSource: NSObject, TableViewDataSourceType {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Not implemented")
    }

    var numberOfSections: Int = 0
}


class TableViewSectionMappingTests: XCTestCase {
    
    func testMapping() {
        let dataSource = TestTableViewDataSource()
        dataSource.numberOfSections = 2

        let mapping = TableViewSectionMapping(dataSource: dataSource)
        XCTAssertEqual(mapping.updateMappings(startingWith: 1), 3)

        XCTAssertEqual(mapping.localSections(for: IndexSet(integersIn: 1...2)), IndexSet(integersIn: 0...1))
        XCTAssertEqual(mapping.globalSections(for: IndexSet(integersIn: 0...1)), IndexSet(integersIn: 1...2))

        XCTAssertEqual(mapping.localIndexPaths(for: [ IndexPath(row: 0, section: 1), IndexPath(row: 0, section: 2) ]),
            [ IndexPath(row: 0, section: 0), IndexPath(row: 0, section: 1) ])
        XCTAssertEqual(mapping.globalIndexPaths(for: [ IndexPath(row: 0, section: 0), IndexPath(row: 0, section: 1) ]),
            [ IndexPath(row: 0, section: 1), IndexPath(row: 0, section: 2) ])
    }
}
