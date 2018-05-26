//
//  CompositeTableViewDataSource.swift
//  TableViewDataSource
//
//  Created by Dmytro Anokhin on 21/05/2018.
//  Copyright © 2018 Dmytro Anokhin. All rights reserved.
//

import UIKit


public class CompositeTableViewDataSource: NSObject, TableViewDataSourceType {

    public convenience init(_ dataSources: [TableViewDataSourceType]) {
        self.init()

        for dataSource in dataSources {
            add(dataSource, animation: .none)
        }
    }

    /// Add data source to the composite with animation
    public func add(_ dataSource: TableViewDataSourceType, animation: UITableViewRowAnimation) {
        assert(Thread.isMainThread, "This routine must be executed on the main thread")

        guard composition.add(dataSource) else {
            return
        }

        dataSource.parent = self

        if let tableView = tableView {
            dataSource.registerReusableViews(with: tableView)
        }

        _numberOfSections = composition.updateMappings()

        let sections = composition.sections(for: dataSource)
        tableView?.insertSections(sections, with: animation)
    }

    /// Remove data source from the composite with animation
    public func remove(_ dataSource: TableViewDataSourceType, animation: UITableViewRowAnimation) {
        assert(Thread.isMainThread, "This routine must be executed on the main thread")

        let sections = composition.sections(for: dataSource)

        guard composition.remove(dataSource) else {
            return
        }

        dataSource.parent = nil

        _numberOfSections = composition.updateMappings()

        tableView?.deleteSections(sections, with: animation)
    }

    /// List of data sources in the composite
    public var dataSources: [TableViewDataSourceType] {
        return children as? [TableViewDataSourceType] ?? []
    }

    // MARK: - Composable

    public weak var parent: CompositeType?

    // MARK: - TableViewDataSourceType

    public var numberOfSections: Int {
        _numberOfSections = composition.updateMappings()
        return _numberOfSections
    }

    public func configure(with tableView: UITableView) {
        _tableView = tableView

        tableView.dataSource = self
        tableView.delegate = self

        registerReusableViews(with: tableView)
    }

    public func registerReusableViews(with tableView: UITableView) {
        for dataSource in dataSources {
            dataSource.registerReusableViews(with: tableView)
        }
    }

    public var tableView: UITableView? {
        if let _tableView = self._tableView {
            return _tableView
        }

        return (parent as? TableViewDataSourceCompositeType)?.tableView(for: self)
    }

    // MARK: - Private

    private let composition = TableViewDataSourceComposition()

    private var _numberOfSections: Int = 0

    private weak var _tableView: UITableView?
}


// MARK: - CompositeType
extension CompositeTableViewDataSource: CompositeType {

    public func add(_ child: Composable) {
        guard let dataSource = child as? TableViewDataSourceType else {
            assertionFailure("\(type(of: self)) expects \(type(of: TableViewDataSourceType.self)), but got \(type(of: child))")
            return
        }

        add(dataSource, animation: .none)
    }

    public func remove(_ child: Composable) {
        guard let dataSource = child as? TableViewDataSourceType else {
            assertionFailure("\(type(of: self)) expects \(type(of: TableViewDataSourceType.self)), but got \(type(of: child))")
            return
        }

        remove(dataSource, animation: .none)
    }

    public var children: [Composable] {
        return composition.children
    }
}


// MARK: - TableViewDataSourceCompositeType
extension CompositeTableViewDataSource: TableViewDataSourceCompositeType {

    func tableView(for dataSource: TableViewDataSourceType) -> UITableView? {
        guard let tableView = self.tableView else {
            return nil
        }
        
        let mapping = composition.mapping(for: dataSource)
        return TableViewProxy.proxy(with: tableView, mapping: mapping)
    }
}


// MARK: - UITableViewDataSource
extension CompositeTableViewDataSource: UITableViewDataSource {

    // Required

    final public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        _numberOfSections = composition.updateMappings()
        let local = composition.local(for: section, in: tableView)
        return local.dataSource.tableView(local.proxy, numberOfRowsInSection: local.section)
    }

    final public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let local = composition.local(for: indexPath, in: tableView)
        return local.dataSource.tableView(local.proxy, cellForRowAt: local.indexPath)
    }

    // Optional

    final public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    final public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let local = composition.local(for: section, in: tableView)
        return local.dataSource.tableView?(local.proxy, titleForHeaderInSection: local.section)
    }

    final public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let local = composition.local(for: section, in: tableView)
        return local.dataSource.tableView?(local.proxy, titleForFooterInSection: local.section)
    }

    // Editing

    final public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let local = composition.local(for: indexPath, in: tableView)
        return local.dataSource.tableView?(local.proxy, canEditRowAt: local.indexPath) ?? false
    }

    // Moving/reordering

    final public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let local = composition.local(for: indexPath, in: tableView)
        return local.dataSource.tableView?(local.proxy, canMoveRowAt: local.indexPath) ?? false
    }
/*
    // Index

    @available(iOS 2.0, *)
    optional public func sectionIndexTitles(for tableView: UITableView) -> [String]? // return list of section titles to display in section index view (e.g. "ABCD...Z#")

    @available(iOS 2.0, *)
    optional public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int // tell table which section corresponds to section title/index (e.g. "B",1))
*/

    // Data manipulation - insert and delete support

    final public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let local = composition.local(for: indexPath, in: tableView)
        local.dataSource.tableView?(local.proxy, commit: editingStyle, forRowAt: local.indexPath)
    }

    // Data manipulation - reorder / moving support

    final public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        assertionFailure("Reorder / moving not supported")
    }
}


