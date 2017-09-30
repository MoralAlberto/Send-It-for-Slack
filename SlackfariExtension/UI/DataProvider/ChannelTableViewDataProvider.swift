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
    static let column = "column"
    static let heightOfRow: CGFloat = 26
    
    fileprivate var items: [Channelable] = [Channelable]() {
        didSet {
            tableView.reloadData()
        }
    }
    
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

extension ChannelTableViewDataProvider: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard tableColumn?.identifier == ChannelTableViewDataProvider.column else { fatalError() }

        let item = items[row]
        let name = item.name
        
        let view = NSTextField(string: name)
        view.isEditable = false
        view.isBordered = false
        view.backgroundColor = Stylesheet.color(.clear)
        return view
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return ChannelTableViewDataProvider.heightOfRow
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
}
