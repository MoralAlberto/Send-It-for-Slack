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
    var dataProvider: TableViewDataProvider?
    var teamDataProvider: CollectionViewDataProvider?
    
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
        dataProvider = TableViewDataProvider(tableView: tableView)
        tableView.rowSizeStyle = .large
        tableView.backgroundColor = NSColor.clear
    }
    
    private func configureCollectionView() {
        teamDataProvider = CollectionViewDataProvider(collectionView: collectionView)
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
        Observable.combineLatest(presenter.getUsers(), presenter.getChannels())
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (users, channels) in
                guard let strongSelf = self else { return }
                Swift.print("Receive channels \(channels)")
                strongSelf.buildViewModel(users: users, channels: channels)
                strongSelf.tableView.reloadData()
                }, onError: { error in
                    print("Error \(error)")
            }
        ).disposed(by: disposeBag)
    }
    
    private func buildViewModel(users: [User], channels: [Channel]) {
        guard let dataProvider = dataProvider else { return }
        let usersViewModel: [Channelable] = users.flatMap(UserViewModel.init)
        let channelsViewModel: [Channelable] = channels.flatMap(ChannelViewModel.init)
        dataProvider.set(items: usersViewModel + channelsViewModel)
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

extension SafariExtensionViewController: AddTeamViewDelegate {
    func didTapOnCloseButton() {
        addTeamView.removeFromSuperview()
    }
    
    func didTapOnAddTeamButton(teamName: String, token: String) {
        let saveTemporalToken = API.sharedInstance.getToken()
        API.sharedInstance.set(token: token)
        presenter = Presenter()
        
        presenter?.getTeamInfo().subscribe(onNext: { [weak self](team) in
            guard let strongSelf = self else { return }
            strongSelf.save(team: team, name: teamName, token: token)
            }, onError: { (error) in
                print("Error \(error)")
                API.sharedInstance.set(token: saveTemporalToken ?? "")
        }, onCompleted: {
            print("Completed")
        }).disposed(by: disposeBag)
        
    }
    
    private func save(team: Team, name: String, token: String) {
        guard var teams = UserDefaults.standard.array(forKey: "teams") as? [[String: String]] else {
            UserDefaults.standard.set([["name": name, "token": token, "image": team.icon!]], forKey: "teams")
            UserDefaults.standard.synchronize()
            collectionView.reloadData()
            return
        }
        
        if !arrayContains(array: teams, key: "name", value: name) {
            teams.append(["name": name, "token": token, "image": team.icon!])
            UserDefaults.standard.set(teams, forKey: "teams")
            UserDefaults.standard.synchronize()
        }
        teamDataProvider?.set(items: teams)
        collectionView.reloadData()
    }
}

extension SafariExtensionViewController: CollectionViewDataProviderDelegate {
    
    func didTapOnTeam(withToken token: String) {
        Swift.print("Get channels with token \(token)")
        API.sharedInstance.set(token: token)
        presenter = Presenter()
        getAllChannels()
    }
}
