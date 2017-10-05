/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */

import SlackWebAPIKit

extension ChannelViewModel {
    init?(channel: Channel) {
        guard let name = channel.name else { return nil }
        self.name = name
    }
}
