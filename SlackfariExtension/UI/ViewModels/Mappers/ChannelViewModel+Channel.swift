//
//  ChannelViewModel+Channel.swift
//  Slackfari
//
//  Created by Alberto Moral on 20/08/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation
import SlackWebAPIKit

extension ChannelViewModel {
    init(channel: Channel) {
        self.name = channel.name ?? ""
    }
}
