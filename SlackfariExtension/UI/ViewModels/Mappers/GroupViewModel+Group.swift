/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */


import SlackWebAPIKit

extension GroupViewModel {
    init?(group: Group) {
        guard let name = group.name else { return nil }
        self.name = name
    }
}
