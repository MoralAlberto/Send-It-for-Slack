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

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared = SafariExtensionViewController()

    @IBOutlet weak var tableView: NSTableView!
    
    fileprivate var presenter: Presenter?
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var items = [Channelable]()
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        API.sharedInstance.set(token: "")
        configureTableView()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        presenter = Presenter()
        getAllChannels()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowSizeStyle = .large
        tableView.backgroundColor = NSColor.clear
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let selected = items[tableView.selectedRow]
        guard let post = url else { return }
        let type = checkChannel(type: selected)
        send(message: post, toChannel: selected.name, withType: type)
    }
    
    private func getAllChannels() {
        Observable.combineLatest(presenter!.getUsers(), presenter!.getChannels(), presenter!.getGroups())
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (users, channels, groups) in
                guard let strongSelf = self else { return }
                let usersViewModel: [Channelable] = users.map(UserViewModel.init)
                let channelsViewModel: [Channelable] = channels.map(ChannelViewModel.init)
                let groupsViewModel: [Channelable] = groups.map(GroupViewModel.init)
                
                strongSelf.items = usersViewModel + channelsViewModel + groupsViewModel
                strongSelf.tableView.reloadData()
                }, onError: { error in
                    print("Error \(error)")
            }
        ).disposed(by: disposeBag)
    }
    
    private func checkChannel(type: Channelable) -> MessageType {
        if type is ChannelViewModel {
            return .channel
        } else if type is GroupViewModel {
            return .group
        } else {
            return .user
        }
    }
    
    private func send(message: String, toChannel channel: String, withType type: MessageType) {
        presenter?.send(message: message, channel: channel, type: type).subscribe(onNext: { isSent in
            print("message sent")
        }, onError: { (error) in
            print("Error \(error)")
        }).disposed(by: disposeBag)
    }
}

extension SafariExtensionViewController: NSTableViewDataSource, NSTableViewDelegate {
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
