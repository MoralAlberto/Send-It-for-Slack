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

class Presenter {
    
    fileprivate let getChannelsUseCase: ChannelsListUseCaseProtocol
    fileprivate let postChannelMessage: FindChannelAndPostMessageUseCaseProtocol
    
    init(getChannelsUseCase: ChannelsListUseCaseProtocol = ChannelsListUseCase(),
         postChannelMessage: FindChannelAndPostMessageUseCaseProtocol = FindChannelAndPostMessageUseCase()) {
        self.getChannelsUseCase = getChannelsUseCase
        self.postChannelMessage = postChannelMessage
    }
    
    func getChannels() -> Observable<[Channel]> {
        return getChannelsUseCase.execute()
    }
    
    func send(message: String, channel: String) -> Observable<Bool> {
        return postChannelMessage.execute(text: message, channel: channel)
    }
}
