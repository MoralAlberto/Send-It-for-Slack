/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */


import SlackWebAPIKit

extension UserViewModel {
    init?(user: User) {
        guard let name = user.name else { return nil }
        self.name = name
    }
}
