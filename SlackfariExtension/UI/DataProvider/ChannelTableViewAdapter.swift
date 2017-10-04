/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */

import Cocoa

class ChannelTableViewAdapter: NSObject {
    fileprivate static let column = "column"
    fileprivate static let heightOfRow: CGFloat = 26
    
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

extension ChannelTableViewAdapter: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard tableColumn?.identifier == ChannelTableViewAdapter.column else { fatalError("Channel Table View Data Provider identifier not found") }
        
        let name = items[row].name
        let view = NSTextField(string: name)
        view.isEditable = false
        view.isBordered = false
        view.backgroundColor = Stylesheet.color(.clear)
        return view
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return ChannelTableViewAdapter.heightOfRow
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
}
