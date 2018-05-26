//
//  TableViewDataSourceType.swift
//  TableViewDataSource
//
//  Created by Dmytro Anokhin on 21/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//


/// The TableViewDataSourceType is a base type for UITableView data sources
public protocol TableViewDataSourceType: UITableViewDataSource, UITableViewDelegate, Composable {

    /// Number of sections in the data source
    var numberOfSections: Int { get }

    /// Performs initial configuration. Call this method after view loaded.
    func configure(with tableView: UITableView)

    /// Register cell, header, and footer views with a table view
    func registerReusableViews(with tableView: UITableView)

    /// The table view of a data source.
    var tableView: UITableView? { get }
}


open class TableViewDataSource: NSObject, TableViewDataSourceType {

    // MARK: UITableViewDataSource

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError("\(type(of: self)) must override \(#function)")
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("\(type(of: self)) must override \(#function)")
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    // MARK: UITableViewDelegate

    // MARK: Composite

    public weak var parent: CompositeType?

    // MARK: TableViewDataSourceType

    open var numberOfSections: Int {
        return 1
    }

    public func configure(with tableView: UITableView) {
        _tableView = tableView

        tableView.dataSource = self
        tableView.delegate = self

        registerReusableViews(with: tableView)
    }

    open func registerReusableViews(with tableView: UITableView) {
    }

    public var tableView: UITableView? {
        if let _tableView = self._tableView {
            return _tableView
        }

        return (parent as? TableViewDataSourceCompositeType)?.tableView(for: self)
    }

    // MARK: Private

    private weak var _tableView: UITableView?
}
