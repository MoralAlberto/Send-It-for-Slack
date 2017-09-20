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
import Cartography

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared = SafariExtensionViewController()

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    fileprivate var presenter: Presenter?
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet weak var addTeamButton: NSButton!
    @IBOutlet weak var buttonSend: NSButton!
    
    let group = ConstraintGroup()
    
    var url: String?
    var dataProvider: ChannelTableViewDataProvider?
    var teamDataProvider: TeamCollectionViewDataProvider?
    
    lazy var addTeamView: AddTeamView = {
        let addTeam = AddTeamView()
        addTeam.delegate = self
        return addTeam
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserDefaults.standard.removeObject(forKey: "teams")
        
        API.sharedInstance.set(token: "xoxp-220728744260-221560162310-226472479939-023594ef326c368b601646bec84b64b0")
        configureTableView()
        configureCollectionView()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        presenter = Presenter()
        getAllChannels()
    }
    
    private func configureTableView() {
        dataProvider = ChannelTableViewDataProvider(tableView: tableView)
        tableView.rowSizeStyle = .large
        tableView.backgroundColor = NSColor.clear
    }
    
    private func configureCollectionView() {
        teamDataProvider = TeamCollectionViewDataProvider(collectionView: collectionView)
        teamDataProvider?.delegate = self
        guard let teams = UserDefaults.standard.array(forKey: "teams") as? [[String: String]] else {
            return
        }
        teamDataProvider?.set(items: teams)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let post = url else { return }
        guard let selected = dataProvider?.getItem(at: tableView.selectedRow) else { return }
        let type = checkChannel(type: selected)
        send(message: post, toChannel: selected.name, withType: type)
    }
    
    fileprivate func getAllChannels() {
        guard let presenter = presenter else { return }
        presenter.getUsers()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] users in
                guard let strongSelf = self else { return }
                strongSelf.buildUsersViewModel(users: users)
                strongSelf.tableView.reloadData()
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: disposeBag)
        
        presenter.getChannels()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] channels in
                guard let strongSelf = self else { return }
                strongSelf.buildChannelsViewModel(channels: channels)
                strongSelf.tableView.reloadData()
                }, onError: { error in
                    print("Error \(error)")
            }).disposed(by: disposeBag)
        
        presenter.getGroups()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] groups in
                guard let strongSelf = self else { return }
                strongSelf.buildGroupsViewModel(groups: groups)
                strongSelf.tableView.reloadData()
                }, onError: { error in
                    print("Error \( error)")
            }).disposed(by: disposeBag)
    }
    
    private func buildUsersViewModel(users: [User]) {
        guard let dataProvider = dataProvider else { return }
        let usersViewModel: [Channelable] = users.flatMap(UserViewModel.init)
        dataProvider.add(items: usersViewModel)
    }
    
    private func buildChannelsViewModel(channels: [Channel]) {
        guard let dataProvider = dataProvider else { return }
        let channelsViewModel: [Channelable] = channels.flatMap(ChannelViewModel.init)
        dataProvider.add(items: channelsViewModel)
    }
    
    private func buildGroupsViewModel(groups: [Group]) {
        guard let dataProvider = dataProvider else { return }
        let groupsViewModel: [Channelable] = groups.flatMap(GroupViewModel.init)
        dataProvider.add(items: groupsViewModel)
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
    
    @IBAction func addTeam(_ sender: NSButton) {
        view.addSubview(addTeamView)
        
        constrain(addTeamView, replace: group) { addTeamView in
            addTeamView.leading == addTeamView.superview!.leading
            addTeamView.trailing == addTeamView.superview!.trailing
            addTeamView.bottom == addTeamView.superview!.bottom
            addTeamView.height == 0
        }
        
        NSAnimationContext.runAnimationGroup({ context in
            constrain(addTeamView, replace: group) { addTeamView in
                context.duration = 1
                context.allowsImplicitAnimation = true
                
                addTeamView.leading == addTeamView.superview!.leading
                addTeamView.trailing == addTeamView.superview!.trailing
                addTeamView.bottom == addTeamView.superview!.bottom
                addTeamView.height == 140
            }
        }, completionHandler: nil)
    }
}

// MARK: - AddteamViewDelegate

extension SafariExtensionViewController: AddTeamViewDelegate {
    func didTapOnCloseButton() {
        addTeamView.removeFromSuperview()
    }
    
    func didTapOnAddTeamButton(teamName: String, token: String) {
        
        let saveTemporalToken = API.sharedInstance.getToken()
        API.sharedInstance.set(token: token)
        presenter = Presenter()
        
        presenter?.getTeamInfo()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] team in
                guard let strongSelf = self else { return }
                strongSelf.saveTeam(teamIcon: team.icon!, teamName: teamName, token: token)
                }, onError: { (error) in
                    print("Error \(error)")
                    API.sharedInstance.set(token: saveTemporalToken ?? "")
            }, onCompleted: {
                print("Completed")
            }).disposed(by: disposeBag)
    }
    
    private func saveTeam(teamIcon: String, teamName: String, token: String) {
        save(teamIcon: teamIcon, teamName: teamName, token: token) {
            teamDataProvider?.set(items: $0)
            collectionView.reloadData()
        }
    }
}

// MARK: - CollectionViewDataProviderDelegate

extension SafariExtensionViewController: TeamCollectionViewDataProviderDelegate {
    func didTapOnTeam(withToken token: String) {
        //  Clean channels
        guard let dataProvider = dataProvider else { return }
        dataProvider.removeItems()
        
        API.sharedInstance.set(token: token)
        presenter = Presenter()
        getAllChannels()
    }
}
