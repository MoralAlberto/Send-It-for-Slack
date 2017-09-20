//
//  TableViewDataProvider.swift
//  Slackfari
//
//  Created by Alberto Moral on 21/08/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation
import Cocoa

class ChannelTableViewDataProvider: NSObject {
    
    fileprivate var items: [Channelable] = [Channelable]()
    private var tableView: NSTableView
    
    init(tableView: NSTableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func getItem(at index: Int) -> Channelable? {
        guard index <= items.count else { return nil }
        return items[index]
    }
    
    func add(items: [Channelable]) {
        self.items += items
    }
    
    func removeItems() {
        items.removeAll()
    }
}

extension ChannelTableViewDataProvider: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellIdentifier = "NameCellID"
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView {
            let item = items[row]
            let name = item.name
            cell.textField?.stringValue = name
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 26
    }
}
