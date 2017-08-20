//
//  Presenter.swift
//  Slackfari
//
//  Created by Alberto Moral on 16/08/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation
import SlackWebAPIKit
import RxSwift

enum MessageType {
    case user
    case group
    case channel
}

class Presenter {
    
    fileprivate let getChannelsUseCase: ChannelsListUseCaseProtocol
    fileprivate let getUsersUseCase: UsersListUseCaseProtocol
    fileprivate let getGroupsUseCase: GroupsListUseCaseProtocol
    
    fileprivate let postChannelMessage: FindChannelAndPostMessageUseCaseProtocol
    fileprivate let postUserMessage: FindUserAndPostMessageUseCaseProtocol
    fileprivate let postPrivateChannelMessage: FindGroupAndPostMessageUseCaseProtocol
    
    init(getChannelsUseCase: ChannelsListUseCaseProtocol = ChannelsListUseCase(),
         getUsersUseCase: UsersListUseCaseProtocol = UsersListUseCase(),
         getPrivateChannelsUseCase: GroupsListUseCaseProtocol = GroupsListUseCase(),
         postChannelMessage: FindChannelAndPostMessageUseCaseProtocol = FindChannelAndPostMessageUseCase(),
         postUserMessage: FindUserAndPostMessageUseCaseProtocol = FindUserAndPostMessageUseCase(),
         postPrivateChannelMessage: FindGroupAndPostMessageUseCaseProtocol = FindGroupAndPostMessageUseCase()) {
        self.getChannelsUseCase = getChannelsUseCase
        self.getUsersUseCase = getUsersUseCase
        self.getGroupsUseCase = getPrivateChannelsUseCase
        self.postChannelMessage = postChannelMessage
        self.postUserMessage = postUserMessage
        self.postPrivateChannelMessage = postPrivateChannelMessage
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
}
