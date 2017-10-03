/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */


import SlackWebAPIKit

extension TeamViewModel {
    init?(team: Team) {
        guard let name = team.name, let icon = team.icon else { return nil }
        self.name = name
        self.icon = icon
    }
}
