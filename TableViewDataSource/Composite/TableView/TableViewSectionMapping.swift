//
//  TableViewSectionMapping.swift
//  TableViewDataSource
//
//  Created by Dmytro Anokhin on 21/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//


/// The `TableViewSectionMapping` maps global sections of a table view to local sections of a data source (and vice versa).
final class TableViewSectionMapping {

    /// The data source associated with this mapping
    let dataSource: TableViewDataSourceType

    init(dataSource: TableViewDataSourceType) {
        self.dataSource = dataSource
    }

    /// The number of sections in this mapping
    public private(set) var numberOfSections: Int = 0

    /// Return the local section for a global section
    func localSection(for globalSection: Int) -> Int? {
        return globalToLocalSections[globalSection]
    }

    /// Return a set of local sections from a set of global sections
    func localSections(for globalSections: IndexSet) -> IndexSet {
        return IndexSet(globalSections.compactMap { localSection(for: $0) })
    }

    /// Return the global section for a local section
    func globalSection(for localSection: Int) -> Int? {
        guard let globalSection = localToGlobalSections[localSection] else {
            assertionFailure("localSection \(localSection) not found in localToGlobalSections: \(localToGlobalSections)")
            return nil
        }

        return globalSection
    }

    /// Return a set of global sections from a set of local sections
    func globalSections(for localSections: IndexSet) -> IndexSet {
        return IndexSet(localSections.compactMap { globalSection(for: $0) })
    }
    /// Return a local index path for a global index path
    func localIndexPath(for globalIndexPath: IndexPath) -> IndexPath? {
        guard let section = localSection(for: globalIndexPath.section) else { return nil }
        return IndexPath(row: globalIndexPath.row, section: section)
    }

    /// Return a global index path for a local index path
    func globalIndexPath(for localIndexPath: IndexPath) -> IndexPath? {
        guard let section = globalSection(for: localIndexPath.section) else { return nil }
        return IndexPath(row: localIndexPath.row, section: section)
    }

    /// Return an array of local index paths from an array of global index paths
    func localIndexPaths(for globalIndexPaths: [IndexPath]) -> [IndexPath] {
        return globalIndexPaths.compactMap { return self.localIndexPath(for: $0) }
    }

    /// Return an array of global index paths from an array of local index paths
    func globalIndexPaths(for localIndexPaths: [IndexPath]) -> [IndexPath] {
        return localIndexPaths.compactMap { return self.globalIndexPath(for: $0) }
    }

    /// Update the mapping of local sections to global sections
    func updateMappings(startingWith globalSection: Int) -> Int {
        var globalSection = globalSection

        numberOfSections = dataSource.numberOfSections
        globalToLocalSections.removeAll()
        localToGlobalSections.removeAll()

        if 0 == numberOfSections {
            return globalSection
        }

        for localSection in 0...numberOfSections - 1 {
            addMapping(fromGlobalSection: globalSection, toLocalSection: localSection)
            globalSection += 1
        }

        return globalSection
    }

    // MARK: Private

    private func addMapping(fromGlobalSection globalSection: Int, toLocalSection localSection: Int) {
        assert(nil == localToGlobalSections[localSection], "collision while trying to add to a mapping")
        globalToLocalSections[globalSection] = localSection
        localToGlobalSections[localSection] = globalSection
    }

    private var globalToLocalSections: [Int:Int] = [:]
    private var localToGlobalSections: [Int:Int] = [:]
}


extension TableViewSectionMapping: Equatable {

    static public func ==(lhs: TableViewSectionMapping, rhs: TableViewSectionMapping) -> Bool {
        return lhs.dataSource === rhs.dataSource
            && lhs.globalToLocalSections == rhs.globalToLocalSections
            && lhs.localToGlobalSections == rhs.localToGlobalSections
    }
}
