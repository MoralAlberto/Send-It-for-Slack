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
    
    @IBOutlet weak var buttonSend: NSButton!
    
    var url: String?
    var dataProvider: TableViewDataProvider?
    
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
        dataProvider = TableViewDataProvider(tableView: tableView)
        tableView.rowSizeStyle = .large
        tableView.backgroundColor = NSColor.clear
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let post = url else { return }
        guard let selected = dataProvider?.getItem(at: tableView.selectedRow) else { return }
        let type = checkChannel(type: selected)
        send(message: post, toChannel: selected.name, withType: type)
    }
    
    private func getAllChannels() {
        Observable.combineLatest(presenter!.getUsers(), presenter!.getChannels(), presenter!.getGroups())
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (users, channels, groups) in
                guard let strongSelf = self else { return }
                strongSelf.buildViewModel(users: users, channels: channels, groups: groups)
                strongSelf.tableView.reloadData()
                }, onError: { error in
                    print("Error \(error)")
            }
        ).disposed(by: disposeBag)
    }
    
    private func buildViewModel(users: [User], channels: [Channel], groups: [Group]) {
        guard let dataProvider = dataProvider else { return }
        let usersViewModel: [Channelable] = users.flatMap(UserViewModel.init)
        let channelsViewModel: [Channelable] = channels.flatMap(ChannelViewModel.init)
        let groupsViewModel: [Channelable] = groups.flatMap(GroupViewModel.init)
        dataProvider.set(items: usersViewModel + channelsViewModel + groupsViewModel)
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
