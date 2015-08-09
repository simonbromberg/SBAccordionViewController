//
//  SBAccordionViewController.swift
//  Demo
//
//  Created by shim on 2015-08-08.
//  Copyright (c) 2015 Bupkis. All rights reserved.
//

import UIKit
let NotExpanded = -1
class SBAccordionHeader {
    var header: String!
    var subItems: [String]!
    init (header: String, subItems: [String]) {
        self.header = header
        self.subItems = subItems
    }
    convenience init (header: String, subItems: String...) {
        self.init(header: header, subItems: subItems)
    }
}
class SBAccordionViewController: UITableViewController {
    var headers: [SBAccordionHeader]!
    var expandedRow = NotExpanded
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var activeItemList: [String] {
        get {
            return expandedRow == NotExpanded ? [] : headers[expandedRow].subItems
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headers.count + activeItemList.count
    }
    func getOptionIndexPathsForExpandedRow(#offset: Int) -> [NSIndexPath] {
        if expandedRow == NotExpanded {
            return []
        }
        var indexPaths:[NSIndexPath] = []
        for (i,o) in enumerate(headers[expandedRow].subItems) {
            indexPaths += [NSIndexPath(forRow: expandedRow + i + 1 - offset, inSection: 0)]
        }
        return indexPaths
    }
    func rowInOptionList(row: Int) -> Bool {
        return row > expandedRow && row <= expandedRow + activeItemList.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var indexPaths:[NSIndexPath] = []
        let row = indexPath.row
        tableView.beginUpdates()
        var removedRows = 0
        if expandedRow != NotExpanded {
            if rowInOptionList(row) {
                tableView.endUpdates()
                return
            }
            let indexPathsToRemove = getOptionIndexPathsForExpandedRow(offset: 0)
            tableView.deleteRowsAtIndexPaths(indexPathsToRemove, withRowAnimation: UITableViewRowAnimation.Bottom)
            removedRows = indexPath.row < expandedRow ? 0 : indexPathsToRemove.count
        }
        if expandedRow == row {
            expandedRow = NotExpanded
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.endUpdates()
            return
        }
        expandedRow = row - removedRows
        tableView.insertRowsAtIndexPaths(getOptionIndexPathsForExpandedRow(offset: 0), withRowAnimation: UITableViewRowAnimation.Top)
        
        tableView.endUpdates()
    }
    let headerIdentifier = "header"
    let optionIdentifier = "subItem"
    
    func identifierForIndexPath(indexPath: NSIndexPath) -> String {
        if expandedRow == NotExpanded || indexPath.row <= expandedRow || indexPath.row > expandedRow + activeItemList.count {
            return headerIdentifier
        }
        else  {
            return optionIdentifier
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = identifierForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
        let row = indexPath.row
        if identifier == headerIdentifier {
            let countAbove = row > expandedRow ? activeItemList.count : 0
            cell.textLabel!.text = headers[row - countAbove].header
        }
        else {
            cell.textLabel!.text = activeItemList[row - expandedRow - 1]
        }
        return cell
    }
}
