//
//  SBAccordionViewController.swift
//  Demo
//
//  Created by Simon Bromberg on 2015-08-08.
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headers.count + activeItemList.count
    }

    func getOptionIndexPathsForExpandedRow(offset: Int) -> [IndexPath] {
        if expandedRow == NotExpanded {
            return []
        }
        
        var indexPaths:[IndexPath] = []
        
        for i in 0..<headers[expandedRow].subItems.count {
            indexPaths += [IndexPath(row: expandedRow + i + 1 - offset, section: 0)]
        }
        
        return indexPaths
    }

    func rowInOptionList(_ row: Int) -> Bool {
        return row > expandedRow && row <= expandedRow + activeItemList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        tableView.beginUpdates()
        
        var removedRows = 0
        
        if expandedRow != NotExpanded {
            if rowInOptionList(row) {
                tableView.endUpdates()
                return
            }
            
            let indexPathsToRemove = getOptionIndexPathsForExpandedRow(offset: 0)
            tableView.deleteRows(at: indexPathsToRemove, with: .bottom)
            removedRows = indexPath.row < expandedRow ? 0 : indexPathsToRemove.count
        }
        
        if expandedRow == row {
            expandedRow = NotExpanded
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.endUpdates()
            return
        }
        
        expandedRow = row - removedRows
        tableView.insertRows(at: getOptionIndexPathsForExpandedRow(offset: 0), with: .top)
        
        tableView.endUpdates()
    }
    
    let headerIdentifier = "header"
    let optionIdentifier = "subItem"
    
    func identifierForIndexPath(_ indexPath: IndexPath) -> String {
        if expandedRow == NotExpanded || indexPath.row <= expandedRow || indexPath.row > expandedRow + activeItemList.count {
            return headerIdentifier
        }
        else  {
            return optionIdentifier
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = identifierForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)! as UITableViewCell
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
