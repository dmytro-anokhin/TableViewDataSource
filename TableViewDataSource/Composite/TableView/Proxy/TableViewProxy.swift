//
//  TableViewProxy.swift
//  TableViewDataSource
//
//  Created by Dmytro Anokhin on 21/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit


final class TableViewProxy: ObjCTableViewProxy {

    // MARK: UITableView methods that work with sections or index paths

    @objc var numberOfSections: Int {
        return mapping.numberOfSections
    }

    @objc func numberOfRows(inSection section: Int) -> Int {
        guard let globalSection = mapping.globalSection(for: section) else { return 0 }
        return tableView.numberOfRows(inSection: globalSection)
    }

    @objc func rectForSection(_ section: Int) -> CGRect {
        guard let globalSection = mapping.globalSection(for: section) else { return CGRect.null }
        return tableView.rect(forSection: globalSection)
    }

    @objc func rectForHeaderInSection(_ section: Int) -> CGRect {
        guard let globalSection = mapping.globalSection(for: section) else { return CGRect.null }
        return tableView.rectForHeader(inSection: globalSection)
    }

    @objc func rectForFooterInSection(_ section: Int) -> CGRect {
        guard let globalSection = mapping.globalSection(for: section) else { return CGRect.null }
        return tableView.rectForFooter(inSection: globalSection)
    }

    @objc func rectForRowAtIndexPath(_ indexPath: IndexPath) -> CGRect {
        guard let globalIndexPath = mapping.globalIndexPath(for: indexPath) else { return CGRect.null }
        return tableView.rectForRow(at: globalIndexPath)
    }

    @objc func indexPathForRowAtPoint(_ point: CGPoint) -> IndexPath? {
        guard let globalIndexPath = tableView.indexPathForRow(at: point),
              let localIndexPath = mapping.localIndexPath(for: globalIndexPath) else { return nil }

        return localIndexPath
    }

    @objc func indexPathForCell(_ cell: UITableViewCell) -> IndexPath? {
        guard let globalIndexPath = tableView.indexPath(for: cell) else { return nil }
        return mapping.localIndexPath(for: globalIndexPath)
    }

    @objc func indexPathsForRowsInRect(_ rect: CGRect) -> [IndexPath]? {
        guard let globalIndexPaths = tableView.indexPathsForRows(in: rect) else { return nil }
        return mapping.localIndexPaths(for: globalIndexPaths)
    }

    @objc func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell? {
        guard let globalIndexPath = mapping.globalIndexPath(for: indexPath) else { return nil }
        return tableView.cellForRow(at: globalIndexPath)
    }

    @objc var indexPathsForVisibleRows: [IndexPath]? {
        guard let globalIndexPaths = tableView.indexPathsForVisibleRows else { return nil }
        return mapping.localIndexPaths(for: globalIndexPaths)
    }

    @objc func headerViewForSection(_ section: Int) -> UITableViewHeaderFooterView? {
        guard let globalSection = mapping.globalSection(for: section) else { return nil }
        return tableView.headerView(forSection: globalSection)
    }

    @objc func footerViewForSection(_ section: Int) -> UITableViewHeaderFooterView? {
        guard let globalSection = mapping.globalSection(for: section) else { return nil }
        return tableView.footerView(forSection: globalSection)
    }

    @objc func scrollToRowAtIndexPath(_ indexPath: IndexPath, atScrollPosition scrollPosition: UITableViewScrollPosition, animated: Bool) {
        guard let globalIndexPath = mapping.globalIndexPath(for: indexPath) else { return }
        tableView.scrollToRow(at: globalIndexPath, at: scrollPosition, animated: animated)
    }

    @objc func insertSections(_ sections: IndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        let globalSections = mapping.globalSections(for: sections)
        tableView.insertSections(globalSections, with: animation)
    }

    @objc func deleteSections(_ sections: IndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        let globalSections = mapping.globalSections(for: sections)
        tableView.deleteSections(globalSections, with: animation)
    }

    @objc func reloadSections(_ sections: IndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        let globalSections = mapping.globalSections(for: sections)
        tableView.reloadSections(globalSections, with: animation)
    }

    @objc func moveSection(_ section: Int, toSection newSection: Int) {
        if  let globalSection = mapping.globalSection(for: section),
            let globalNewSection = mapping.globalSection(for: newSection)
        {
            tableView.moveSection(globalSection, toSection: globalNewSection)
        }
    }

