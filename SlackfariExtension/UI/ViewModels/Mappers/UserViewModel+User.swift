//
//  UserViewModel+User.swift
//  Slackfari
//
//  Created by Alberto Moral on 20/08/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import SlackWebAPIKit

extension UserViewModel {
    init?(user: User) {
        guard let name = user.name else { return nil }
        self.name = name
    }
}
