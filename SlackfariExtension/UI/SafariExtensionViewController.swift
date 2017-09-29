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

    var mainView: SafariExtensionView { return self.view as! SafariExtensionView }
    
    fileprivate var presenter: Presenter?
    fileprivate let disposeBag = DisposeBag()
    
    let constraintGroup = ConstraintGroup()
    
    var url: String? { didSet { mainView.messageField.stringValue = self.url! } }
    var channelDataProvider: ChannelTableViewDataProvider?
    var teamDataProvider: TeamCollectionViewDataProvider?
    
    lazy var addTeamView: AddTeamView = {
        let addTeam = AddTeamView()
        addTeam.delegate = self
        return addTeam
    }()
    
    override func loadView() {
        view = SafariExtensionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        configureTableView()
        configureCollectionView()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        guard let team = UserDefaults.standard.getTeam(), let token = team["token"] else { return }
        API.sharedInstance.set(token: token)
        presenter = Presenter()
        getAllChannels()
    }
    
    private func configureTableView() {
        channelDataProvider = ChannelTableViewDataProvider(tableView: mainView.tableView)
    }
    
    private func configureCollectionView() {
        teamDataProvider = TeamCollectionViewDataProvider(collectionView: mainView.collectionView)
        teamDataProvider?.delegate = self
        guard let teams = UserDefaults.standard.array(forKey: "teams") as? UserDefaultTeams else {
            return
        }
        teamDataProvider?.set(items: teams)
    }
    
    fileprivate func checkChannel(type: Channelable) -> MessageType {
        if type is ChannelViewModel {
            return .channel
        } else if type is GroupViewModel {
            return .group
        } else {
            return .user
        }
    }
    
    fileprivate func send(message: String, toChannel channel: String, withType type: MessageType) {
        presenter?.send(message: message, channel: channel, type: type).subscribe(onNext: { isSent in
            print("message sent")
        }, onError: { (error) in
            print("Error \(error)")
        }).disposed(by: disposeBag)
    }
    
    // MARK: Get team's information
    
    fileprivate func getAllChannels() {
        guard let presenter = presenter else { return }
        presenter.getUsers()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] users in
                guard let strongSelf = self else { return }
                strongSelf.buildUsersViewModel(users: users)
                strongSelf.mainView.tableView.reloadData()
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: disposeBag)
        
        presenter.getChannels()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] channels in
                guard let strongSelf = self else { return }
                strongSelf.buildChannelsViewModel(channels: channels)
                strongSelf.mainView.tableView.reloadData()
                }, onError: { error in
                    print("Error \(error)")
            }).disposed(by: disposeBag)
        
        presenter.getGroups()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] groups in
                guard let strongSelf = self else { return }
                strongSelf.buildGroupsViewModel(groups: groups)
                strongSelf.mainView.tableView.reloadData()
                }, onError: { error in
                    print("Error \( error)")
            }).disposed(by: disposeBag)
        
        presenter.getTeamInfo()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] team in
                guard let strongSelf = self else { return }
                strongSelf.mainView.teamNameLabel.stringValue = team.name ?? ""
                }, onError: { [weak self] error in
                    guard let strongSelf = self else { return }
                    strongSelf.mainView.teamNameLabel.stringValue = "Error"
                }, onCompleted: {
                    print("Completed")
            }).disposed(by: disposeBag)
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
                strongSelf.mainView.teamNameLabel.stringValue = teamName
                strongSelf.saveTeam(teamIcon: team.icon!, teamName: teamName, token: token)
                }, onError: { [weak self] error in
                    guard let strongSelf = self else { return }
                    print("Error \(error)")
                    API.sharedInstance.set(token: saveTemporalToken ?? "")
                    strongSelf.presenter = Presenter()
            }, onCompleted: {
                print("Completed")
            }).disposed(by: disposeBag)
    }
    
    private func saveTeam(teamIcon: String, teamName: String, token: String) {
        save(teamIcon: teamIcon, teamName: teamName, token: token) {
            teamDataProvider?.set(items: $0)
            mainView.collectionView.reloadData()
        }
    }
}

// MARK: - Build View Models

extension SafariExtensionViewController {
    fileprivate func buildUsersViewModel(users: [User]) {
        guard let dataProvider = channelDataProvider else { return }
        let usersViewModel: [Channelable] = users.flatMap(UserViewModel.init)
        dataProvider.add(items: usersViewModel)
    }
    
    fileprivate func buildChannelsViewModel(channels: [Channel]) {
        guard let dataProvider = channelDataProvider else { return }
        let channelsViewModel: [Channelable] = channels.flatMap(ChannelViewModel.init)
        dataProvider.add(items: channelsViewModel)
    }
    
    fileprivate func buildGroupsViewModel(groups: [Group]) {
        guard let dataProvider = channelDataProvider else { return }
        let groupsViewModel: [Channelable] = groups.flatMap(GroupViewModel.init)
        dataProvider.add(items: groupsViewModel)
    }
}

// MARK: - CollectionViewDataProviderDelegate

extension SafariExtensionViewController: TeamCollectionViewDataProviderDelegate {
    func didTapOnTeam(withToken token: String) {
        //  Clean channels
        guard let dataProvider = channelDataProvider else { return }
        dataProvider.removeItems()
        
        API.sharedInstance.set(token: token)
        presenter = Presenter()
        getAllChannels()
    }
}

extension SafariExtensionViewController: SafariExtensionViewDelegate {
    func didTapOnSendMessage() {
        guard !mainView.messageField.stringValue.isEmpty else { return }
        guard let selected = channelDataProvider?.getItem(at: mainView.tableView.selectedRow) else { return }
        let type = checkChannel(type: selected)
        send(message: mainView.messageField.stringValue, toChannel: selected.name, withType: type)
    }
    
    func didTapOnAddTeam() {
        showAddTeamView()
    }
}
