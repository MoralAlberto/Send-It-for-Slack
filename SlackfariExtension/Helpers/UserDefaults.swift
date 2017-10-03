/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

struct SlackUserDefaultTeam {
    static let key = "teams"
}

func save(name: String, token: String, icon: String, refresh: ([TeamModel]) -> ()) {
    guard var teams = UserDefaults.standard.getTeams() else {
        let team = TeamModel(name: name, token: token, imageIcon: icon)
        UserDefaults.standard.saveTeam(value: [team])
        refresh([team])
        return
    }
    
    let team = TeamModel(name: name, token: token, imageIcon: icon)
    if !arrayContains(teams: teams, value: name).hasKey {
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
        guard var teams = getTeams() else { return }
        let value = arrayContains(teams: teams, value: name)
        if value.hasKey, let position = value.position {
            teams.remove(at: position)
            UserDefaults.standard.saveTeam(value: teams)
            completion(position)
        }
    }
    
    func getTeam() -> TeamModel? {
        guard let teams = getTeams(), let firstTeam = teams.first else {
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
