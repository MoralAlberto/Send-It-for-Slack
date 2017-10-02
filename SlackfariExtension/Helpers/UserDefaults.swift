//
//  UserDefaults.swift
//  Slackfari
//
//  Created by Alberto Moral on 02/09/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation

//typealias UserDefaultTeams = [[String: String]]
//typealias UserDefaultTeam = [String: String]

struct SlackUserDefaultTeam {
    static let key = "teams"
}

func save(teamIcon: String, teamName: String, token: String, refresh: ([TeamModel]) -> ()) {
    guard let decodedTeams = UserDefaults.standard.value(forKey: SlackUserDefaultTeam.key) as? Data,
        var teams = NSKeyedUnarchiver.unarchiveObject(with: decodedTeams) as? [TeamModel]
        else {
            let team = TeamModel(name: teamName, token: token, imageIcon: teamIcon)
            UserDefaults.standard.saveTeam(value: [team])
            refresh([team])
            return
    }
    
    let team = TeamModel(name: teamName, token: token, imageIcon: teamIcon)
    if !arrayContains(teams: teams, value: teamName).0 {
        teams.append(team)
        UserDefaults.standard.saveTeam(value: teams)
    }
    refresh(teams)
}

// MARK: User Defaults Extension

extension UserDefaults {
    func saveTeam(value: [TeamModel]) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: value)
        UserDefaults.standard.set(encodedData, forKey: SlackUserDefaultTeam.key)
        UserDefaults.standard.synchronize()
    }
    
    func removeTeam(withName name: String, completion: @escaping (Int) -> Void) {
        guard let decodedTeams = UserDefaults.standard.value(forKey: SlackUserDefaultTeam.key) as? Data,
            var teams = NSKeyedUnarchiver.unarchiveObject(with: decodedTeams) as? [TeamModel]
        else { return }
        
        let value = arrayContains(teams: teams, value: name)
        if value.hasKey, let position = value.position {
            teams.remove(at: position)
            UserDefaults.standard.saveTeam(value: teams)
            completion(position)
        }
    }
    
    func getTeam() -> TeamModel? {
        guard let decodedTeams = UserDefaults.standard.value(forKey: SlackUserDefaultTeam.key) as? Data,
            let teams = NSKeyedUnarchiver.unarchiveObject(with: decodedTeams) as? [TeamModel],
            let firstTeam = teams.first else {
            return nil
        }
        return firstTeam
    }
    
    func getTeams() -> [TeamModel]? {
        guard let decodedTeams = UserDefaults.standard.value(forKey: SlackUserDefaultTeam.key) as? Data,
            let teams = NSKeyedUnarchiver.unarchiveObject(with: decodedTeams) as? [TeamModel] else {
                return nil
        }
        return teams
    }
}
