//
//  ChannelViewModel+Channel.swift
//  Slackfari
//
//  Created by Alberto Moral on 20/08/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import SlackWebAPIKit

extension ChannelViewModel {
    init?(channel: Channel) {
        guard let name = channel.name else { return nil }
        self.name = name
    }
}
