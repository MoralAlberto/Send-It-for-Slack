//
//  UserDefaults.swift
//  Slackfari
//
//  Created by Alberto Moral on 02/09/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation

typealias UserDefaultTeam = [[String: String]]

struct SlackUserDefaultTeam {
    static let key = "teams"
}

func save(teamIcon: String, teamName: String, token: String, refresh: (UserDefaultTeam) -> ()) {
    guard var teams = UserDefaults.standard.array(forKey: SlackUserDefaultTeam.key) as? [[String: String]] else {
        UserDefaults.standard.saveTeam(value: [["name": teamName, "token": token, "image": teamIcon]])
        refresh([["name": teamName, "token": token, "image": teamIcon]])
        return
    }
    
    if !arrayContains(array: teams, key: "name", value: teamName) {
        teams.append(["name": teamName, "token": token, "image": teamIcon])
        UserDefaults.standard.saveTeam(value: [["name": teamName, "token": token, "image": teamIcon]])
    }
    refresh(teams)
}

// MARK: User Defaults Extension

extension UserDefaults {
    func saveTeam(value: UserDefaultTeam) {
        UserDefaults.standard.set(value, forKey: SlackUserDefaultTeam.key)
        UserDefaults.standard.synchronize()
    }
}