    @objc func insertRowsAtIndexPaths(_ indexPaths: [IndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        let globalIndexPaths = mapping.globalIndexPaths(for: indexPaths)
        tableView.insertRows(at: globalIndexPaths, with: animation)
    }

    @objc func deleteRowsAtIndexPaths(_ indexPaths: [IndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        let globalIndexPaths = mapping.globalIndexPaths(for: indexPaths)
        tableView.deleteRows(at: globalIndexPaths, with: animation)
    }

    @objc func reloadRowsAtIndexPaths(_ indexPaths: [IndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        let globalIndexPaths = mapping.globalIndexPaths(for: indexPaths)
        tableView.reloadRows(at: globalIndexPaths, with: animation)
    }

    @objc func moveRowAtIndexPath(_ indexPath: IndexPath, toIndexPath newIndexPath: IndexPath) {
        guard let globalIndexPath = mapping.globalIndexPath(for: indexPath),
              let globalNewIndexPath = mapping.globalIndexPath(for: newIndexPath) else { return }

        tableView.moveRow(at: globalIndexPath, to: globalNewIndexPath)
    }

    @objc var indexPathForSelectedRow: IndexPath? {
        guard let globalIndexPath = tableView.indexPathForSelectedRow else { return nil }
        return mapping.localIndexPath(for: globalIndexPath)
    }

    @objc var indexPathsForSelectedRows: [IndexPath]? {
        guard let globalIndexPaths = tableView.indexPathsForSelectedRows else { return nil }
        return mapping.localIndexPaths(for: globalIndexPaths)
    }

    @objc func selectRowAtIndexPath(_ indexPath: IndexPath?, animated: Bool, scrollPosition: UITableViewScrollPosition) {
        guard let localIndexPath = indexPath,
              let globalIndexPath = mapping.globalIndexPath(for: localIndexPath) else { return }
        tableView.selectRow(at: globalIndexPath, animated: animated, scrollPosition: scrollPosition)
    }

    @objc func deselectRowAtIndexPath(_ indexPath: IndexPath, animated: Bool) {
        guard let globalIndexPath = mapping.globalIndexPath(for: indexPath) else { return }
        tableView.deselectRow(at: globalIndexPath, animated: animated)
    }

    @objc func dequeueReusableCellWithIdentifier(_ identifier: String, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let globalIndexPath = mapping.globalIndexPath(for: indexPath) else { fatalError("Index path not found in mapping") }
        return tableView.dequeueReusableCell(withIdentifier: identifier, for: globalIndexPath)
    }

/*
    @objc func rect(forSection section: Int) -> CGRect {
        guard let globalSection = mapping.globalSection(for: section) else { return CGRect.null }
        return tableView.rect(forSection: globalSection)
    }

    @objc func rectForHeader(inSection section: Int) -> CGRect {
        guard let globalSection = mapping.globalSection(for: section) else { return CGRect.null }
        return tableView.rectForHeader(inSection: globalSection)
    }

    @objc func rectForFooter(inSection section: Int) -> CGRect {
        guard let globalSection = mapping.globalSection(for: section) else { return CGRect.null }
        return tableView.rectForFooter(inSection: globalSection)
    }

    @objc func rectForRow(at indexPath: IndexPath) -> CGRect {
        guard let globalIndexPath = mapping.globalIndexPath(for: indexPath) else { return CGRect.null }
        return tableView.rectForRow(at: globalIndexPath)
    }

    @objc func indexPathForRow(at point: CGPoint) -> IndexPath? {
        guard let globalIndexPath = tableView.indexPathForRow(at: point),
              let localIndexPath = mapping.localIndexPath(for: globalIndexPath) else { return nil }

        return localIndexPath
    }

    @objc func indexPath(for cell: UITableViewCell) -> IndexPath? {
        guard let globalIndexPath = tableView.indexPath(for: cell) else { return nil }
        return mapping.localIndexPath(for: globalIndexPath)
    }

    @objc func indexPathsForRows(in rect: CGRect) -> [IndexPath]? {
        guard let globalIndexPaths = tableView.indexPathsForRows(in: rect) else { return nil }
        return mapping.localIndexPaths(for: globalIndexPaths)
    }

    @objc func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        guard let globalIndexPath = mapping.globalIndexPath(for: indexPath) else { return nil }
        return tableView.cellForRow(at: globalIndexPath)
    }
*/
}
