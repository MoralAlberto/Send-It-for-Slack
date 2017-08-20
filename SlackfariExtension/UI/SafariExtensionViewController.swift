//
//  Presenter.swift
//  Slackfari
//
//  Created by Alberto Moral on 16/08/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import SafariServices
import SlackWebAPIKit
import RxSwift

class SafariExtensionViewController: SFSafariExtensionViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    static let shared = SafariExtensionViewController()

    @IBOutlet weak var tableView: NSTableView!
    
    var presenter: Presenter?
    let disposeBag = DisposeBag()
    
    var items = [Channel]()
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        API.sharedInstance.set(token: "")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowSizeStyle = .large
        tableView.backgroundColor = NSColor.clear
        
        presenter = Presenter()
        presenter?.getChannels()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] channels in
            guard let strongSelf = self else { return }
            strongSelf.items = channels
            strongSelf.tableView.reloadData()
            print("Channels \(channels)")
        }, onError: { error in
            print("Error \(error)")
        }).addDisposableTo(disposeBag)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let selected = items[tableView.selectedRow]
        presenter?.send(message: url ?? "", channel: selected.name ?? "").subscribe(onNext: { isSent in
            print("message sent")
        }, onError: { (error) in
            print("Error \(error)")
        }).disposed(by: disposeBag)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellIdentifier = "NameCellID"
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView {
            let item = items[row]
            let name = item.name
            cell.textField?.stringValue = name ?? "No name"
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 26
    }
}
