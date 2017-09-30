//
//  UserDefaults.swift
//  Slackfari
//
//  Created by Alberto Moral on 02/09/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation

typealias UserDefaultTeams = [[String: String]]
typealias UserDefaultTeam = [String: String]

struct SlackUserDefaultTeam {
    static let key = "teams"
}

func save(teamIcon: String, teamName: String, token: String, refresh: (UserDefaultTeams) -> ()) {
    guard var teams = UserDefaults.standard.array(forKey: SlackUserDefaultTeam.key) as? UserDefaultTeams else {
        UserDefaults.standard.saveTeam(value: [["name": teamName, "token": token, "image": teamIcon]])
        refresh([["name": teamName, "token": token, "image": teamIcon]])
        return
    }
    
    if !arrayContains(array: teams, key: "name", value: teamName) {
        teams.append(["name": teamName, "token": token, "image": teamIcon])
        UserDefaults.standard.saveTeam(value: teams)
    }
    refresh(teams)
}

// MARK: User Defaults Extension

extension UserDefaults {
    func saveTeam(value: UserDefaultTeams) {
        UserDefaults.standard.set(value, forKey: SlackUserDefaultTeam.key)
        UserDefaults.standard.synchronize()
    }
    
    func getTeam() -> UserDefaultTeam? {
        guard let teams = UserDefaults.standard.array(forKey: SlackUserDefaultTeam.key) as? UserDefaultTeams, let firstTeam = teams.first else {
            return nil
        }
        return firstTeam
    }
}