// MARK: - UITableViewDelegate
extension CompositeTableViewDataSource: UITableViewDelegate {

    // Display customization

    final public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let local = composition.local(for: indexPath, in: tableView)
        local.dataSource.tableView?(local.proxy, willDisplay: cell, forRowAt: local.indexPath)
    }

    final public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let local = composition.local(for: section, in: tableView)
        local.dataSource.tableView?(local.proxy, willDisplayHeaderView: view, forSection: local.section)
    }

    final public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let local = composition.local(for: section, in: tableView)
        local.dataSource.tableView?(local.proxy, willDisplayFooterView: view, forSection: local.section)
    }

    final public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let local = composition.local(for: indexPath, in: tableView)
        local.dataSource.tableView?(local.proxy, didEndDisplaying: cell, forRowAt: local.indexPath)
    }

    final public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        let local = composition.local(for: section, in: tableView)
        local.dataSource.tableView?(local.proxy, didEndDisplayingHeaderView: view, forSection: local.section)
    }

    final public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        let local = composition.local(for: section, in: tableView)
        local.dataSource.tableView?(local.proxy, didEndDisplayingFooterView: view, forSection: local.section)
    }

    // Variable height support

    final public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let local = composition.local(for: indexPath, in: tableView)
        return local.dataSource.tableView?(local.proxy, heightForRowAt: local.indexPath) ?? tableView.rowHeight
    }

    final public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let local = composition.local(for: section, in: tableView)
        return local.dataSource.tableView?(local.proxy, heightForHeaderInSection: local.section) ?? tableView.sectionHeaderHeight
    }

    final public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let local = composition.local(for: section, in: tableView)
        return local.dataSource.tableView?(local.proxy, heightForFooterInSection: local.section) ?? tableView.sectionFooterHeight
    }

    final public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let local = composition.local(for: indexPath, in: tableView)
        return local.dataSource.tableView?(local.proxy, estimatedHeightForRowAt: local.indexPath) ?? tableView.estimatedRowHeight
    }

    final public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let local = composition.local(for: section, in: tableView)
        return local.dataSource.tableView?(local.proxy, estimatedHeightForHeaderInSection: local.section) ?? tableView.estimatedSectionHeaderHeight
    }

    final public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let local = composition.local(for: section, in: tableView)
        return local.dataSource.tableView?(local.proxy, estimatedHeightForFooterInSection: local.section) ?? tableView.estimatedSectionFooterHeight
    }

    // Section header & footer information. Views are preferred over title should you decide to provide both

    final public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let local = composition.local(for: section, in: tableView)
        return local.dataSource.tableView?(local.proxy, viewForHeaderInSection: local.section)
    }

    final public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let local = composition.local(for: section, in: tableView)
        return local.dataSource.tableView?(local.proxy, viewForFooterInSection: local.section)
    }

    final public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let local = composition.local(for: indexPath, in: tableView)
        local.dataSource.tableView?(local.proxy, accessoryButtonTappedForRowWith: local.indexPath)
    }

/*
    // Selection

    // -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
    // Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
    @available(iOS 6.0, *)
    optional public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool

    @available(iOS 6.0, *)
    optional public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)

    @available(iOS 6.0, *)
    optional public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)


    // Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
    @available(iOS 2.0, *)
    optional public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?

    @available(iOS 3.0, *)
    optional public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?

    // Called after the user changes the selection.
    @available(iOS 2.0, *)
    optional public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)

    @available(iOS 3.0, *)
    optional public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)


    // Editing

    // Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
    @available(iOS 2.0, *)
    optional public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle

    @available(iOS 3.0, *)
    optional public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?


    // Use -tableView:trailingSwipeActionsConfigurationForRowAtIndexPath: instead of this method, which will be deprecated in a future release.
    // This method supersedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
    @available(iOS 8.0, *)
    optional public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?


    // Swipe actions
    // These methods supersede -editActionsForRowAtIndexPath: if implemented
    // return nil to get the default swipe actions
    @available(iOS 11.0, *)
    optional public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?

    @available(iOS 11.0, *)
    optional public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?


    // Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
    @available(iOS 2.0, *)
    optional public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool


    // The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
    @available(iOS 2.0, *)
    optional public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)

    @available(iOS 2.0, *)
    optional public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)


    // Moving/reordering

    // Allows customization of the target row for a particular row as it is being moved/reordered
    @available(iOS 2.0, *)
    optional public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath


    // Indentation

    @available(iOS 2.0, *)
    optional public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int // return 'depth' of row for hierarchies


    // Copy/Paste.  All three methods must be implemented by the delegate.

    @available(iOS 5.0, *)
    optional public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool

    @available(iOS 5.0, *)
    optional public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool

    @available(iOS 5.0, *)
    optional public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)


    // Focus

    @available(iOS 9.0, *)
    optional public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool

    @available(iOS 9.0, *)
    optional public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool

    @available(iOS 9.0, *)
    optional public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)

    @available(iOS 9.0, *)
    optional public func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?


    // Spring Loading

    // Allows opting-out of spring loading for an particular row.
    // If you want the interaction effect on a different subview of the spring loaded cell, modify the context.targetView property. The default is the cell.
    // If this method is not implemented, the default is YES except when the row is part of a drag session.
    @available(iOS 11.0, *)
    optional public func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool
}
*/
}
