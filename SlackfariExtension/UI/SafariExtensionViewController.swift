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
    var addTeamView = AddTeamView()
    
    var url: String? {
        didSet {
            mainView.messageField.stringValue = self.url!
        }
    }
    
    let constraintGroup = ConstraintGroup()
    
    fileprivate var presenter: SafariExtensionPresenter?
    fileprivate var channelDataProvider: ChannelTableViewDataProvider?
    fileprivate var teamDataProvider: TeamCollectionViewDataProvider?
    fileprivate let disposeBag = DisposeBag()
        
    // MARK: View Controller lifecycle
    
    override func loadView() {
        view = SafariExtensionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        addTeamView.delegate = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        configureView()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        guard let team = UserDefaults.standard.getTeam() else { return }
        setup(token: team.token)
        presenter?.getAllChannels()
    }
    
    // MARK: Configure Table View and Collection View providers
    
    private func configureView() {
        configureTableView()
        configureCollectionView()
    }
    
    private func configureTableView() {
        channelDataProvider = ChannelTableViewDataProvider(tableView: mainView.tableView)
    }
    
    private func configureCollectionView() {
        teamDataProvider = TeamCollectionViewDataProvider(collectionView: mainView.collectionView)
        teamDataProvider?.delegate = self
        guard let teams = UserDefaults.standard.getTeams() else { return }
        teamDataProvider?.set(items: teams)
    }
    
    fileprivate func setup(token: String) {
        API.sharedInstance.set(token: token)
        presenter = SafariExtensionPresenter()
        presenter?.delegate = self
    }
}

// MARK: - AddteamViewDelegate

extension SafariExtensionViewController: AddTeamViewDelegate {
    func didTapOnCloseButton() {
        addTeamView.removeFromSuperview()
    }
    
    func didTapOnAddTeamButton(teamName: String, token: String) {
        setup(token: token)
        presenter?.getTeamInfo(name: teamName, token: token)
    }
    
    private func saveTeam(name: String, token: String, icon: String) {
        save(name: name, token: token, icon: icon) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.teamDataProvider?.set(items: $0)
            strongSelf.addTeamView.removeFromSuperview()
            strongSelf.didTapOnTeam(withToken: token)
        }
    }
}

// MARK: - CollectionViewDataProviderDelegate

extension SafariExtensionViewController: TeamCollectionViewDataProviderDelegate {
    func didTapOnTeam(withToken token: String) {
        guard let dataProvider = channelDataProvider else { return }
        dataProvider.removeItems()
        setup(token: token)
        presenter?.getAllChannels()
    }
}

extension SafariExtensionViewController: SafariExtensionViewDelegate {
    func didTapOnSendMessage() {
        guard !mainView.messageField.stringValue.isEmpty else { return }
        guard let selected = channelDataProvider?.getItem(at: mainView.tableView.selectedRow) else { return }
        guard let type = presenter?.checkChannel(type: selected) else { return }
        presenter?.sendMessage(message: mainView.messageField.stringValue, toChannel: selected.name, withType: type)
    }
    
    func didTapOnAddTeam() {
        showAddTeamView()
    }
}

// MARK: - SafariExtensionPresenterDelegate

extension SafariExtensionViewController: SafariExtensionPresenterDelegate {
    func update(team: String) {
        mainView.teamNameLabel.stringValue = team
    }
    
    func update(notification: String) {
        mainView.notificationLabel.stringValue = notification
    }
    
    func build(viewModel: [Channelable]) {
        guard let dataProvider = channelDataProvider else { return }
        dataProvider.add(items: viewModel)
    }
    
    func didAddNewTeam(withToken token: String, items: [TeamModel]) {
        guard let teamDataProvider = teamDataProvider else { return }
        teamDataProvider.set(items: items)
        addTeamView.removeFromSuperview()
        didTapOnTeam(withToken: token)
    }
    
    func didUpdateTeam(withToken token: String) {
        setup(token: token)
    }
}
