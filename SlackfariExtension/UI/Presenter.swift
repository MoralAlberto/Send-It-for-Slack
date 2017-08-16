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
    
    init(getChannelsUseCase: ChannelsListUseCaseProtocol = ChannelsListUseCase()) {
        self.getChannelsUseCase = getChannelsUseCase
    }
    
    func getChannels() -> Observable<[Channel]> {
        return getChannelsUseCase.execute()
    }
}
