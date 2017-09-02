//
//  TeamViewModel+Team.swift
//  Slackfari
//
//  Created by Alberto Moral on 01/09/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation
import SlackWebAPIKit

extension TeamViewModel {
    init?(team: Team) {
        guard let name = team.name, let icon = team.icon else { return nil }
        self.name = name
        self.icon = icon
    }
}
