/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */


import SlackWebAPIKit
import RxSwift

enum MessageType {
    case user
    case group
    case channel
}

protocol SafariExtensionPresenterDelegate: class {
    func update(team: String)
    func update(notification: String)
    func build(viewModel: [Channelable])
    func didAddNewTeam(withToken token: String, items: [TeamModel])
    func didUpdateTeam(withToken token: String)
}

class SafariExtensionPresenter {
    weak var delegate: SafariExtensionPresenterDelegate?
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let getChannelsUseCase: ChannelsListUseCaseProtocol
    fileprivate let getUsersUseCase: UsersListUseCaseProtocol
    fileprivate let getGroupsUseCase: GroupsListUseCaseProtocol
    
    fileprivate let postChannelMessage: FindChannelAndPostMessageUseCaseProtocol
    fileprivate let postUserMessage: FindUserAndPostMessageUseCaseProtocol
    fileprivate let postPrivateChannelMessage: FindGroupAndPostMessageUseCaseProtocol
    
    fileprivate let teamInfoUseCase: TeamInfoUseCaseProtocol
    
    init(getChannelsUseCase: ChannelsListUseCaseProtocol = ChannelsListUseCase(),
         getUsersUseCase: UsersListUseCaseProtocol = UsersListUseCase(),
         getPrivateChannelsUseCase: GroupsListUseCaseProtocol = GroupsListUseCase(),
         postChannelMessage: FindChannelAndPostMessageUseCaseProtocol = FindChannelAndPostMessageUseCase(),
         postUserMessage: FindUserAndPostMessageUseCaseProtocol = FindUserAndPostMessageUseCase(),
         postPrivateChannelMessage: FindGroupAndPostMessageUseCaseProtocol = FindGroupAndPostMessageUseCase(),
         teamInfoUseCase: TeamInfoUseCaseProtocol = TeamInfoUseCase()) {
        self.getChannelsUseCase = getChannelsUseCase
        self.getUsersUseCase = getUsersUseCase
        self.getGroupsUseCase = getPrivateChannelsUseCase
        self.postChannelMessage = postChannelMessage
        self.postUserMessage = postUserMessage
        self.postPrivateChannelMessage = postPrivateChannelMessage
        self.teamInfoUseCase = teamInfoUseCase
    }
    
    func getChannels() -> Observable<[Channel]> {
        return getChannelsUseCase.execute()
    }
    
    func getUsers() -> Observable<[User]> {
        return getUsersUseCase.execute()
    }
    
    func getGroups() -> Observable<[Group]> {
        return getGroupsUseCase.execute()
    }
    
    func send(message: String, channel: String, type: MessageType) -> Observable<Bool> {
        switch type {
        case .user:
            return postUserMessage.execute(text: message, user: channel)
        case .channel:
            return postChannelMessage.execute(text: message, channel: channel)
        case .group:
            return postPrivateChannelMessage.execute(text: message, group: channel)
        }
    }
    
    func getTeamInfo() -> Observable<Team> {
        return teamInfoUseCase.execute()
    }
    
    func getAllChannels() {
        getUsers()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] users in
                guard let strongSelf = self else { return }
                strongSelf.buildUsersViewModel(users: users)
                }, onError: { error in
                    print("Error \(error)")
            }).disposed(by: disposeBag)
        
        getChannels()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] channels in
                guard let strongSelf = self else { return }
                strongSelf.buildChannelsViewModel(channels: channels)
                }, onError: { error in
                    print("Error \(error)")
            }).disposed(by: disposeBag)
        
        getGroups()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] groups in
                guard let strongSelf = self else { return }
                strongSelf.buildGroupsViewModel(groups: groups)
                }, onError: { error in
                    print("Error \( error)")
            }).disposed(by: disposeBag)
        
        getTeamInfo()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] team in
                guard let strongSelf = self else { return }
                guard let name = team.name else { return }
                strongSelf.delegate?.update(team: name)
                }, onError: { [weak self] error in
                    guard let strongSelf = self else { return }
                    strongSelf.delegate?.update(team: "Error")
                }, onCompleted: {
                    print("Completed")
            }).disposed(by: disposeBag)
    }
    
    // MARK: Send Message
    
    func checkChannel(type: Channelable) -> MessageType {
        if type is ChannelViewModel {
            return .channel
        } else if type is GroupViewModel {
            return .group
        } else {
            return .user
        }
    }
    
    func sendMessage(message: String, toChannel channel: String, withType type: MessageType) {
        send(message: message, channel: channel, type: type)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isSent in
                guard let strongSelf = self else { return }
                strongSelf.delegate?.update(notification: "Last message sent to: \(channel)")
                }, onError: { [weak self] error in
                    guard let strongSelf = self else { return }
                    strongSelf.delegate?.update(notification: "Error trying to send the message")
            }).disposed(by: disposeBag)
    }
    
    // MARK: Get Team Info
    
    func getTeamInfo(name: String, token: String) {
        let saveTemporalToken = API.sharedInstance.getToken()
        
        getTeamInfo()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] team in
                guard let strongSelf = self else { return }
                guard let icon = team.icon else { return }
                strongSelf.delegate?.update(team: name)
                strongSelf.saveTeam(name: name, token: token, icon: icon)
                }, onError: { [weak self] error in
                    guard let strongSelf = self else { return }
                    guard let token = saveTemporalToken else { return }
                    strongSelf.delegate?.didUpdateTeam(withToken: token)
                }, onCompleted: {
                    print("Completed")
            }).disposed(by: disposeBag)
    }
    
    private func saveTeam(name: String, token: String, icon: String) {
        save(name: name, token: token, icon: icon) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didAddNewTeam(withToken: token, items: $0)
        }
    }
}

// MARK: - Build View Models

extension SafariExtensionPresenter {
    fileprivate func buildUsersViewModel(users: [User]) {
        let usersViewModel: [Channelable] = users.flatMap(UserViewModel.init)
        print("Users \(usersViewModel.count)")
        delegate?.build(viewModel: usersViewModel)
    }
    
    fileprivate func buildChannelsViewModel(channels: [Channel]) {
        let channelsViewModel: [Channelable] = channels.flatMap(ChannelViewModel.init)
        print("Channels \(channelsViewModel.count)")
        delegate?.build(viewModel: channelsViewModel)
    }
    
    fileprivate func buildGroupsViewModel(groups: [Group]) {
        let groupsViewModel: [Channelable] = groups.flatMap(GroupViewModel.init)
        print("Groups \(groupsViewModel.count)")
        delegate?.build(viewModel: groupsViewModel)
    }
}
