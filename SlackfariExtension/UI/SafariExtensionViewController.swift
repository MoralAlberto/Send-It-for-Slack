//
//  Presenter.swift
//  Slackfari
//
//  Created by Alberto Moral on 16/08/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared = SafariExtensionViewController()

    @IBOutlet weak var tableView: NSTableView!
    
    let presenter = Presenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = nil
        tableView.dataSource = self
        tableView.rowSizeStyle = .large
        tableView.backgroundColor = NSColor.clear
    }
}

extension SafariExtensionViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellIdentifier: String = ""
        
        if tableColumn == tableView.tableColumns[0] {
            cellIdentifier = "NameCellID"
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = "Hola"
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 80
    }
}
